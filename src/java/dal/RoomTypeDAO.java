package dal;

import model.RoomType;
import context.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.sql.Date;
import java.time.LocalDate;


public class RoomTypeDAO {
    // ===== Search by room quantity (available rooms in date range) =====
// ===== Search by room quantity (available rooms in date range) =====
private static final String SQL_SEARCH_QTY_WITH_RATE_TEMPLATE =
        "SELECT TOP (%d) " +
        "  rt.room_type_id, rt.name, rt.description, rt.max_adult, rt.max_children, rt.image_url, rt.status, " +
        "  rv.price AS price_today, " +
        "  x.available_rooms " +
        "FROM dbo.room_types rt " +
        "JOIN ( " +
        "   SELECT r.room_type_id, " +
        "          COUNT(DISTINCT r.room_id) - COUNT(DISTINCT br.room_id) AS available_rooms " +
        "   FROM dbo.rooms r " +
        "   LEFT JOIN dbo.booking_rooms br ON br.room_id = r.room_id " +
        "   LEFT JOIN dbo.bookings b ON b.booking_id = br.booking_id " +
        "     AND b.status IN (1,2) " +  // TODO: sửa theo status của bạn (ví dụ CONFIRMED/CHECKED_IN)
        "     AND NOT (b.check_out <= ? OR b.check_in >= ?) " +
        "   GROUP BY r.room_type_id " +
        ") x ON x.room_type_id = rt.room_type_id " +
        "OUTER APPLY ( " +
        "   SELECT TOP 1 price, valid_from, valid_to, rate_version_id " +
        "   FROM dbo.rate_versions " +
        "   WHERE room_type_id = rt.room_type_id " +
        "     AND ? BETWEEN valid_from AND valid_to " +
        "   ORDER BY valid_from DESC, rate_version_id DESC " +
        ") rv " +
        "WHERE rt.status = 1 " +
        "  AND x.available_rooms >= ? " +
        "ORDER BY x.available_rooms DESC, rt.room_type_id DESC";

private static final String SQL_SEARCH_QTY_NO_RATE_TEMPLATE =
        "SELECT TOP (%d) " +
        "  rt.room_type_id, rt.name, rt.description, rt.max_adult, rt.max_children, rt.image_url, rt.status, " +
        "  x.available_rooms " +
        "FROM dbo.room_types rt " +
        "JOIN ( " +
        "   SELECT r.room_type_id, " +
        "          COUNT(DISTINCT r.room_id) - COUNT(DISTINCT br.room_id) AS available_rooms " +
        "   FROM dbo.rooms r " +
        "   LEFT JOIN dbo.booking_rooms br ON br.room_id = r.room_id " +
        "   LEFT JOIN dbo.bookings b ON b.booking_id = br.booking_id " +
        "     AND b.status IN (1,2) " +  // TODO: sửa theo status của bạn
        "     AND NOT (b.check_out <= ? OR b.check_in >= ?) " +
        "   GROUP BY r.room_type_id " +
        ") x ON x.room_type_id = rt.room_type_id " +
        "WHERE rt.status = 1 " +
        "  AND x.available_rooms >= ? " +
        "ORDER BY x.available_rooms DESC, rt.room_type_id DESC";


// Dùng TOP (%d) để tránh driver kén TOP (?)
private static final String SQL_WITH_RATE_TEMPLATE
        = "SELECT TOP (%d) "
        + "    rt.room_type_id, rt.name, rt.description, rt.max_adult, rt.max_children, rt.image_url, rt.status, "
        + "    rv.price AS price_today "
        + "FROM dbo.room_types rt "
        + "OUTER APPLY ( "
        + "    SELECT TOP 1 price, valid_from, valid_to, rate_version_id "
        + "    FROM dbo.rate_versions "
        + "    WHERE room_type_id = rt.room_type_id "
        + "      AND CAST(GETDATE() AS date) BETWEEN valid_from AND valid_to "
        + "    ORDER BY valid_from DESC, rate_version_id DESC "
        + ") rv "
        + "WHERE rt.status = 1 "
        + "ORDER BY rt.room_type_id DESC";

private static final String SQL_NO_RATE_TEMPLATE
        = "SELECT TOP (%d) "
        + "    room_type_id, name, description, max_adult, max_children, image_url, status "
        + "FROM dbo.room_types "
        + "WHERE status = 1 "
        + "ORDER BY room_type_id DESC";

    
    

    public List<RoomType> getActiveRoomTypesForHome(int limit) {
        List<RoomType> withRate = new ArrayList<>();

        // 1) Thử WITH_RATE
        try {
            withRate = fetch(limit, true);
        } catch (Exception ex) {
            System.out.println("⚠️ WITH_RATE failed -> fallback NO_RATE");
            ex.printStackTrace();
        }

        // ✅ Nếu WITH_RATE KHÔNG lỗi nhưng trả về 0 -> vẫn fallback
        if (withRate != null && !withRate.isEmpty()) {
            return withRate;
        }

        // 2) Fallback NO_RATE
        try {
            return fetch(limit, false);
        } catch (Exception ex2) {
            System.out.println("❌ NO_RATE failed");
            ex2.printStackTrace();
            return new ArrayList<>();
        }
    }
    public List<RoomType> searchByRoomQty(LocalDate checkIn, LocalDate checkOut, int roomQty, int limit) {
    List<RoomType> withRate = new ArrayList<>();

    try {
        withRate = fetchSearchQty(limit, true, checkIn, checkOut, roomQty);
    } catch (Exception ex) {
        System.out.println("⚠️ SEARCH_QTY WITH_RATE failed -> fallback NO_RATE");
        ex.printStackTrace();
    }

    if (withRate != null && !withRate.isEmpty()) return withRate;

    try {
        return fetchSearchQty(limit, false, checkIn, checkOut, roomQty);
    } catch (Exception ex2) {
        System.out.println("❌ SEARCH_QTY NO_RATE failed");
        ex2.printStackTrace();
        return new ArrayList<>();
    }
}
private List<RoomType> fetchSearchQty(int limit, boolean withRate,
                                     LocalDate checkIn, LocalDate checkOut, int roomQty) throws Exception {

    List<RoomType> list = new ArrayList<>();
    DBContext db = new DBContext();

    if (db.connection == null) {
        throw new Exception("DB connection is NULL (DBContext failed). Check DBContext config / JDBC driver.");
    }

    String sql = withRate
            ? String.format(SQL_SEARCH_QTY_WITH_RATE_TEMPLATE, limit)
            : String.format(SQL_SEARCH_QTY_NO_RATE_TEMPLATE, limit);

    try (Connection con = db.connection; PreparedStatement ps = con.prepareStatement(sql)) {

        // Debug: connect nhầm DB là biết ngay
        try (ResultSet rdb = con.createStatement().executeQuery("SELECT DB_NAME() AS dbname")) {
            if (rdb.next()) {
                System.out.println("✅ Connected DB = " + rdb.getString("dbname"));
            }
        }

        int idx = 1;

        // NOT (b.check_out <= checkIn OR b.check_in >= checkOut)
        ps.setDate(idx++, Date.valueOf(checkIn));
        ps.setDate(idx++, Date.valueOf(checkOut));

        if (withRate) {
            // OUTER APPLY rate_versions theo ngày checkIn (đỡ lệch GETDATE)
            ps.setDate(idx++, Date.valueOf(checkIn));
        }

        ps.setInt(idx++, roomQty);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                RoomType rt = new RoomType();
                rt.setRoomTypeId(rs.getInt("room_type_id"));
                rt.setName(rs.getString("name"));
                rt.setDescription(rs.getString("description"));
                rt.setMaxAdult(rs.getInt("max_adult"));
                rt.setMaxChildren(rs.getInt("max_children"));
                rt.setImageUrl(rs.getString("image_url"));
                rt.setStatus(rs.getInt("status"));

                if (withRate) {
                    rt.setPriceToday(rs.getBigDecimal("price_today")); // có thể null
                } else {
                    rt.setPriceToday(null);
                }
                list.add(rt);
            }
        }
    }

    System.out.println("✅ Loaded search roomTypes = " + list.size() + " (withRate=" + withRate + ")");
    return list;
}


    private List<RoomType> fetch(int limit, boolean withRate) throws Exception {
        List<RoomType> list = new ArrayList<>();
        DBContext db = new DBContext();

        if (db.connection == null) {
            throw new Exception("DB connection is NULL (DBContext failed). Check DBContext config / JDBC driver.");
        }

        String sql = withRate
                ? String.format(SQL_WITH_RATE_TEMPLATE, limit)
                : String.format(SQL_NO_RATE_TEMPLATE, limit);

        try (Connection con = db.connection; PreparedStatement ps = con.prepareStatement(sql)) {
            try (ResultSet rdb = con.createStatement().executeQuery("SELECT DB_NAME() AS dbname")) {
                if (rdb.next()) {
                    System.out.println("✅ Connected DB = " + rdb.getString("dbname"));
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RoomType rt = new RoomType();
                    rt.setRoomTypeId(rs.getInt("room_type_id"));
                    rt.setName(rs.getString("name"));
                    rt.setDescription(rs.getString("description"));
                    rt.setMaxAdult(rs.getInt("max_adult"));
                    rt.setMaxChildren(rs.getInt("max_children"));
                    rt.setImageUrl(rs.getString("image_url"));
                    rt.setStatus(rs.getInt("status"));

                    if (withRate) {
                        rt.setPriceToday(rs.getBigDecimal("price_today")); 
                    } else {
                        rt.setPriceToday(null);
                    }

                    list.add(rt);
                }
            }
        }

        System.out.println("✅ Loaded roomTypes = " + list.size() + " (withRate=" + withRate + ")");
        return list;
    }
}

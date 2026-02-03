package dal;

import model.RoomType;
import context.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RoomTypeDAO {

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

            // Debug: connect nhầm DB là biết ngay
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
                        rt.setPriceToday(rs.getBigDecimal("price_today")); // có thể null
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

package dal;

import context.DBContext;
import model.StaffRoomItem;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class StaffRoomDAO extends DBContext {

    public List<StaffRoomItem> getRooms(String keyword, Integer status) throws Exception {
        List<StaffRoomItem> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
            SELECT r.room_id,
                   r.room_no,
                   r.floor,
                   r.status,
                   rt.name AS room_type_name,
                   NULL AS note
            FROM rooms r
            JOIN room_types rt ON r.room_type_id = rt.room_type_id
            WHERE 1 = 1
        """);

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND r.room_no LIKE ? ");
        }

        if (status != null) {
            sql.append(" AND r.status = ? ");
        }

        sql.append(" ORDER BY r.floor, r.room_no ");

        PreparedStatement ps = connection.prepareStatement(sql.toString());

        int index = 1;
        if (keyword != null && !keyword.trim().isEmpty()) {
            ps.setString(index++, "%" + keyword.trim() + "%");
        }
        if (status != null) {
            ps.setInt(index++, status);
        }

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            StaffRoomItem item = new StaffRoomItem();
            item.setRoomId(rs.getInt("room_id"));
            item.setRoomNo(rs.getString("room_no"));
            item.setFloor(rs.getInt("floor"));
            item.setStatus(rs.getInt("status"));
            item.setRoomTypeName(rs.getString("room_type_name"));
            item.setNote(rs.getString("note"));
            list.add(item);
        }

        return list;
    }

    public int countByStatus(int status) throws Exception {
        String sql = "SELECT COUNT(*) FROM rooms WHERE status = ?";
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, status);
        ResultSet rs = ps.executeQuery();
        return rs.next() ? rs.getInt(1) : 0;
    }

public boolean updateRoomStatus(int roomId, int newStatus) {
    final int STATUS_MAINTENANCE = 3;

    String sqlGet = "SELECT room_type_id, status FROM rooms WHERE room_id = ?";
    String sqlUpdateRoom = "UPDATE rooms SET status = ? WHERE room_id = ?";

    String sqlDecreaseInventory = "UPDATE room_type_inventory "
            + "SET total_rooms = total_rooms - 1 "
            + "WHERE room_type_id = ? "
            + "AND inventory_date >= CAST(GETDATE() AS DATE) "
            + "AND total_rooms > 0";

    String sqlIncreaseInventory = "UPDATE room_type_inventory "
            + "SET total_rooms = total_rooms + 1 "
            + "WHERE room_type_id = ? "
            + "AND inventory_date >= CAST(GETDATE() AS DATE)";

    try {
        connection = getConnection();
        connection.setAutoCommit(false);

        int roomTypeId = -1;
        int oldStatus = -1;

        try (PreparedStatement stGet = connection.prepareStatement(sqlGet)) {
            stGet.setInt(1, roomId);
            try (ResultSet rs = stGet.executeQuery()) {
                if (rs.next()) {
                    roomTypeId = rs.getInt("room_type_id");
                    oldStatus = rs.getInt("status");
                }
            }
        }

        if (roomTypeId == -1 || oldStatus == -1) {
            connection.rollback();
            return false;
        }

        try (PreparedStatement stUpdate = connection.prepareStatement(sqlUpdateRoom)) {
            stUpdate.setInt(1, newStatus);
            stUpdate.setInt(2, roomId);

            if (stUpdate.executeUpdate() == 0) {
                connection.rollback();
                return false;
            }
        }

        boolean oldIsMaintenance = (oldStatus == STATUS_MAINTENANCE);
        boolean newIsMaintenance = (newStatus == STATUS_MAINTENANCE);

        if (!oldIsMaintenance && newIsMaintenance) {
            try (PreparedStatement stDec = connection.prepareStatement(sqlDecreaseInventory)) {
                stDec.setInt(1, roomTypeId);
                stDec.executeUpdate();
            }
        } else if (oldIsMaintenance && !newIsMaintenance) {
            try (PreparedStatement stInc = connection.prepareStatement(sqlIncreaseInventory)) {
                stInc.setInt(1, roomTypeId);
                stInc.executeUpdate();
            }
        }

        connection.commit();
        return true;

    } catch (Exception e) {
        try {
            if (connection != null) {
                connection.rollback();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        e.printStackTrace();
    } finally {
        try {
            if (connection != null) {
                connection.setAutoCommit(true);
                connection.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    return false;
}
    public List<StaffRoomItem> getRooms(String keyword, Integer status, int page, int pageSize) throws Exception {

    List<StaffRoomItem> list = new ArrayList<>();

    StringBuilder sql = new StringBuilder("""
        SELECT r.room_id,
               r.room_no,
               r.floor,
               r.status,
               rt.name AS room_type_name
        FROM rooms r
        JOIN room_types rt ON r.room_type_id = rt.room_type_id
        WHERE 1=1
    """);

    if (keyword != null && !keyword.trim().isEmpty()) {
        sql.append(" AND r.room_no LIKE ? ");
    }

    if (status != null) {
        sql.append(" AND r.status = ? ");
    }

    sql.append("""
        ORDER BY r.room_no
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """);

    PreparedStatement ps = connection.prepareStatement(sql.toString());

    int index = 1;

    if (keyword != null && !keyword.trim().isEmpty()) {
        ps.setString(index++, "%" + keyword + "%");
    }

    if (status != null) {
        ps.setInt(index++, status);
    }

    ps.setInt(index++, (page - 1) * pageSize);
    ps.setInt(index++, pageSize);

    ResultSet rs = ps.executeQuery();

    while (rs.next()) {
        StaffRoomItem r = new StaffRoomItem();
        r.setRoomId(rs.getInt("room_id"));
        r.setRoomNo(rs.getString("room_no"));
        r.setFloor(rs.getInt("floor"));
        r.setStatus(rs.getInt("status"));
        r.setRoomTypeName(rs.getString("room_type_name"));
        list.add(r);
    }

    return list;
}
    public int countRooms(String keyword, Integer status) throws Exception {

    StringBuilder sql = new StringBuilder("""
        SELECT COUNT(*)
        FROM rooms r
        WHERE 1=1
    """);

    if (keyword != null && !keyword.trim().isEmpty()) {
        sql.append(" AND r.room_no LIKE ? ");
    }

    if (status != null) {
        sql.append(" AND r.status = ? ");
    }

    PreparedStatement ps = connection.prepareStatement(sql.toString());

    int index = 1;

    if (keyword != null && !keyword.trim().isEmpty()) {
        ps.setString(index++, "%" + keyword + "%");
    }

    if (status != null) {
        ps.setInt(index++, status);
    }

    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        return rs.getInt(1);
    }

    return 0;
}
    
    
}
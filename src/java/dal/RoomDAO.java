/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Room;

/**
 *
 * @author ASUS
 */
public class RoomDAO extends DBContext {

    public List<Room> searchRoom(String keyword, String status, String roomType, int pageIndex, int pageSize) {
        List<Room> listRoom = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT r.room_id, r.room_no, r.room_type_id, r.status, r.floor, "
                + "       rt.name AS room_type_name, "
                + "       pricePick.price "
                + "FROM rooms r "
                + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
                + "OUTER APPLY ( "
                + "    SELECT TOP 1 rv.price "
                + "    FROM rate_versions rv "
                + "    WHERE rv.room_type_id = rt.room_type_id "
                + "    ORDER BY rv.valid_from DESC "
                + ") pricePick "
                + "WHERE 1=1 "
        );

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND r.room_no LIKE ? ");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND r.status = ? ");
        }
        if (roomType != null && !roomType.isEmpty()) {
            sql.append(" AND rt.name = ? ");
        }

        sql.append(" ORDER BY r.room_id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try {
            connection = getConnection();
            PreparedStatement st = connection.prepareStatement(sql.toString());

            int index = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                st.setString(index++, "%" + keyword.trim() + "%");
            }
            if (status != null && !status.isEmpty()) {
                st.setInt(index++, Integer.parseInt(status));
            }
            if (roomType != null && !roomType.isEmpty()) {
                st.setString(index++, roomType);
            }

            st.setInt(index++, (pageIndex - 1) * pageSize);
            st.setInt(index++, pageSize);

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomNo(rs.getString("room_no"));
                room.setRoomTypeId(rs.getInt("room_type_id"));
                room.setStatus(rs.getInt("status"));
                room.setFloor(rs.getInt("floor"));
                room.setPrice(rs.getDouble("price"));
                room.setRoomTypeName(rs.getString("room_type_name"));
                listRoom.add(room);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return listRoom;
    }

    public int getTotalRoomCount(String keyword, String status, String roomType) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) "
                + "FROM rooms r "
                + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
                + "WHERE 1=1 "
        );

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND r.room_no LIKE ? ");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND r.status = ? ");
        }
        if (roomType != null && !roomType.isEmpty()) {
            sql.append(" AND rt.name = ? ");
        }

        try {
            connection = getConnection();
            PreparedStatement st = connection.prepareStatement(sql.toString());

            int index = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                st.setString(index++, "%" + keyword.trim() + "%");
            }
            if (status != null && !status.isEmpty()) {
                st.setInt(index++, Integer.parseInt(status));
            }
            if (roomType != null && !roomType.isEmpty()) {
                st.setString(index++, roomType);
            }

            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public List<Room> getAllRoomTypes() {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT room_type_id, name FROM room_types ORDER BY name";

        try {
            connection = getConnection();
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Room r = new Room();
                r.setRoomTypeId(rs.getInt("room_type_id"));
                r.setRoomTypeName(rs.getString("name"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean isRoomNoExists(String roomNo) {
        String sql = "SELECT COUNT(*) FROM rooms WHERE room_no = ?";

        try {
            connection = getConnection();
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, roomNo);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean isRoomTypeExists(int roomTypeId) {
        String sql = "SELECT COUNT(*) FROM room_types WHERE room_type_id = ?";

        try {
            connection = getConnection();
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, roomTypeId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public int getRoomTypeIdByRoomId(int roomId) {
        String sql = "SELECT room_type_id FROM rooms WHERE room_id = ?";

        try {
            connection = getConnection();
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, roomId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getInt("room_type_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    /**
     * Cách 1:
     * total_rooms = COUNT(*) số phòng thực tế của room_type đó
     *
     * Hiện tại hệ thống của bạn chỉ có status 1..4 và chưa có inactive/disabled,
     * nên tạm thời count tất cả rooms của room_type đó.
     *
     * Sau này nếu có status "inactive" thì sửa COUNT(*) thành WHERE status <> ...
     */
    public void syncInventoryTotalRoomsByRoomType(int roomTypeId) {
        String sqlCount = "SELECT COUNT(*) FROM rooms WHERE room_type_id = ?";
        String sqlUpdateInventory = "UPDATE room_type_inventory "
                + "SET total_rooms = ? "
                + "WHERE room_type_id = ? "
                + "AND inventory_date >= CAST(GETDATE() AS DATE)";

        try {
            connection = getConnection();

            int totalRooms = 0;

            try (PreparedStatement stCount = connection.prepareStatement(sqlCount)) {
                stCount.setInt(1, roomTypeId);
                try (ResultSet rs = stCount.executeQuery()) {
                    if (rs.next()) {
                        totalRooms = rs.getInt(1);
                    }
                }
            }

            try (PreparedStatement stUpdate = connection.prepareStatement(sqlUpdateInventory)) {
                stUpdate.setInt(1, totalRooms);
                stUpdate.setInt(2, roomTypeId);
                stUpdate.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean createRoom(Room room) {
        String sqlInsert = "INSERT INTO rooms (room_no, room_type_id, status, floor) VALUES (?, ?, ?, ?)";

        try {
            connection = getConnection();
            connection.setAutoCommit(false);

            try (PreparedStatement stInsert = connection.prepareStatement(sqlInsert)) {
                stInsert.setString(1, room.getRoomNo());
                stInsert.setInt(2, room.getRoomTypeId());
                stInsert.setInt(3, room.getStatus());
                stInsert.setInt(4, room.getFloor());
                stInsert.executeUpdate();

                // Đồng bộ total_rooms theo COUNT(*) thực tế
                syncInventoryTotalRoomsByRoomTypeTx(room.getRoomTypeId());

                connection.commit();
                return true;
            } catch (Exception e) {
                connection.rollback();
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (Exception e) {
            }
        }

        return false;
    }

    public Room getRoomById(int roomId) {
        String sql = "SELECT r.room_id, r.room_no, r.room_type_id, r.status, r.floor, "
                + "       rt.name AS room_type_name, "
                + "       pricePick.price "
                + "FROM rooms r "
                + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
                + "OUTER APPLY ( "
                + "    SELECT TOP 1 rv.price "
                + "    FROM rate_versions rv "
                + "    WHERE rv.room_type_id = rt.room_type_id "
                + "    ORDER BY rv.valid_from DESC "
                + ") pricePick "
                + "WHERE r.room_id = ?";

        try {
            connection = getConnection();
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, roomId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomNo(rs.getString("room_no"));
                room.setRoomTypeId(rs.getInt("room_type_id"));
                room.setStatus(rs.getInt("status"));
                room.setFloor(rs.getInt("floor"));
                room.setPrice(rs.getDouble("price"));
                room.setRoomTypeName(rs.getString("room_type_name"));
                return room;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean isRoomNoExistsForOtherRoom(String roomNo, int roomId) {
        String sql = "SELECT COUNT(*) FROM rooms WHERE room_no = ? AND room_id <> ?";

        try {
            connection = getConnection();
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, roomNo);
            st.setInt(2, roomId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateRoom(Room room) {
        String sqlGetOld = "SELECT room_type_id FROM rooms WHERE room_id = ?";
        String sqlUpdate = "UPDATE rooms SET room_no = ?, room_type_id = ?, status = ?, floor = ? WHERE room_id = ?";

        try {
            connection = getConnection();
            connection.setAutoCommit(false);

            int oldTypeId = -1;

            try (PreparedStatement stOld = connection.prepareStatement(sqlGetOld)) {
                stOld.setInt(1, room.getRoomId());
                ResultSet rs = stOld.executeQuery();
                if (rs.next()) {
                    oldTypeId = rs.getInt("room_type_id");
                }
            }

            if (oldTypeId == -1) {
                connection.rollback();
                return false;
            }

            try (PreparedStatement stUpd = connection.prepareStatement(sqlUpdate)) {
                stUpd.setString(1, room.getRoomNo());
                stUpd.setInt(2, room.getRoomTypeId());
                stUpd.setInt(3, room.getStatus());
                stUpd.setInt(4, room.getFloor());
                stUpd.setInt(5, room.getRoomId());

                int affected = stUpd.executeUpdate();
                if (affected == 0) {
                    connection.rollback();
                    return false;
                }
            }

            // Đồng bộ inventory theo COUNT(*) thực tế
            syncInventoryTotalRoomsByRoomTypeTx(oldTypeId);

            if (oldTypeId != room.getRoomTypeId()) {
                syncInventoryTotalRoomsByRoomTypeTx(room.getRoomTypeId());
            }

            connection.commit();
            return true;

        } catch (Exception e) {
            try {
                connection.rollback();
            } catch (Exception ex) {
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (Exception e) {
            }
        }

        return false;
    }

    /**
     * Hàm sync dùng bên trong transaction hiện tại
     */
    private void syncInventoryTotalRoomsByRoomTypeTx(int roomTypeId) throws Exception {
        String sqlCount = "SELECT COUNT(*) FROM rooms WHERE room_type_id = ?";
        String sqlUpdateInventory = "UPDATE room_type_inventory "
                + "SET total_rooms = ? "
                + "WHERE room_type_id = ? "
                + "AND inventory_date >= CAST(GETDATE() AS DATE)";

        int totalRooms = 0;

        try (PreparedStatement stCount = connection.prepareStatement(sqlCount)) {
            stCount.setInt(1, roomTypeId);
            try (ResultSet rs = stCount.executeQuery()) {
                if (rs.next()) {
                    totalRooms = rs.getInt(1);
                }
            }
        }

        try (PreparedStatement stUpdate = connection.prepareStatement(sqlUpdateInventory)) {
            stUpdate.setInt(1, totalRooms);
            stUpdate.setInt(2, roomTypeId);
            stUpdate.executeUpdate();
        }
    }
}
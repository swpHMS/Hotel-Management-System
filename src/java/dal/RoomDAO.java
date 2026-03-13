/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import java.util.List;
import model.Room;
import context.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
/**
 *
 * @author ASUS
 */
public class RoomDAO extends DBContext{
    
    public List<Room> searchRoom(String keyword, String status, String roomType, int pageIndex, int pageSize) {
    List<Room> listRoom = new ArrayList<>();
    StringBuilder sql = new StringBuilder("SELECT r.room_id, r.room_no, r.room_type_id, r.status, r.floor, "
            + "rt.name AS room_type_name, rv.price "
            + "FROM rooms r "
            + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
            + "LEFT JOIN rate_versions rv ON rt.room_type_id = rv.room_type_id "
            + "WHERE 1=1 ");

    if (keyword != null && !keyword.trim().isEmpty()) sql.append(" AND r.room_no LIKE ? ");
    if (status != null && !status.isEmpty()) sql.append(" AND r.status = ? ");
    if (roomType != null && !roomType.isEmpty()) sql.append(" AND rt.name = ? ");

    
    sql.append(" ORDER BY r.room_id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

    try {
        connection = getConnection();
        PreparedStatement st = connection.prepareStatement(sql.toString());
        int index = 1;
        if (keyword != null && !keyword.trim().isEmpty()) st.setString(index++, "%" + keyword + "%");
        if (status != null && !status.isEmpty()) st.setInt(index++, Integer.parseInt(status));
        if (roomType != null && !roomType.isEmpty()) st.setString(index++, roomType);

        // Gán vị trí bắt đầu (ví dụ: trang 1 lấy từ dòng 0, trang 2 lấy từ dòng 10)
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
    } catch (Exception e) { e.printStackTrace(); }
    return listRoom;
}


public int getTotalRoomCount(String keyword, String status, String roomType) {
    StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM rooms r JOIN room_types rt ON r.room_type_id = rt.room_type_id WHERE 1=1 ");
    if (keyword != null && !keyword.trim().isEmpty()) sql.append(" AND r.room_no LIKE ? ");
    if (status != null && !status.isEmpty()) sql.append(" AND r.status = ? ");
    if (roomType != null && !roomType.isEmpty()) sql.append(" AND rt.name = ? ");

    try {
        connection = getConnection();
        PreparedStatement st = connection.prepareStatement(sql.toString());
        int index = 1;
        if (keyword != null && !keyword.trim().isEmpty()) st.setString(index++, "%" + keyword + "%");
        if (status != null && !status.isEmpty()) st.setInt(index++, Integer.parseInt(status));
        if (roomType != null && !roomType.isEmpty()) st.setString(index++, roomType);
        ResultSet rs = st.executeQuery();
        if (rs.next()) return rs.getInt(1);
    } catch (Exception e) { }
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

    public boolean createRoom(Room room) {
        String sql = "INSERT INTO rooms (room_no, room_type_id, status, floor) VALUES (?, ?, ?, ?)";

        try {
            connection = getConnection();
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, room.getRoomNo());
            st.setInt(2, room.getRoomTypeId());
            st.setInt(3, room.getStatus());
            st.setInt(4, room.getFloor());

            return st.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    
    public Room getRoomById(int roomId) {
    String sql = "SELECT r.room_id, r.room_no, r.room_type_id, r.status, r.floor, "
            + "rt.name AS room_type_name, rv.price "
            + "FROM rooms r "
            + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
            + "LEFT JOIN rate_versions rv ON rt.room_type_id = rv.room_type_id "
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


}

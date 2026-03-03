package dal;

import model.Amenity;
import context.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AmenityDAO {

    public List<Amenity> getActiveAmenitiesForHome(int limit) {

        String sql = """
            SELECT TOP (?)
                amenity_id, code, name, description, category, is_active
            FROM dbo.amenities
            WHERE is_active = 1
            ORDER BY amenity_id DESC
        """;

        List<Amenity> list = new ArrayList<>();

        DBContext db = new DBContext();
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Amenity a = new Amenity();
                    a.setAmenityId(rs.getInt("amenity_id"));
                    a.setCode(rs.getString("code"));
                    a.setName(rs.getString("name"));
                    a.setDescription(rs.getString("description"));
                    a.setCategory(rs.getInt("category"));
                    a.setActive(rs.getBoolean("is_active"));
                    list.add(a);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ✅ NEW: lấy danh sách Amenity theo room_type_id (để gắn vào từng RoomType)
    public List<Amenity> getAmenitiesByRoomType(int roomTypeId) {
        String sql = """
            SELECT a.amenity_id, a.code, a.name, a.description, a.category, a.is_active
            FROM dbo.amenities a
            JOIN dbo.room_type_amenities rta
              ON rta.amenity_id = a.amenity_id
            WHERE rta.room_type_id = ?
              AND a.is_active = 1
            ORDER BY a.name
        """;

        List<Amenity> list = new ArrayList<>();
        DBContext db = new DBContext();

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, roomTypeId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Amenity a = new Amenity();
                    a.setAmenityId(rs.getInt("amenity_id"));
                    a.setCode(rs.getString("code"));
                    a.setName(rs.getString("name"));
                    a.setDescription(rs.getString("description"));
                    a.setCategory(rs.getInt("category"));
                    a.setActive(rs.getBoolean("is_active"));
                    list.add(a);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ✅ NEW: tiện cho JSP data-amenities="a|b|c" (khỏi map ở JSP)
    public List<String> getAmenityNamesByRoomType(int roomTypeId) {
        String sql = """
            SELECT a.name
            FROM dbo.amenities a
            JOIN dbo.room_type_amenities rta
              ON rta.amenity_id = a.amenity_id
            WHERE rta.room_type_id = ?
              AND a.is_active = 1
            ORDER BY a.name
        """;

        List<String> list = new ArrayList<>();
        DBContext db = new DBContext();

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, roomTypeId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getString("name"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}

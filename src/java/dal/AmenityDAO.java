
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
        try (
                Connection con = db.connection; PreparedStatement ps = con.prepareStatement(sql)) {
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
}

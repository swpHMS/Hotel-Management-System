package dal;

import model.HotelInformation;
import context.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class HotelInformationDAO {

    private static final String SQL
            = "SELECT TOP 1 hotel_id, name, content, address, phone, email, check_in, check_out "
            + "FROM dbo.hotel_information";

    public HotelInformation getSingleHotel() {
        DBContext db = new DBContext();

        try (Connection con = db.connection; PreparedStatement ps = con.prepareStatement(SQL); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                HotelInformation h = new HotelInformation();
                h.setHotelId(rs.getInt("hotel_id"));
                h.setName(rs.getString("name"));
                h.setContent(rs.getString("content"));
                h.setAddress(rs.getString("address"));
                h.setPhone(rs.getString("phone"));
                h.setEmail(rs.getString("email"));
                h.setCheckIn(rs.getTime("check_in").toLocalTime());
                h.setCheckOut(rs.getTime("check_out").toLocalTime());
                return h;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}

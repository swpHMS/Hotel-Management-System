package dal;

import context.DBContext;
import model.HotelInformation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Time;

public class HotelInformationDAO {

    private static final String SQL =
            "SELECT TOP 1 hotel_id, name, content, address, phone, email, check_in_time, check_out_time " +
            "FROM dbo.hotel_information";

    public HotelInformation getSingleHotel() {
        DBContext db = new DBContext();

        try (Connection con = db.connection;
             PreparedStatement ps = con.prepareStatement(SQL);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                HotelInformation h = new HotelInformation();
                h.setHotelId(rs.getInt("hotel_id"));
                h.setName(rs.getString("name"));
                h.setContent(rs.getString("content"));
                h.setAddress(rs.getString("address"));
                h.setPhone(rs.getString("phone"));
                h.setEmail(rs.getString("email"));

                Time cin = rs.getTime("check_in_time");
                Time cout = rs.getTime("check_out_time");
                if (cin != null) h.setCheckIn(cin.toLocalTime());
                if (cout != null) h.setCheckOut(cout.toLocalTime());

                return h;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}

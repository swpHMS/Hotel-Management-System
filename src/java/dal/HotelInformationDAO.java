package dal;

import context.DBContext;
import model.HotelInformation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Time;

public class HotelInformationDAO {

    private static final String SQL_GET_SINGLE =
            "SELECT TOP 1 hotel_id, name, content, address, phone, email, check_in_time, check_out_time "
            + "FROM dbo.hotel_information ORDER BY hotel_id ASC";

    public HotelInformation getSingleHotel() {
        DBContext db = new DBContext();

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_GET_SINGLE);
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

                if (cin != null) {
                    h.setCheckIn(cin.toLocalTime());
                }
                if (cout != null) {
                    h.setCheckOut(cout.toLocalTime());
                }

                return h;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public HotelInformation getHotelInformation() {
        return getSingleHotel();
    }

    public boolean insertHotelInformation(HotelInformation hotel) {
        String sql = "INSERT INTO hotel_information "
                + "(name, content, address, phone, email, check_in_time, check_out_time) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        DBContext db = new DBContext();

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, hotel.getName());
            ps.setString(2, hotel.getContent());
            ps.setString(3, hotel.getAddress());
            ps.setString(4, hotel.getPhone());
            ps.setString(5, hotel.getEmail());

            if (hotel.getCheckIn() != null) {
                ps.setTime(6, Time.valueOf(hotel.getCheckIn()));
            } else {
                ps.setNull(6, java.sql.Types.TIME);
            }

            if (hotel.getCheckOut() != null) {
                ps.setTime(7, Time.valueOf(hotel.getCheckOut()));
            } else {
                ps.setNull(7, java.sql.Types.TIME);
            }

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateHotelInformation(HotelInformation hotel) {
        String sql = "UPDATE hotel_information "
                + "SET name = ?, content = ?, address = ?, phone = ?, email = ?, "
                + "check_in_time = ?, check_out_time = ? "
                + "WHERE hotel_id = ?";

        DBContext db = new DBContext();

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, hotel.getName());
            ps.setString(2, hotel.getContent());
            ps.setString(3, hotel.getAddress());
            ps.setString(4, hotel.getPhone());
            ps.setString(5, hotel.getEmail());

            if (hotel.getCheckIn() != null) {
                ps.setTime(6, Time.valueOf(hotel.getCheckIn()));
            } else {
                ps.setNull(6, java.sql.Types.TIME);
            }

            if (hotel.getCheckOut() != null) {
                ps.setTime(7, Time.valueOf(hotel.getCheckOut()));
            } else {
                ps.setNull(7, java.sql.Types.TIME);
            }

            ps.setInt(8, hotel.getHotelId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean existsHotelInformation() {
        String sql = "SELECT TOP 1 1 FROM hotel_information";

        DBContext db = new DBContext();

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
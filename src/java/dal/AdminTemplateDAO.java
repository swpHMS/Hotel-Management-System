/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;
import context.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.EmailTemplate;
/**
 *
 * @author DieuBHHE191686
 */
public class AdminTemplateDAO {
     public List<EmailTemplate> getAll() {
        String sql = "SELECT template_id, code, subject, content, is_active FROM dbo.templates ORDER BY template_id";
        List<EmailTemplate> list = new ArrayList<>();

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                EmailTemplate t = new EmailTemplate();
                t.setTemplateId(rs.getInt("template_id"));
                t.setCode(rs.getString("code"));
                t.setSubject(rs.getString("subject"));
                t.setContent(rs.getString("content"));
                t.setActive(rs.getBoolean("is_active"));
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public EmailTemplate getById(int id) {
        String sql = "SELECT template_id, code, subject, content, is_active FROM dbo.templates WHERE template_id = ?";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    EmailTemplate t = new EmailTemplate();
                    t.setTemplateId(rs.getInt("template_id"));
                    t.setCode(rs.getString("code"));
                    t.setSubject(rs.getString("subject"));
                    t.setContent(rs.getString("content"));
                    t.setActive(rs.getBoolean("is_active"));
                    return t;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean update(EmailTemplate t) {
        String sql = "UPDATE dbo.templates SET subject = ?, content = ?, is_active = ? WHERE template_id = ?";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, t.getSubject());
            ps.setString(2, t.getContent());
            ps.setBoolean(3, t.isActive());
            ps.setInt(4, t.getTemplateId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
   
public java.util.Map<String, String> getEmailDataByBookingId(int bookingId) {
    java.util.Map<String, String> data = new java.util.HashMap<>();
    // Truy vấn thông tin khách hàng và phòng dựa trên Database của bạn
    String sql = "SELECT c.full_name, b.booking_id, b.check_in_date, rt.name AS room_name, b.total_amount " +
                 "FROM bookings b " +
                 "JOIN customers c ON b.customer_id = c.customer_id " +
                 "JOIN booking_room_types brt ON b.booking_id = brt.booking_id " +
                 "JOIN room_types rt ON brt.room_type_id = rt.room_type_id " +
                 "WHERE b.booking_id = ?";
    try (Connection con = new context.DBContext().getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, bookingId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                data.put("full_name", rs.getString("full_name"));
                data.put("booking_id", String.valueOf(rs.getInt("booking_id")));
                data.put("check_in_date", rs.getDate("check_in_date").toString());
                data.put("room_name", rs.getString("room_name"));
                data.put("total_amount", String.format("%,.0f", rs.getDouble("total_amount")));
            }
        }
    } catch (Exception e) { e.printStackTrace(); }
    return data;
}

public model.EmailTemplate getByCode(String code) {
    String sql = "SELECT * FROM templates WHERE code = ?";
    try (Connection con = new context.DBContext().getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, code);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                model.EmailTemplate t = new model.EmailTemplate();
                t.setTemplateId(rs.getInt("template_id"));
                t.setCode(rs.getString("code"));
                t.setSubject(rs.getString("subject"));
                t.setContent(rs.getString("content"));
                t.setActive(rs.getBoolean("is_active"));
                return t;
            }
        }
    } catch (Exception e) { e.printStackTrace(); }
    return null;
}
    
    
public EmailTemplate getTemplateByCode(String code) {
    String sql = "SELECT template_id, code, subject, content, is_active FROM dbo.templates WHERE code = ?";
    try (Connection con = new DBContext().getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, code);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                EmailTemplate t = new EmailTemplate();
                t.setTemplateId(rs.getInt("template_id"));
                t.setCode(rs.getString("code"));
                t.setSubject(rs.getString("subject"));
                t.setContent(rs.getString("content"));
                t.setActive(rs.getBoolean("is_active"));
                return t;
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}

public model.BookingEmailDTO getEmailDataByHoldId(int holdId) {
    String sql = """
        SELECT
            ISNULL(c.full_name, N'Quý khách') AS full_name,
            u.email,
            ISNULL(c.phone, 'N/A') AS phone,
            b.booking_id,
            h.check_in_date,
            h.check_out_date,
            STRING_AGG(
                CONCAT(CAST(hi.quantity AS VARCHAR(10)), 'x ', rt.name),
                ', '
            ) AS room_name,
            b.total_amount AS total_price
        FROM availability_holds h
        JOIN bookings b
            ON b.hold_id = h.hold_id
        LEFT JOIN users u
            ON h.user_id = u.user_id
        LEFT JOIN customers c
            ON u.user_id = c.user_id
        JOIN availability_hold_items hi
            ON h.hold_id = hi.hold_id
        JOIN room_types rt
            ON hi.room_type_id = rt.room_type_id
        WHERE h.hold_id = ?
        GROUP BY
            c.full_name, u.email, c.phone,
            b.booking_id, h.check_in_date, h.check_out_date, b.total_amount
    """;

    try (Connection con = new context.DBContext().getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, holdId);

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                model.BookingEmailDTO dto = new model.BookingEmailDTO();

                dto.setFullName(rs.getString("full_name"));
                dto.setEmail(rs.getString("email"));
                dto.setPhone(rs.getString("phone"));
                dto.setBookingId(String.valueOf(rs.getInt("booking_id")));

                Date checkIn = rs.getDate("check_in_date");
                Date checkOut = rs.getDate("check_out_date");

                dto.setCheckInDate(checkIn != null ? checkIn.toString() : "N/A");
                dto.setCheckOutDate(checkOut != null ? checkOut.toString() : "N/A");
                dto.setRoomName(rs.getString("room_name"));

                double total = rs.getDouble("total_price");
                dto.setTotalAmount(total);
                dto.setDepositAmount(total * 0.5);

                return dto;
            }
        }
    } catch (Exception e) {
        System.err.println("[DAO Error] getEmailDataByHoldId: " + e.getMessage());
        e.printStackTrace();
    }

    return null;
}
}

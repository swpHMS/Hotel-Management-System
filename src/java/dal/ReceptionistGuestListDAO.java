package dal;

import context.DBContext;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.GuestList;

public class ReceptionistGuestListDAO extends DBContext {

    public List<GuestList> getGuestList(String keyword, String status,
            String checkInDate, String checkOutDate, int index, int size) {
        List<GuestList> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT g.full_name, g.identity_number, r.room_no, ");
        sql.append("       b.check_in_date, b.check_out_date, sra.status ");
        sql.append("FROM stay_room_guests srg ");
        sql.append("INNER JOIN guests g ON srg.guest_id = g.guest_id ");
        sql.append("INNER JOIN stay_room_assignments sra ON srg.assignment_id = sra.assignment_id ");
        sql.append("INNER JOIN rooms r ON sra.room_id = r.room_id ");
        sql.append("INNER JOIN bookings b ON sra.booking_id = b.booking_id ");
        sql.append("WHERE sra.status IN (2, 3) ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (g.full_name LIKE ? OR g.identity_number LIKE ?) ");
        }

        if (status != null && !status.trim().isEmpty() && !status.equals("0")) {
            sql.append("AND sra.status = ? ");
        }

        // Lọc theo khoảng ngày
        if (checkInDate != null && !checkInDate.trim().isEmpty()
                && checkOutDate != null && !checkOutDate.trim().isEmpty()) {
            sql.append("AND b.check_in_date <= ? ");
            sql.append("AND b.check_out_date >= ? ");
        } else if (checkInDate != null && !checkInDate.trim().isEmpty()) {
            // nếu chỉ chọn ngày bắt đầu, lấy booking còn hiệu lực từ ngày đó trở đi
            sql.append("AND b.check_out_date >= ? ");
        } else if (checkOutDate != null && !checkOutDate.trim().isEmpty()) {
            // nếu chỉ chọn ngày kết thúc, lấy booking đã bắt đầu trước hoặc trong ngày đó
            sql.append("AND b.check_in_date <= ? ");
        }

        sql.append("ORDER BY ");
        sql.append("CASE WHEN sra.status = 2 THEN 0 ELSE 1 END, ");
        sql.append("b.check_in_date DESC, r.room_no ASC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try {
            PreparedStatement ps = connection.prepareStatement(sql.toString());
            int paramIndex = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchValue = "%" + keyword.trim() + "%";
                ps.setString(paramIndex++, searchValue);
                ps.setString(paramIndex++, searchValue);
            }

            if (status != null && !status.trim().isEmpty() && !status.equals("0")) {
                ps.setInt(paramIndex++, Integer.parseInt(status));
            }

            if (checkInDate != null && !checkInDate.trim().isEmpty()
                    && checkOutDate != null && !checkOutDate.trim().isEmpty()) {
                ps.setDate(paramIndex++, Date.valueOf(checkOutDate));
                ps.setDate(paramIndex++, Date.valueOf(checkInDate));
            } else if (checkInDate != null && !checkInDate.trim().isEmpty()) {
                ps.setDate(paramIndex++, Date.valueOf(checkInDate));
            } else if (checkOutDate != null && !checkOutDate.trim().isEmpty()) {
                ps.setDate(paramIndex++, Date.valueOf(checkOutDate));
            }

            ps.setInt(paramIndex++, (index - 1) * size);
            ps.setInt(paramIndex++, size);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                GuestList guest = new GuestList();
                guest.setFullName(rs.getString("full_name"));
                guest.setIdentityNumber(rs.getString("identity_number"));
                guest.setRoomNo(rs.getString("room_no"));
                guest.setCheckInDate(rs.getDate("check_in_date"));
                guest.setCheckOutDate(rs.getDate("check_out_date"));
                guest.setStatus(rs.getInt("status"));
                list.add(guest);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countGuestList(String keyword, String status,
            String checkInDate, String checkOutDate) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) ");
        sql.append("FROM stay_room_guests srg ");
        sql.append("INNER JOIN guests g ON srg.guest_id = g.guest_id ");
        sql.append("INNER JOIN stay_room_assignments sra ON srg.assignment_id = sra.assignment_id ");
        sql.append("INNER JOIN rooms r ON sra.room_id = r.room_id ");
        sql.append("INNER JOIN bookings b ON sra.booking_id = b.booking_id ");
        sql.append("WHERE sra.status IN (2, 3) ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (g.full_name LIKE ? OR g.identity_number LIKE ?) ");
        }

        if (status != null && !status.trim().isEmpty() && !status.equals("0")) {
            sql.append("AND sra.status = ? ");
        }

        // Lọc theo khoảng ngày
        if (checkInDate != null && !checkInDate.trim().isEmpty()
                && checkOutDate != null && !checkOutDate.trim().isEmpty()) {
            sql.append("AND b.check_in_date <= ? ");
            sql.append("AND b.check_out_date >= ? ");
        } else if (checkInDate != null && !checkInDate.trim().isEmpty()) {
            sql.append("AND b.check_out_date >= ? ");
        } else if (checkOutDate != null && !checkOutDate.trim().isEmpty()) {
            sql.append("AND b.check_in_date <= ? ");
        }

        try {
            PreparedStatement ps = connection.prepareStatement(sql.toString());
            int paramIndex = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchValue = "%" + keyword.trim() + "%";
                ps.setString(paramIndex++, searchValue);
                ps.setString(paramIndex++, searchValue);
            }

            if (status != null && !status.trim().isEmpty() && !status.equals("0")) {
                ps.setInt(paramIndex++, Integer.parseInt(status));
            }

            if (checkInDate != null && !checkInDate.trim().isEmpty()
                    && checkOutDate != null && !checkOutDate.trim().isEmpty()) {
                ps.setDate(paramIndex++, Date.valueOf(checkOutDate));
                ps.setDate(paramIndex++, Date.valueOf(checkInDate));
            } else if (checkInDate != null && !checkInDate.trim().isEmpty()) {
                ps.setDate(paramIndex++, Date.valueOf(checkInDate));
            } else if (checkOutDate != null && !checkOutDate.trim().isEmpty()) {
                ps.setDate(paramIndex++, Date.valueOf(checkOutDate));
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
}
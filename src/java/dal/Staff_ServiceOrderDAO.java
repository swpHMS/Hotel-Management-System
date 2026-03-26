package dal;

/**
 *
 * @author DieuBHHE191686
 */
import context.DBContext;
import java.math.BigDecimal;
import java.sql.*;
import java.util.*;
import model.ServiceOrder;
import model.ServiceOrderItem;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Service;

public class Staff_ServiceOrderDAO {

    // ========== LIST ORDERS (for left panel) ==========
    public static List<ServiceOrder> listOrders(Integer status, String roomNo, String createdDate) {
        List<ServiceOrder> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ")
                .append(" so.service_order_id, so.booking_id, so.room_id, r.room_no, ")
                .append(" so.created_by_staff_id, so.status, so.created_at, ")
                .append(" COALESCE(SUM(soi.quantity * soi.unit_price_snapshot), 0) AS total ")
                .append("FROM service_orders so ")
                .append("LEFT JOIN rooms r ON r.room_id = so.room_id ")
                .append("LEFT JOIN service_order_items soi ON soi.service_order_id = so.service_order_id ")
                .append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (status != null) {
            sql.append(" AND so.status = ? ");
            params.add(status);
        }
        if (roomNo != null && !roomNo.trim().isEmpty()) {
            sql.append(" AND r.room_no LIKE ? ");
            params.add("%" + roomNo.trim() + "%");
        }
        if (createdDate != null && !createdDate.isEmpty()) {
            sql.append(" AND CAST(so.created_at AS DATE) = ? ");
            params.add(createdDate);
        }

        sql.append(" GROUP BY ")
                .append(" so.service_order_id, so.booking_id, so.room_id, r.room_no, ")
                .append(" so.created_by_staff_id, so.status, so.created_at ")
                .append(" ORDER BY so.service_order_id DESC ");

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ServiceOrder o = new ServiceOrder();
                    o.setServiceOrderId(rs.getInt("service_order_id"));
                    o.setBookingId(rs.getInt("booking_id"));
                    o.setRoomId((Integer) rs.getObject("room_id"));   // nếu bạn có field roomId
                    o.setRoomNo(rs.getString("room_no"));              // ✅ giữ nguyên String
                    o.setCreatedByStaffId(rs.getInt("created_by_staff_id"));
                    o.setStatus(rs.getInt("status"));
                    o.setTotal(rs.getDouble("total"));
                    Timestamp ts = rs.getTimestamp("created_at");
                    if (ts != null) {
                        o.setCreatedAt(ts.toLocalDateTime());
                    }
                    list.add(o);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
// ========== GET ORDER DETAIL ==========

    public ServiceOrder getOrderWithItems(int serviceOrderId) {
        ServiceOrder order = null;

        String sqlOrder
                = "SELECT so.service_order_id, so.booking_id, so.room_id, r.room_no, "
                + "       so.created_by_staff_id, so.status, "
                + "       so.created_at, so.completed_at, so.completed_by_staff_id, "
                + "       so.cancelled_at, so.cancelled_by_staff_id, so.note, "
                + "       s1.full_name AS created_by_staff_name, "
                + "       s2.full_name AS completed_by_staff_name, "
                + "       s3.full_name AS cancelled_by_staff_name "
                + "FROM service_orders so "
                + "LEFT JOIN rooms r ON r.room_id = so.room_id "
                + "LEFT JOIN staff s1 ON s1.staff_id = so.created_by_staff_id "
                + "LEFT JOIN staff s2 ON s2.staff_id = so.completed_by_staff_id "
                + "LEFT JOIN staff s3 ON s3.staff_id = so.cancelled_by_staff_id "
                + "WHERE so.service_order_id = ?";

        String sqlItems
                = "SELECT soi.service_order_item_id, soi.service_order_id, soi.service_id, "
                + "       soi.quantity, soi.unit_price_snapshot, "
                + "       s.code AS service_code, s.name AS service_name, s.service_type "
                + "FROM service_order_items soi "
                + "JOIN services s ON s.service_id = soi.service_id "
                + "WHERE soi.service_order_id = ? "
                + "ORDER BY s.service_type ASC, soi.service_order_item_id ASC";

        try (Connection con = new context.DBContext().getConnection()) {

            // 1) Load order
            try (PreparedStatement ps = con.prepareStatement(sqlOrder)) {
                ps.setInt(1, serviceOrderId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        order = new ServiceOrder();
                        order.setServiceOrderId(rs.getInt("service_order_id"));
                        order.setBookingId(rs.getInt("booking_id"));
                        order.setRoomId((Integer) rs.getObject("room_id"));
                        order.setRoomNo(rs.getString("room_no"));
                        order.setCreatedByStaffId(rs.getInt("created_by_staff_id"));
                        order.setStatus(rs.getInt("status"));
                        order.setCreatedByStaffName(rs.getString("created_by_staff_name"));
                        order.setCompletedByStaffName(rs.getString("completed_by_staff_name"));
                        order.setCancelledByStaffName(rs.getString("cancelled_by_staff_name"));

                        Timestamp createdTs = rs.getTimestamp("created_at");
                        if (createdTs != null) {
                            order.setCreatedAt(createdTs.toLocalDateTime());
                        }

                        Timestamp completedTs = rs.getTimestamp("completed_at");
                        if (completedTs != null) {
                            order.setCompletedAt(completedTs.toLocalDateTime());
                        }

                        Timestamp cancelledTs = rs.getTimestamp("cancelled_at");
                        if (cancelledTs != null) {
                            order.setCancelledAt(cancelledTs.toLocalDateTime());
                        }

                        order.setCompletedByStaffId((Integer) rs.getObject("completed_by_staff_id"));
                        order.setCancelledByStaffId((Integer) rs.getObject("cancelled_by_staff_id"));
                        order.setNote(rs.getString("note"));
                    }
                }
            }

            if (order == null) {
                return null;
            }

            // 2) Load items
            List<ServiceOrderItem> items = new ArrayList<>();
            try (PreparedStatement ps = con.prepareStatement(sqlItems)) {
                ps.setInt(1, serviceOrderId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        ServiceOrderItem it = new ServiceOrderItem();
                        it.setServiceOrderItemId(rs.getLong("service_order_item_id"));
                        it.setServiceOrderId(rs.getInt("service_order_id"));
                        it.setServiceId(rs.getInt("service_id"));
                        it.setQuantity(rs.getInt("quantity"));
                        it.setUnitPriceSnapshot(rs.getBigDecimal("unit_price_snapshot"));
                        it.setServiceCode(rs.getString("service_code"));
                        it.setServiceName(rs.getString("service_name"));
                        it.setServiceType(rs.getInt("service_type"));
                        items.add(it);
                    }
                }
            }

            order.setItems(items);

            // 3) Compute total
            double total = 0;
            for (ServiceOrderItem it : items) {
                if (it.getUnitPriceSnapshot() != null) {
                    total += it.getUnitPriceSnapshot().doubleValue() * it.getQuantity();
                }
            }
            order.setTotal(total);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return order;
    }

    public Integer getStaffIdByUserId(int userId) {
        String sql = "SELECT staff_id FROM staff WHERE user_id = ?";

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("staff_id");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ========== CREATE DRAFT ==========
    public int createDraft(int bookingId, Integer roomId, int createdByStaffId, String note) {
        String sql = "INSERT INTO service_orders (booking_id, room_id, created_by_staff_id, status, created_at, note) "
                + "VALUES (?, ?, ?, 0, SYSDATETIME(), ?)";

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, bookingId);
            if (roomId == null) {
                ps.setNull(2, Types.INTEGER);
            } else {
                ps.setInt(2, roomId);
            }

            ps.setInt(3, createdByStaffId);
            ps.setString(4, note);

            int affected = ps.executeUpdate();
            if (affected == 0) {
                return -1;
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public static class ItemReq {

        public final int serviceId;
        public final int quantity;

        public ItemReq(int serviceId, int quantity) {
            this.serviceId = serviceId;
            this.quantity = quantity;
        }
    }

    public int createDraftWithItems(int bookingId, Integer roomId, int staffId, String note, List<ItemReq> items) {
        String sqlInsertOrder
                = "INSERT INTO service_orders (booking_id, room_id, created_by_staff_id, status, created_at, note) "
                + "VALUES (?, ?, ?, 0, SYSDATETIME(), ?)";

        // snapshot lấy từ services.unit_price tại thời điểm create
        String sqlInsertItem
                = "INSERT INTO service_order_items (service_order_id, service_id, quantity, unit_price_snapshot) "
                + "SELECT ?, s.service_id, ?, s.unit_price "
                + "FROM services s WHERE s.service_id = ?";

        Connection con = null;
        try {
            con = new context.DBContext().getConnection();
            con.setAutoCommit(false);

            int newOrderId;

            // 1) insert order + get generated key
            try (PreparedStatement ps = con.prepareStatement(sqlInsertOrder, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, bookingId);
                if (roomId == null) {
                    ps.setNull(2, Types.INTEGER);
                } else {
                    ps.setInt(2, roomId);
                }
                ps.setInt(3, staffId);
                ps.setString(4, note);

                int affected = ps.executeUpdate();
                if (affected != 1) {
                    con.rollback();
                    return -1;
                }

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (!rs.next()) {
                        con.rollback();
                        return -1;
                    }
                    newOrderId = rs.getInt(1);
                }
            }

            // 2) insert items
            try (PreparedStatement psItem = con.prepareStatement(sqlInsertItem)) {
                for (ItemReq it : items) {
                    psItem.setInt(1, newOrderId);      // service_order_id
                    psItem.setInt(2, it.quantity);     // quantity
                    psItem.setInt(3, it.serviceId);    // where service_id
                    psItem.addBatch();
                }
                psItem.executeBatch();
            }

            con.commit();
            return newOrderId;

        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (Exception ex) {
            }
            return -1;
        } finally {
            try {
                if (con != null) {
                    con.setAutoCommit(true);
                }
            } catch (Exception ex) {
            }
            try {
                if (con != null) {
                    con.close();
                }
            } catch (Exception ex) {
            }
        }
    }

    // ========== ADD ITEM TO DRAFT (snapshot price) ==========
    public boolean addItemToDraft2(int serviceOrderId, int serviceId, int quantity) {
        String checkDraftSql = """
        SELECT 1
        FROM service_orders
        WHERE service_order_id = ? AND status = 0
    """;

        String updateSql = """
        UPDATE service_order_items
        SET quantity = quantity + ?
        WHERE service_order_id = ? AND service_id = ?
    """;

        String insertSql = """
        INSERT INTO service_order_items (service_order_id, service_id, quantity, unit_price_snapshot)
        SELECT ?, s.service_id, ?, s.unit_price
        FROM services s
        WHERE s.service_id = ?
    """;

        try (Connection con = new DBContext().getConnection()) {
            con.setAutoCommit(false);

            try (PreparedStatement ps = con.prepareStatement(checkDraftSql)) {
                ps.setInt(1, serviceOrderId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        con.rollback(); //ko đc thêm item vì đang ở POSTED
                        return false;
                    }
                }
            }

            try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                ps.setInt(1, quantity);
                ps.setInt(2, serviceOrderId);
                ps.setInt(3, serviceId);

                int updated = ps.executeUpdate();
                if (updated > 0) {
                    con.commit();
                    return true;
                }
            }

            try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                ps.setInt(1, serviceOrderId);
                ps.setInt(2, quantity);
                ps.setInt(3, serviceId);

                int inserted = ps.executeUpdate();
                con.commit();
                return inserted > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void appendNote(int serviceOrderId, String newNote) {
    String getOldNoteSql = "SELECT note, status FROM service_orders WHERE service_order_id = ?";
    String updateSql = "UPDATE service_orders SET note = ? WHERE service_order_id = ?";

    try (Connection con = new DBContext().getConnection()) {

        String oldNote = "";
        int status = -1;

        try (PreparedStatement ps = con.prepareStatement(getOldNoteSql)) {
            ps.setInt(1, serviceOrderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    oldNote = rs.getString("note");
                    status = rs.getInt("status");
                }
            }
        }

        if (status != 0) return;
        if (newNote == null || newNote.trim().isEmpty()) return;

        String time = java.time.LocalDateTime.now()
                .format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));

        String formattedNote = "[" + time + "]\n" + newNote;

        String finalNote = (oldNote == null || oldNote.trim().isEmpty())
                ? formattedNote
                : oldNote + "\n\n" + formattedNote;

        try (PreparedStatement ps = con.prepareStatement(updateSql)) {
            ps.setString(1, finalNote);
            ps.setInt(2, serviceOrderId);
            ps.executeUpdate();
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
}
    //========lấy services theo type=========
    public List<Service> listServicesByType(int serviceType) {
        List<Service> list = new ArrayList<>();

        String sql = "SELECT service_id, code, name, service_type, unit_price "
                + "FROM services "
                + "WHERE service_type = ? AND status = 1 "
                + "ORDER BY name ASC";
        
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, serviceType);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Service s = new Service();
                    s.setServiceId(rs.getInt("service_id"));
                    s.setCode(rs.getString("code"));
                    s.setName(rs.getString("name"));
                    s.setServiceType(rs.getInt("service_type"));
                    s.setUnitPrice(rs.getDouble("unit_price"));
                    list.add(s);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    // ========== UPDATE QTY (Draft only) ==========
    public boolean updateItemQuantityDraft(long serviceOrderItemId, int newQty) {
        String sql
                = "UPDATE soi "
                + "SET soi.quantity = ? "
                + "FROM service_order_items soi "
                + "JOIN service_orders so ON so.service_order_id = soi.service_order_id "
                + "WHERE soi.service_order_item_id = ? "
                + "  AND so.status = 0";

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, newQty);
            ps.setLong(2, serviceOrderItemId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ========== REMOVE ITEM (Draft only) ==========
    public boolean removeItemDraft(long serviceOrderItemId) {
        String sql
                = "DELETE soi "
                + "FROM service_order_items soi "
                + "JOIN service_orders so ON so.service_order_id = soi.service_order_id "
                + "WHERE soi.service_order_item_id = ? "
                + "  AND so.status = 0";

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, serviceOrderItemId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ========== MARK AS POSTED (Draft -> Posted) ==========
    public boolean markFinished(int serviceOrderId, int staffId) {
        String sql
                = "UPDATE so "
                + "SET so.status = 1, "
                + "    so.completed_at = SYSDATETIME(), "
                + "    so.completed_by_staff_id = ? "
                + "FROM service_orders so "
                + "WHERE so.service_order_id = ? "
                + "  AND so.status = 0 "
                + "  AND EXISTS (SELECT 1 FROM service_order_items soi WHERE soi.service_order_id = so.service_order_id)";

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, staffId);
            ps.setInt(2, serviceOrderId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ========== CANCEL DRAFT (Draft -> Cancelled=2) ==========
    public boolean cancelDraft(int serviceOrderId, int staffId) {
        String sql
                = "UPDATE service_orders "
                + "SET status = 2, "
                + "    cancelled_at = SYSDATETIME(), "
                + "    cancelled_by_staff_id = ? "
                + "WHERE service_order_id = ? AND status = 0";

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, staffId);
            ps.setInt(2, serviceOrderId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    //nhập Room trước → auto ra Booking ID
    public static record BookingLookup(int bookingId, int roomId, int assignmentId) {

    }

    public BookingLookup findActiveBookingByRoomNo(String roomNo) {
        final int BOOKING_ACTIVE = 3;
        final int SRA_IN_HOUSE = 2;

        String sql
                = "SELECT TOP 1 b.booking_id, r.room_id, sra.assignment_id "
                + "FROM dbo.rooms r "
                + "JOIN dbo.stay_room_assignments sra ON sra.room_id = r.room_id "
                + "JOIN dbo.bookings b ON b.booking_id = sra.booking_id "
                + "WHERE r.room_no = ? "
                + "  AND b.status = ? "
                + "  AND sra.status = ? "
                + "  AND sra.actual_check_in IS NOT NULL "
                + "  AND sra.actual_check_out IS NULL "
                + "ORDER BY sra.actual_check_in DESC, sra.assignment_id DESC";

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, roomNo);
            ps.setInt(2, BOOKING_ACTIVE);
            ps.setInt(3, SRA_IN_HOUSE);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new BookingLookup(
                            rs.getInt("booking_id"),
                            rs.getInt("room_id"),
                            rs.getInt("assignment_id")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
//Room đấy phải dam bao đk là Inhouse chứ ko phải Upgrade, Initial

    public boolean isRoomInHouseForBooking(int bookingId, int roomId) {
        String sql
                = "SELECT 1 "
                + "FROM dbo.stay_room_assignments sra "
                + "JOIN dbo.bookings b ON b.booking_id = sra.booking_id "
                + "WHERE sra.booking_id = ? "
                + "  AND sra.room_id = ? "
                + "  AND b.status = 3 "
                + // booking active
                "  AND sra.status = 2 "
                + // IN_HOUSE
                "  AND sra.actual_check_in IS NOT NULL "
                + "  AND sra.actual_check_out IS NULL";

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setInt(2, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ===== helper bind params =====
    private void bindParams(PreparedStatement ps, List<Object> params) throws SQLException {
        for (int i = 0; i < params.size(); i++) {
            Object v = params.get(i);
            int idx = i + 1;
            if (v == null) {
                ps.setNull(idx, Types.NULL);
            } else if (v instanceof Integer) {
                ps.setInt(idx, (Integer) v);
            } else if (v instanceof Long) {
                ps.setLong(idx, (Long) v);
            } else if (v instanceof String) {
                ps.setString(idx, (String) v);
            } else {
                ps.setObject(idx, v);
            }
        }
    }

}

package dal;

import context.DBContext;
import model.HotelService;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ManagerServiceDAO extends DBContext {

    // 1. Lấy danh sách Services (Có tìm kiếm, lọc và phân trang)
    public List<HotelService> searchServices(String keyword, String serviceType, String status, int pageIndex, int pageSize) {
        List<HotelService> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM dbo.services WHERE 1=1 ");

        if (keyword != null && !keyword.trim().isEmpty()) sql.append(" AND (name LIKE ? OR code LIKE ?) ");
        if (serviceType != null && !serviceType.isEmpty()) sql.append(" AND service_type = ? ");
        if (status != null && !status.isEmpty()) sql.append(" AND status = ? ");

        // Phân trang
        sql.append(" ORDER BY service_id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try {
            connection = getConnection();
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int index = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                st.setString(index++, "%" + keyword + "%");
                st.setString(index++, "%" + keyword + "%");
            }
            if (serviceType != null && !serviceType.isEmpty()) st.setInt(index++, Integer.parseInt(serviceType));
            if (status != null && !status.isEmpty()) st.setInt(index++, Integer.parseInt(status));

            // Set cho phân trang
            st.setInt(index++, (pageIndex - 1) * pageSize);
            st.setInt(index++, pageSize);

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                HotelService s = new HotelService();
                s.setServiceId(rs.getInt("service_id"));
                s.setCode(rs.getString("code"));
                s.setName(rs.getString("name"));
                s.setServiceType(rs.getInt("service_type"));
                s.setUnitPrice(rs.getDouble("unit_price"));
                s.setStatus(rs.getInt("status"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Đếm tổng số lượng Service phục vụ phân trang
    public int getTotalServiceCount(String keyword, String serviceType, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM dbo.services WHERE 1=1 ");

        if (keyword != null && !keyword.trim().isEmpty()) sql.append(" AND (name LIKE ? OR code LIKE ?) ");
        if (serviceType != null && !serviceType.isEmpty()) sql.append(" AND service_type = ? ");
        if (status != null && !status.isEmpty()) sql.append(" AND status = ? ");

        try {
            connection = getConnection();
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int index = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                st.setString(index++, "%" + keyword + "%");
                st.setString(index++, "%" + keyword + "%");
            }
            if (serviceType != null && !serviceType.isEmpty()) st.setInt(index++, Integer.parseInt(serviceType));
            if (status != null && !status.isEmpty()) st.setInt(index++, Integer.parseInt(status));

            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 2. Lấy dữ liệu KPI cho Dashboard
    public Map<String, Object> getServiceKPIs() {
        Map<String, Object> kpi = new HashMap<>();
        kpi.put("totalServices", 0);
        kpi.put("activeServices", 0);
        kpi.put("totalOrders", 0);
        kpi.put("totalRevenue", 0.0);

        try {
            connection = getConnection();
            
            // Đếm số lượng services
            String sqlServices = "SELECT COUNT(*) AS total, SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) AS active FROM dbo.services";
            PreparedStatement ps1 = connection.prepareStatement(sqlServices);
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) {
                kpi.put("totalServices", rs1.getInt("total"));
                kpi.put("activeServices", rs1.getInt("active"));
            }

            // Đếm tổng số Orders và Doanh thu (Chỉ tính những order đã POSTED - status = 1)
            String sqlOrders = "SELECT COUNT(*) AS total_orders FROM dbo.service_orders WHERE status = 1";
            PreparedStatement ps2 = connection.prepareStatement(sqlOrders);
            ResultSet rs2 = ps2.executeQuery();
            if (rs2.next()) {
                kpi.put("totalOrders", rs2.getInt("total_orders"));
            }

            // Tính tổng doanh thu từ service_order_items (Giá * Số lượng)
            String sqlRevenue = "SELECT SUM(soi.quantity * soi.unit_price) AS total_revenue " +
                                "FROM dbo.service_order_items soi " +
                                "JOIN dbo.service_orders so ON soi.service_order_id = so.service_order_id " +
                                "WHERE so.status = 1";
            PreparedStatement ps3 = connection.prepareStatement(sqlRevenue);
            ResultSet rs3 = ps3.executeQuery();
            if (rs3.next()) {
                kpi.put("totalRevenue", rs3.getDouble("total_revenue"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return kpi;
    }

    // 3. Thêm mới Service
    public boolean createService(HotelService s) {
        String sql = "INSERT INTO dbo.services (code, name, service_type, unit_price, status) VALUES (?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            PreparedStatement st = connection.prepareStatement(sql);
            
            // Tự động sinh mã Code ngẫu nhiên vì form không có trường nhập mã
            String generateCode = "SRV" + (System.currentTimeMillis() % 100000); 
            
            st.setString(1, generateCode);
            st.setString(2, s.getName());
            st.setInt(3, s.getServiceType());
            st.setDouble(4, s.getUnitPrice());
            st.setInt(5, s.getStatus());
            
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 4. Cập nhật Service
    public boolean updateService(HotelService s) {
        String sql = "UPDATE dbo.services SET name = ?, service_type = ?, unit_price = ?, status = ? WHERE service_id = ?";
        try {
            connection = getConnection();
            PreparedStatement st = connection.prepareStatement(sql);
            
            st.setString(1, s.getName());
            st.setInt(2, s.getServiceType());
            st.setDouble(3, s.getUnitPrice());
            st.setInt(4, s.getStatus());
            st.setInt(5, s.getServiceId());
            
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
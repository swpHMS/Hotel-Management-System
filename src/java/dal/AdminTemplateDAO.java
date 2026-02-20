/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;
import context.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
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
}

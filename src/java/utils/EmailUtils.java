package utils;

import dal.AdminTemplateDAO;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import model.EmailTemplate;

public class EmailUtils {

    private static final String FROM_EMAIL = "duchappy2k5@gmail.com";
    private static final String APP_PASSWORD = "kxcz mjzt rdaq tjop";

    // =========================
    // 1. Hàm gửi mail vật lý
    // =========================
    public static void sendEmail(String to, String subject, String content) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject != null ? subject : "", "UTF-8");
            message.setContent(content != null ? content : "", "text/html; charset=UTF-8");
            Transport.send(message);

            System.out.println("[INFO] Gui mail thanh cong toi: " + to);
        } catch (MessagingException e) {
            e.printStackTrace();
            throw new RuntimeException("Gui email that bai: " + e.getMessage(), e);
        }
    }

    // ==========================================
    // 2. Hàm replace placeholder {{key}}
    // ==========================================
    private static String replacePlaceholders(String text, Map<String, String> replacements) {
        if (text == null) {
            return "";
        }

        String result = text;
        if (replacements != null) {
            for (Map.Entry<String, String> entry : replacements.entrySet()) {
                String placeholder = "{{" + entry.getKey() + "}}";
                String value = entry.getValue() != null ? entry.getValue() : "";
                result = result.replace(placeholder, value);
            }
        }
        return result;
    }

    // ==========================================
    // 3. Gửi theo template DB
    // ==========================================
    public static void sendTemplateEmail(String to, String templateCode, Map<String, String> replacements) throws Exception {
        System.out.println("[DEBUG] sendTemplateEmail called");
        System.out.println("[DEBUG] to = " + to);
        System.out.println("[DEBUG] templateCode = " + templateCode);

        AdminTemplateDAO dao = new AdminTemplateDAO();
        EmailTemplate template = dao.getTemplateByCode(templateCode);

        System.out.println("[DEBUG] template found = " + (template != null));

        if (template == null) {
            throw new RuntimeException("Khong tim thay template: " + templateCode);
        }

        System.out.println("[DEBUG] template active = " + template.isActive());
        System.out.println("[DEBUG] subject from DB = " + template.getSubject());

        if (!template.isActive()) {
            throw new RuntimeException("Template dang inactive: " + templateCode);
        }

        String subject = replacePlaceholders(template.getSubject(), replacements);
        String htmlContent = replacePlaceholders(template.getContent(), replacements);

        System.out.println("[DEBUG] subject after replace = " + subject);
        System.out.println("[DEBUG] content length after replace = " + (htmlContent != null ? htmlContent.length() : 0));

        if (subject == null || subject.isBlank()) {
            throw new RuntimeException("Subject template rong: " + templateCode);
        }

        if (htmlContent == null || htmlContent.isBlank()) {
            throw new RuntimeException("Content template rong: " + templateCode);
        }

        sendEmail(to, subject, htmlContent);
    }

    // ==========================================
    // 4. VERIFY EMAIL có backup
    // ==========================================
    public static void sendVerifyEmail(String to, String token) {
        String link = "http://localhost:9999/SWP391_HMS_GR2/verify?email=" + to + "&token=" + token;

        Map<String, String> replacements = new HashMap<>();
        replacements.put("email", to);
        replacements.put("token", token);
        replacements.put("verify_link", link);

        try {
            sendTemplateEmail(to, "VERIFY_ACCOUNT", replacements);
        } catch (Exception e) {
            System.out.println("[WARN] Loi template VERIFY_ACCOUNT, dung backup email.");
            e.printStackTrace();

            String backupSubject = "Kich hoat tai khoan Regal Quintet";
            String backupContent
                    = "<h3>Chao mung ban!</h3>"
                    + "<p>Vui long nhan vao link duoi day de kich hoat tai khoan:</p>"
                    + "<p><a href='" + link + "'>Kich hoat ngay</a></p>";

            sendEmail(to, backupSubject, backupContent);
        }
    }

    // ==========================================
    // 5. FORGOT PASSWORD có backup
    // ==========================================
    public static void sendForgotPasswordEmail(String to, String token) {
        String link = "http://localhost:9999/SWP391_HMS_GR2/reset-password?token=" + token;

        Map<String, String> replacements = new HashMap<>();
        replacements.put("email", to);
        replacements.put("token", token);
        replacements.put("reset_link", link);

        try {
            sendTemplateEmail(to, "FORGOT_PASSWORD", replacements);
        } catch (Exception e) {
            System.out.println("[WARN] Loi template FORGOT_PASSWORD, dung backup email.");
            e.printStackTrace();

            String backupSubject = "Dat lai mat khau - Regal Quintet";
            String backupContent
                    = "<h3>Yeu cau dat lai mat khau</h3>"
                    + "<p>Chung toi da nhan duoc yeu cau dat lai mat khau cho tai khoan: <b>" + to + "</b></p>"
                    + "<p>Vui long nhan vao link sau:</p>"
                    + "<p><a href='" + link + "'>Dat lai mat khau</a></p>";

            sendEmail(to, backupSubject, backupContent);
        }
    }

    // ==========================================
    // 6. BOOKING CONFIRM có backup
    // ==========================================
    public static void sendBookingEmail(String to, String templateCode, Map<String, String> replacements) {
        try {
            sendTemplateEmail(to, templateCode, replacements);
        } catch (Exception e) {
            System.out.println("[WARN] Loi template " + templateCode + ", dung backup email.");
            e.printStackTrace();

            String fullName = replacements != null ? replacements.getOrDefault("full_name", "Quy khach") : "Quy khach";
            String bookingId = replacements != null ? replacements.getOrDefault("booking_id", "") : "";
            String checkInDate = replacements != null ? replacements.getOrDefault("check_in_date", "") : "";
            String checkOutDate = replacements != null ? replacements.getOrDefault("check_out_date", "") : "";
            String roomName = replacements != null ? replacements.getOrDefault("room_name", "") : "";
            String totalAmount = replacements != null ? replacements.getOrDefault("total_amount", "") : "";

            String backupSubject = "Booking Confirmed";
            String backupContent
                    = "<h3>Xac nhan dat phong</h3>"
                    + "<p>Xin chao <b>" + fullName + "</b>,</p>"
                    + "<p>Don dat phong cua ban da duoc xac nhan thanh cong.</p>"
                    + "<ul>"
                    + "<li>Booking ID: " + bookingId + "</li>"
                    + "<li>Check-in: " + checkInDate + "</li>"
                    + "<li>Check-out: " + checkOutDate + "</li>"
                    + "<li>Room: " + roomName + "</li>"
                    + "<li>Total: " + totalAmount + "</li>"
                    + "</ul>"
                    + "<p>Cam on ban da chon Regal Quintet Hotel.</p>";

            sendEmail(to, backupSubject, backupContent);
        }
    }
}

package utils;

import dal.AdminTemplateDAO;
import java.util.Properties;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Map;
import model.EmailTemplate;

public class EmailUtils {
    
//        // Thay bằng email thật và App Password 16 ký tự của bạn
//        final String from = "your-email@gmail.com"; 
//        final String password = "xxxx xxxx xxxx xxxx"; 
//
//        Properties props = new Properties();
//        props.put("mail.smtp.host", "smtp.gmail.com");
//        props.put("mail.smtp.port", "587");
//        props.put("mail.smtp.auth", "true");
//        props.put("mail.smtp.starttls.enable", "true");
//
//        // Đảm bảo sử dụng jakarta.mail.Session
//        Session session = Session.getInstance(props, new Authenticator() {
//            @Override
//            protected PasswordAuthentication getPasswordAuthentication() {
//                return new PasswordAuthentication(from, password);
//            }
//        });
//
//        try {
//            MimeMessage message = new MimeMessage(session);
//            message.setFrom(new InternetAddress(from));
//            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
//            message.setSubject("Kích hoạt tài khoản Regal Quintet");
//            
//            String link = "http://localhost:9999/SWP391_HMS_GR2/verify?email=" + to + "&token=" + token;
//            String htmlContent = "<h3>Chào mừng bạn!</h3>"
//                    + "<p>Vui lòng nhấn vào link để kích hoạt tài khoản:</p>"
//                    + "<a href='" + link + "'>Kích hoạt ngay</a>";
//            
//            message.setContent(htmlContent, "text/html; charset=UTF-8");
//            Transport.send(message);
//        } catch (MessagingException e) {
//            e.printStackTrace();
//        }
//    }

  // 1. Khai báo hằng số để hết lỗi đỏ
    private static final String FROM_EMAIL = "duchappy2k5@gmail.com"; 
    private static final String APP_PASSWORD = "kxcz mjzt rdaq tjop"; // Thay bằng mã 16 ký tự của Google

    // 2. Hàm gửi mail chung cho toàn hệ thống
    public static void sendEmail(String to, String subject, String content) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                // Sử dụng đúng hằng số đã khai báo ở trên
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject, "UTF-8");
            message.setContent(content, "text/html; charset=UTF-8");
            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    // 3. Hàm gửi mail kích hoạt (Dùng cho Register)
    public static void sendVerifyEmail(String to, String token) {
        String link = "http://localhost:9999/SWP391_HMS_GR2/verify?email=" + to + "&token=" + token;
        String subject = "Kích hoạt tài khoản Regal Quintet";
        String content = "<h3>Chào mừng!</h3><p>Vui lòng nhấn: <a href='" + link + "'>Kích hoạt ngay</a></p>";
        sendEmail(to, subject, content); // Gọi hàm sendEmail chung
    }

    // 4. Hàm gửi mail khôi phục (Dùng cho Forgot Password)
    public static void sendForgotPasswordEmail(String to, String token) {
        String link = "http://localhost:9999/SWP391_HMS_GR2/reset-password?token=" + token;
        String subject = "Đặt lại mật khẩu - Regal Quintet";
        String content = "<h3>Yêu cầu đổi mật khẩu</h3><p>Nhấn vào link: <a href='" + link + "'>Đổi mật khẩu</a></p>";
        sendEmail(to, subject, content); // Hết lỗi gạch đỏ sendEmail
    }
    
    // 5. Hàm gửi tông báo confirm booking thành công 
     public static void sendBookingEmail(String to, String templateCode, Map<String, String> replacements) throws Exception {
        System.out.println("[DEBUG] Chuan bi gui mail toi: " + to);
        System.out.println("[DEBUG] Template code: " + templateCode);
        System.out.println("[DEBUG] Replacements: " + replacements);

        AdminTemplateDAO dao = new AdminTemplateDAO();
        EmailTemplate template = dao.getTemplateByCode(templateCode);

        if (template == null) {
            throw new RuntimeException("Khong tim thay template voi ma: " + templateCode);
        }

        if (!template.isActive()) {
            throw new RuntimeException("Template dang bi inactive: " + templateCode);
        }

        String subject = template.getSubject();
        String htmlContent = template.getContent();

        if (htmlContent == null || htmlContent.isBlank()) {
            throw new RuntimeException("Noi dung template rong: " + templateCode);
        }

        if (replacements != null) {
            for (Map.Entry<String, String> entry : replacements.entrySet()) {
                String placeholder = "{{" + entry.getKey() + "}}";
                String value = (entry.getValue() != null) ? entry.getValue() : "";
                htmlContent = htmlContent.replace(placeholder, value);
                subject = subject != null ? subject.replace(placeholder, value) : "";
            }
        }

        System.out.println("[DEBUG] Subject sau replace: " + subject);
        System.out.println("[DEBUG] Preview content: " +
                (htmlContent.length() > 200 ? htmlContent.substring(0, 200) : htmlContent));

        sendEmail(to, subject, htmlContent);
        System.out.println("[INFO] Gui mail thanh cong toi: " + to);
    }
}
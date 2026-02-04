package utils;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtils {

    public static String hash(String plain) {
        return BCrypt.hashpw(plain, BCrypt.gensalt(12));
    }

    public static boolean verify(String plain, String hashed) {
        if (plain == null || hashed == null) {
            return false;
        }

        // Chỉ chấp nhận BCrypt hash hợp lệ
        if (!(hashed.startsWith("$2a$") 
           || hashed.startsWith("$2b$") 
           || hashed.startsWith("$2y$"))) {
            return false;
        }

        try {
            return BCrypt.checkpw(plain, hashed);
        } catch (Exception ex) {
            // hash bị lỗi / cắt cụt / DB bẩn
            return false;
        }
    }
}

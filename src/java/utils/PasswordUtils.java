/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author ASUS
 */
public class PasswordUtils {

    // password encryption
    public static String hashPassword(String plainText) {
        return BCrypt.hashpw(plainText, BCrypt.gensalt(12));
    }

    // check password
    public static boolean checkPassword(String plainText, String hashed) {
        return BCrypt.checkpw(plainText, hashed);
    }

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

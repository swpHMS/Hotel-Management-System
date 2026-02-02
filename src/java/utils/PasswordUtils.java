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
    public static String hashPassword(String plainText){
        return BCrypt.hashpw(plainText, BCrypt.gensalt(12));
    }
    
    // check password
    public static boolean checkPassword(String plainText, String hashed){
        return BCrypt.checkpw(plainText, hashed);
    }
}

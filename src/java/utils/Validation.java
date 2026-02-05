/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;
import java.sql.Date;
import java.time.LocalDate;
import java.util.regex.Pattern;

/**
 *
 * @author Admin
 */
public class Validation {
     private static final Pattern EMAIL =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");

    // VN phone basic: 10 digits, starts 0
    private static final Pattern VN_PHONE =
            Pattern.compile("^0\\d{9,10}$");

    // CCCD 12 digits (bạn nói muốn chuẩn CCCD)
    private static final Pattern CCCD =
            Pattern.compile("^\\d{12}$");

    public static String trimToNull(String s){
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }

    public static boolean isEmail(String s){
        return s != null && EMAIL.matcher(s).matches();
    }

    public static boolean isPhoneVN(String s){
        return s != null && VN_PHONE.matcher(s).matches();
    }

    public static boolean isCCCD(String s){
        return s != null && CCCD.matcher(s).matches();
    }

    public static boolean minLen(String s, int n){
        return s != null && s.length() >= n;
    }

    public static Date parseDateOrNull(String s){
        try{
            if (s == null || s.trim().isEmpty()) return null;
            // input type="date" trả yyyy-MM-dd
            return Date.valueOf(s.trim());
        }catch(Exception e){
            return null;
        }
    }

    public static boolean isAdultOrValidDob(Date dob){
        if (dob == null) return false;
        LocalDate d = dob.toLocalDate();
        LocalDate now = LocalDate.now();
        // chỉ check không ở tương lai; muốn check >= 18 thì thay điều kiện
        return !d.isAfter(now);
    }
    
    public static String validateDobForStaff(String dobRaw) {
    if (dobRaw == null || dobRaw.trim().isEmpty()) {
        return "Date of birth is required.";
    }

    Date dob = parseDateOrNull(dobRaw);
    if (dob == null) {
        return "Invalid date format. Use mm/dd/yyyy.";
    }

    LocalDate birth = dob.toLocalDate();
    LocalDate today = LocalDate.now();

    if (birth.isAfter(today)) return "Date of birth cannot be in the future.";

    int age = java.time.Period.between(birth, today).getYears();
    if (age < 18) return "Staff must be at least 18 years old.";

    return null;
}

}

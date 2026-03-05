package utils;

import jakarta.servlet.http.HttpServletRequest;
import java.sql.Date;
import java.time.format.DateTimeFormatter;

public class FormUtils {

    private static final DateTimeFormatter DMY = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    public static String trimToNull(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }

    public static Integer parseIntOrNull(String s) {
        s = trimToNull(s);
        if (s == null) return null;
        try { return Integer.parseInt(s); } catch (Exception e) { return null; }
    }

    public static Date parseDateOrNull(String s) {
        s = trimToNull(s);
        if (s == null) return null;
        try { return Date.valueOf(s); } catch (Exception e) { return null; }
    }

    //format dd/MM/yyyy
    public static String formatDateDMY(Date d) {
        if (d == null) return null;
        return d.toLocalDate().format(DMY);
    }

    public static String get(HttpServletRequest req, String name) {
        return trimToNull(req.getParameter(name));
    }
}

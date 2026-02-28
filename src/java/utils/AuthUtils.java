package utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import model.User;

public class AuthUtils {
    private AuthUtils() {}

    public static Integer getUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;

        User u = (User) session.getAttribute("userAccount");
        return (u != null) ? u.getUserId() : null;
    }
}

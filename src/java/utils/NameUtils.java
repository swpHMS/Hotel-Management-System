package utils;

public class NameUtils {
    private NameUtils() {}

    public static String initials(String fullName) {
        if (fullName == null) return "U";
        String s = fullName.trim().replaceAll("\\s+", " ");
        if (s.isEmpty()) return "U";

        String[] parts = s.split(" ");
        if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();

        String first = parts[0].substring(0, 1);
        String last  = parts[parts.length - 1].substring(0, 1);
        return (first + last).toUpperCase();
    }
}

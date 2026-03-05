package utils;

public class TestBCrypt {
    public static void main(String[] args) {
        String hash = PasswordUtils.hash("123");
        System.out.println(hash);
    }
}

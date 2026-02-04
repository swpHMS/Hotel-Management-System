package utils;

public class TestBCrypt {
    public static void main(String[] args) {
        String hash = PasswordUtils.hash("Abc12345");
        System.out.println(hash);
    }
}

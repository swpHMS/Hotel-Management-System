package context;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {

    protected Connection connection;

    private static final String URL =
            "jdbc:sqlserver://localhost:1433;databaseName=Hotel_Management_System1;encrypt=true;trustServerCertificate=true;";
    private static final String USER = "sa";
    private static final String PASS = "123";

    public DBContext() {
        try {
            ensureConnection();
        } catch (Exception e) {
            System.out.println(e);
        }
    }
    private void ensureConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        if (connection == null || connection.isClosed()) {
            connection = DriverManager.getConnection(URL, USER, PASS);
        }
    }

    public Connection getConnection() throws SQLException, ClassNotFoundException {
        ensureConnection();
        return connection;
    }
}


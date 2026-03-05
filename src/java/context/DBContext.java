package context;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    public Connection connection;

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


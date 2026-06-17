package com.inventory.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static Connection connection = null;
    
    // Datos de conexión 
    private static final String URL = "jdbc:postgresql://localhost:5432/InventorySystem";
    private static final String USER = "postgres";
    private static final String PASS = "admin";

    public static Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                // Registrar el driver 
                Class.forName("org.postgresql.Driver");
                connection = DriverManager.getConnection(URL, USER, PASS);
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return connection;
    }
}
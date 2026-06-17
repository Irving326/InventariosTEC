package com.inventory.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;
import com.inventory.util.DBConnection;

public class VentaDAO {

    public boolean procesarVenta(String cliente, double totalVenta, String[] idsProductos, String[] cantidades, String[] subtotales) {
        Connection conn = null;
        boolean exito = false;

        String sqlVenta = "INSERT INTO ventas (cliente_nombre, total) VALUES (?, ?)";
        String sqlDetalle = "INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario, subtotal) VALUES (?, ?, ?, ?, ?)";
        String sqlRestarStock = "UPDATE productos SET stock = stock - ? WHERE id = ?";
        String sqlHistorial = "INSERT INTO historial_stock (producto_id, cantidad, fecha_movimiento) VALUES (?, ?, CURRENT_TIMESTAMP)"; // Ajustado a tu estructura actual

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // 1. APAGAR AUTO-GUARDADO (INICIA TRANSACCIÓN)

            // 2. Insertar Venta Maestra y recuperar el ID generado
            int idVentaGenerada = 0;
            try (PreparedStatement psVenta = conn.prepareStatement(sqlVenta, Statement.RETURN_GENERATED_KEYS)) {
                psVenta.setString(1, cliente == null || cliente.isEmpty() ? "Público General" : cliente);
                psVenta.setDouble(2, totalVenta);
                psVenta.executeUpdate();

                try (ResultSet rs = psVenta.getGeneratedKeys()) {
                    if (rs.next()) {
                        idVentaGenerada = rs.getInt(1);
                    }
                }
            }

            // 3. Procesar el "Carrito" (Las listas que llegan del Servlet)
            try (PreparedStatement psDetalle = conn.prepareStatement(sqlDetalle);
                 PreparedStatement psStock = conn.prepareStatement(sqlRestarStock);
                 PreparedStatement psHistorial = conn.prepareStatement(sqlHistorial)) {

                for (int i = 0; i < idsProductos.length; i++) {
                    int idProd = Integer.parseInt(idsProductos[i]);
                    int cant = Integer.parseInt(cantidades[i]);
                    double sub = Double.parseDouble(subtotales[i]);
                    double precioUnitario = sub / cant; // Calculamos el precio al vuelo

                    // A) Insertar Detalle
                    psDetalle.setInt(1, idVentaGenerada);
                    psDetalle.setInt(2, idProd);
                    psDetalle.setInt(3, cant);
                    psDetalle.setDouble(4, precioUnitario);
                    psDetalle.setDouble(5, sub);
                    psDetalle.addBatch();

                    // B) Restar Stock
                    psStock.setInt(1, cant);
                    psStock.setInt(2, idProd);
                    psStock.addBatch();
                    
                    // C) Registrar auditoría (Se guarda en negativo o como prefieras interpretarlo)
                    psHistorial.setInt(1, idProd);
                    psHistorial.setInt(2, -cant); // Guardamos la cantidad en negativo para denotar salida
                    psHistorial.addBatch();
                }

                // Ejecutar todo el lote de sentencias
                psDetalle.executeBatch();
                psStock.executeBatch();
                psHistorial.executeBatch();
            }

            // 4. SI LLEGAMOS AQUÍ, TODO SALIÓ BIEN. CONFIRMAMOS.
            conn.commit();
            exito = true;

        } catch (Exception e) {
            System.err.println("Error en transacción de venta: " + e.getMessage());
            try {
                if (conn != null) conn.rollback(); // 5. SI ALGO FALLA, SE REVIERTE TODO
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return exito;
    }
}
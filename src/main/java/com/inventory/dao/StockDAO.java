package com.inventory.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import com.inventory.util.DBConnection; 
import com.inventory.model.MovimientoStock;

public class StockDAO {

	public boolean registrarEntrada(MovimientoStock movimiento) {
        String sql = "INSERT INTO historial_stock (producto_id, proveedor_id, cantidad) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, movimiento.getProductoId());
            
            // Si el proveedorId es 0 (Sin Proveedor / Ajuste interno, insertamos NULL en la BD
            if (movimiento.getProveedorId() == 0) {
                ps.setNull(2, java.sql.Types.INTEGER);
            } else {
                ps.setInt(2, movimiento.getProveedorId());
            }
            
            ps.setInt(3, movimiento.getCantidad());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al registrar historial de stock: " + e.getMessage());
            return false;
        }
    }
	
	public List<com.inventory.model.MovimientoStock>listarHistorial() {
		List<com.inventory.model.MovimientoStock> lista = new java.util.ArrayList<>();
		
		//Consulta para traer nombres reales.
		String sql = "SELECT h.id, p.nombre AS producto_nombre, prov.nombre AS proveedor_nombre, " +
                "h.cantidad, h.fecha_movimiento " +
                "FROM historial_stock h " +
                "JOIN productos p ON h.producto_id = p.id " +
                "LEFT JOIN proveedores prov ON h.proveedor_id = prov.id " +
                "ORDER BY h.fecha_movimiento DESC";
		
		try (Connection conn = com.inventory.util.DBConnection.getConnection();
		         PreparedStatement ps = conn.prepareStatement(sql);
		         ResultSet rs = ps.executeQuery()) {

		        while (rs.next()) {
		            com.inventory.model.MovimientoStock m = new com.inventory.model.MovimientoStock();
		            m.setId(rs.getInt("id"));
		            m.setCantidad(rs.getInt("cantidad"));
		            m.setFechaMovimiento(rs.getTimestamp("fecha_movimiento"));		      
		            m.setProductoNombre(rs.getString("producto_nombre"));
		            m.setProveedorNombre(rs.getString("proveedor_nombre"));
		            
		            lista.add(m);
		        }
		    } catch (SQLException e) {
		        System.err.println("Error al obtener historial de stock: " + e.getMessage());
		    }
		    return lista;
		}
	
}

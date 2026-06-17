package com.inventory.dao;

import com.inventory.model.Producto;
import com.inventory.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductoDAO {

    public List<Producto> listar() {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT p.*, prov.nombre AS proveedor_nombre " +
                "FROM productos p " +
                "LEFT JOIN proveedores prov ON p.proveedor_id = prov.id";
        
        // El uso de try-with-resources cierra automáticamente Connection, PreparedStatement y ResultSet
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
      	
            while (rs.next()) {
                Producto p = new Producto();
                p.setId(rs.getInt("id"));
                p.setNombre(rs.getString("nombre"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setPrecio(rs.getDouble("precio"));
                p.setStock(rs.getInt("stock"));
                p.setImagen(rs.getString("imagen"));
                p.setCodigo(rs.getString("codigo"));
                p.setProveedorId(rs.getInt("proveedor_id"));
                p.setProveedorNombre(rs.getString("proveedor_nombre") != null ? rs.getString("proveedor_nombre") : "Sin Proveedor");
                lista.add(p);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar productos: " + e.getMessage());
        }
        return lista;
    }
    public boolean guardar(Producto p) {
       
        String sql = "INSERT INTO productos (nombre, descripcion, precio, stock, imagen, codigo, proveedor_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, p.getNombre());
            ps.setString(2, p.getDescripcion());
            ps.setDouble(3, p.getPrecio());
            ps.setInt(4, p.getStock());
            ps.setString(5, p.getImagen());
            ps.setString(6, p.getCodigo());
            //En caso de llegar 0 se guarda null en BD
            if (p.getProveedorId() == 0) {
                ps.setNull(7, java.sql.Types.INTEGER);
            } else {
                ps.setInt(7, p.getProveedorId());
            }
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean eliminar(int id) {
        String sql = "DELETE FROM productos WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean actualizarStock(int id, int cantidad) {
        // Usamos + ? para que el usuario ingrese cuánto llega de mercancía
        String sql = "UPDATE productos SET stock = stock + ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, cantidad);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean registrarVenta(int id, int cantidad) {
        // Solo resta si el stock actual es mayor o igual a la cantidad solicitada
        String sql = "UPDATE productos SET stock = stock - ? WHERE id = ? AND stock >= ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, cantidad);
            ps.setInt(2, id);
            ps.setInt(3, cantidad);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    // Método para buscar por un único producto
    public Producto buscarPorId(int id) {
        Producto p = null;
        // Buscamos todas las columnas necesarias del producto
        String sql = "SELECT id, nombre, descripcion, precio, stock, imagen, codigo, proveedor_id FROM productos WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    p = new Producto();
                    p.setId(rs.getInt("id"));
                    p.setNombre(rs.getString("nombre"));
                    p.setDescripcion(rs.getString("descripcion"));
                    p.setPrecio(rs.getDouble("precio"));
                    p.setStock(rs.getInt("stock"));
                    p.setImagen(rs.getString("imagen"));
                    p.setCodigo(rs.getString("codigo")); // <-- Asegúrate de que esta línea exista
                    
                    // Si en la base de datos es NULL, rs.getInt devuelve 0 de forma automática
                    p.setProveedorId(rs.getInt("proveedor_id")); 
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar producto por ID: " + e.getMessage());
        }
        return p;
    }
    // Metodo actualizar datos
    public boolean actualizar(Producto p) {
    	String sql = "UPDATE productos SET nombre = ?, descripcion = ?, precio = ?, stock = ?, imagen = ?, codigo = ?, proveedor_id= ? WHERE id = ?";
    	try (Connection conn = DBConnection.getConnection();
    		PreparedStatement ps = conn.prepareStatement(sql)) {
    		
    		ps.setString(1, p.getNombre());
    		ps.setString(2, p.getDescripcion());
    		ps.setDouble(3, p.getPrecio());
    		ps.setInt(4, p.getStock());
    		ps.setString(5, p.getImagen());
    		ps.setString(6, p.getCodigo());
    		//En caso de llegar 0 se guarda null en BD
    		if (p.getProveedorId() == 0) {
    	        ps.setNull(7, java.sql.Types.INTEGER);
    	    } else {
    	        ps.setInt(7, p.getProveedorId());
    	    }
    		
    		ps.setInt(8, p.getId());
    		
    		return ps.executeUpdate() > 0;
    	} catch (SQLException e) {
    		e.printStackTrace();
    		return false;
    	}
    }
}
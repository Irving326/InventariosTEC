package com.inventory.dao;

import com.inventory.model.Producto;
import com.inventory.model.Proveedor;
import com.inventory.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProveedorDAO {
    
    public List<Proveedor> listar() {
        List<Proveedor> lista = new ArrayList<>();
        String sql = "SELECT * FROM proveedores ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Proveedor p = new Proveedor();
                p.setId(rs.getInt("id"));
                p.setNombre(rs.getString("nombre"));
                p.setDireccion(rs.getString("direccion"));
                p.setTelefono(rs.getString("telefono"));
                p.setCorreo(rs.getString("correo"));
                lista.add(p);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public boolean guardar(Proveedor p) {
        String sql = "INSERT INTO proveedores (nombre, direccion, telefono, correo) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getNombre());
            ps.setString(2, p.getDireccion());
            ps.setString(3, p.getTelefono());
            ps.setString(4, p.getCorreo());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM proveedores WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
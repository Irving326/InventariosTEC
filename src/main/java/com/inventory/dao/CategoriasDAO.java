package com.inventory.dao;
import com.inventory.model.Categoria;
import com.inventory.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoriasDAO {

	public List<Categoria> listar() {
	    List<Categoria> lista = new ArrayList<>();
	    String sql = "SELECT id, nombre FROM categoria ORDER BY nombre ASC";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {
	        while (rs.next()) {
	            Categoria c = new Categoria();
	            c.setId(rs.getInt("id"));
	            c.setNombre(rs.getString("nombre"));
	            lista.add(c);
	        }
	    } catch (SQLException e) { e.printStackTrace(); }
	    return lista;
	}
	
}



package com.inventory.model;

import java.sql.Timestamp;

public class MovimientoStock {

	private int id;
	private int productoId;
	private int proveedorId;
	private int cantidad;
	private Timestamp fechaMovimiento;
	private String producto_nombre;
	private String proveedor_nombre;
	
	
	public MovimientoStock() {
		
	}
		
		
		// Getters y Setters
	    public int getId() { return id; }
	    public void setId(int id) { this.id = id; }

	    public int getProductoId() { return productoId; }
	    public void setProductoId(int productoId) { this.productoId = productoId; }

	    public int getProveedorId() { return proveedorId; }
	    public void setProveedorId(int proveedorId) { this.proveedorId = proveedorId; }

	    public int getCantidad() { return cantidad; }
	    public void setCantidad(int cantidad) { this.cantidad = cantidad; }

	    public Timestamp getFechaMovimiento() { return fechaMovimiento; }
	    public void setFechaMovimiento(Timestamp fechaMovimiento) { this.fechaMovimiento = fechaMovimiento; }
	
	    public String getProductoNombre() { return producto_nombre; }
	    public void setProductoNombre(String producto_nombre) { this.producto_nombre = producto_nombre; }
	    
	    public String getProveedorNombre() { return proveedor_nombre; }
	    public void setProveedorNombre(String proveedor_nombre) { this.proveedor_nombre = proveedor_nombre; }
	    
		
	}
	



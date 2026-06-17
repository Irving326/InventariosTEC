package com.inventory.model;

public class Producto {
    private int id;
    private String nombre;
    private String descripcion;
    private double precio;
    private String imagen;
    private int stock;
    private String codigo;
    private int CategoriaId;
    private int proveedorId;
    private String proveedorNombre;

    
    public Producto() {}

    // Getters y Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    public double getPrecio() { return precio; }
    public void setPrecio(double precio) { this.precio = precio; }
    public String getImagen() { return imagen; }
    public void setImagen(String imagen) { this.imagen = imagen; }
    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }
    public String getCodigo() {return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }
    public int getCategoriaId() { return CategoriaId; } 
    public void setCategoriaId(int CategoriaId) { this.CategoriaId = CategoriaId; }
    public int getProveedorId() { return proveedorId; }
    public void setProveedorId(int proveedorId) { this.proveedorId = proveedorId; }

    public String getProveedorNombre() { return proveedorNombre; }
    public void setProveedorNombre(String proveedorNombre) { this.proveedorNombre = proveedorNombre; }
}
package com.inventory.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import com.inventory.dao.ProductoDAO;
import com.inventory.dao.VentaDAO;
import com.inventory.model.Producto;

@WebServlet("/VentaServlet")
public class VentaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Cargar productos para que el cajero pueda seleccionarlos en el select
        ProductoDAO productoDao = new ProductoDAO();
        try {
            List<Producto> listaProductos = productoDao.listar();
            request.setAttribute("productos", listaProductos);
            request.getRequestDispatcher("nueva-venta.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // 1. Recibir datos maestros
        String cliente = request.getParameter("cliente");
        double total = Double.parseDouble(request.getParameter("totalVenta"));
        
        // 2. Recibir arreglos de detalles generados por JavaScript (inputs hidden)
        String[] idsProductos = request.getParameterValues("item_id");
        String[] cantidades = request.getParameterValues("item_cantidad");
        String[] subtotales = request.getParameterValues("item_subtotal");
        
        // 3. Validar que la lista no esté vacía
        if (idsProductos == null || idsProductos.length == 0) {
            response.sendRedirect("VentaServlet?msg=vacio");
            return;
        }

        // 4. Procesar transacción
        VentaDAO ventaDao = new VentaDAO();
        boolean exito = ventaDao.procesarVenta(cliente, total, idsProductos, cantidades, subtotales);
        
        if (exito) {
            response.sendRedirect("VentaServlet?msg=success");
        } else {
            response.sendRedirect("VentaServlet?msg=error");
        }
    }
}
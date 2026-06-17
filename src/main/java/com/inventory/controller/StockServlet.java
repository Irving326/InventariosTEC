package com.inventory.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

import com.inventory.dao.ProductoDAO;
import com.inventory.dao.ProveedorDAO;
import com.inventory.dao.StockDAO;
import com.inventory.model.MovimientoStock;
import com.inventory.model.Producto;
import com.inventory.model.Proveedor;



/**
 * Servlet implementation class StockServlet
 */
@WebServlet("/StockServlet")
public class StockServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private ProductoDAO productoDao = new ProductoDAO();
	private ProveedorDAO proveedorDao = new ProveedorDAO();
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public StockServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
    	String accion = request.getParameter("accion");
    	StockDAO stockDao = new StockDAO();
    	
    	// 1. NUEVO: Interceptar exportación a CSV
    	if ("exportarCSV".equals(accion)) {
    		exportarCSV(request, response, stockDao);
    		return; // Freno de mano para que no siga bajando
    	}
    	
    	// 2. NUEVO: Interceptar exportación a PDF
    	if ("exportarPDF".equals(accion)) {
    		exportarPDF(request, response, stockDao);
    		return; // Freno de mano
    	}
    	
    	// Ver registros en modulo reporte
    	if("historial".equals(accion)) {
    		List<com.inventory.model.MovimientoStock> historial = stockDao.listarHistorial();
    		request.setAttribute("historial", historial);
    		request.getRequestDispatcher("historial-entradas.jsp").forward(request, response);
    		return;
    	}
    	
    	
    	
        //  Pantalla de asignar Stock
        
        try {
            List<Producto> listaProductos = productoDao.listar();
            List<Proveedor> listaProveedores = proveedorDao.listar();       
             
            request.setAttribute("productos", listaProductos);
            request.setAttribute("proveedores", listaProveedores);        
           
            request.getRequestDispatcher("asignar-stock.jsp").forward(request, response);
            return; 
            
        } catch (Exception e) {
            System.err.println("Error en doGet de StockServlet: " + e.getMessage());
            e.printStackTrace();
        }
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		int idProducto = Integer.parseInt(request.getParameter("producto_id"));
	    int cantidad = Integer.parseInt(request.getParameter("cantidad"));
	    int proveedorId = Integer.parseInt(request.getParameter("proveedor_id"));
	    
	    ProductoDAO productoDao = new ProductoDAO();
	    StockDAO stockDao = new StockDAO();
	    
	    
	    
	    
	    if (productoDao.actualizarStock(idProducto, cantidad)) {
	    
	        MovimientoStock movimiento = new MovimientoStock();
	        movimiento.setProductoId(idProducto);
	        movimiento.setProveedorId(proveedorId);
	        movimiento.setCantidad(cantidad);
	        
	        boolean historialGuardado = stockDao.registrarEntrada(movimiento);
	        
	        if (historialGuardado) {
	            response.sendRedirect("StockServlet?msg=ok");
	        } else {
	        
	            response.sendRedirect("StockServlet?msg=error_historial");
	        }
	        return; 
	        
	    } else {
	     
	        response.sendRedirect("StockServlet?msg=error");
	        return;
	    }
	}
	
	//Descarga CSV
	private void exportarCSV(HttpServletRequest request, HttpServletResponse response, StockDAO stockDao) 
	        throws IOException {
		
		response.setContentType("text/csv; charset=UTF-8");
	    response.setHeader("Content-Disposition", "attachment; filename=Historial_Entradas_" + System.currentTimeMillis()+ ".csv");
	    		
	    List<com.inventory.model.MovimientoStock> historial = stockDao.listarHistorial();
	    
	    try (PrintWriter writer = response.getWriter()){
	    	writer.write('\ufeff');
	    	
	    	writer.println("Producto,Proveedor,Cantidad Ingresada,Fecha y Hora");
	    	java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
	    	
	    	for (com.inventory.model.MovimientoStock mov : historial) {
	    		String fechaStr = mov.getFechaMovimiento() !=null ? sdf.format(mov.getFechaMovimiento()) : "";
	    		
	    		writer.println(String.format("%d,%s,%s,%d,%s",
	                    mov.getId(),
	                    escaparCSV(mov.getProductoNombre()),
	                    escaparCSV(mov.getProveedorNombre()),
	                    mov.getCantidad(),
	                    fechaStr
	                ));
	            }
	            writer.flush();
	        }
	}
	private String escaparCSV(String valor) {
        if (valor == null) return "";
        if (valor.contains(",") || valor.contains("\"") || valor.contains("\n")) {
            valor = valor.replace("\"", "\"\"");
            return "\"" + valor + "\"";
        }
        return valor;
    }
	private void exportarPDF(HttpServletRequest request, HttpServletResponse response, StockDAO stockDao) 
	        throws ServletException, IOException {
	    
	    response.setContentType("application/pdf");
	    response.setHeader("Content-Disposition", "attachment; filename=Historial_Movimientos.pdf");
	    
	    List<com.inventory.model.MovimientoStock> historial = stockDao.listarHistorial();
	    
	    Document documento = new Document();
	    
	    try {
	        PdfWriter.getInstance(documento, response.getOutputStream());
	        documento.open();
	        
	        // Título del Reporte Globalizado
	        Paragraph titulo = new Paragraph("InventariosTEC - Historial Global de Movimientos (Kardex)\n\n");
	        titulo.setAlignment(Paragraph.ALIGN_CENTER);
	        documento.add(titulo);
	        
	        // Mantener las 5 columnas pero optimizando los títulos
	        PdfPTable tabla = new PdfPTable(5);
	        tabla.setWidthPercentage(100); 
	        
	        // Cabeceras de la tabla adaptadas al nuevo flujo unificado
	        tabla.addCell(new PdfPCell(new Phrase("Tipo")));
	        tabla.addCell(new PdfPCell(new Phrase("Producto")));
	        tabla.addCell(new PdfPCell(new Phrase("Origen / Destino")));
	        tabla.addCell(new PdfPCell(new Phrase("Cantidad")));
	        tabla.addCell(new PdfPCell(new Phrase("Fecha y Hora")));
	        
	        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
	        
	        // Llenar datos dinámicamente
	        for (com.inventory.model.MovimientoStock mov : historial) {
	            boolean esSalida = mov.getCantidad() < 0;
	            
	            // 1. Columna Tipo
	            tabla.addCell(esSalida ? "SALIDA" : "ENTRADA");
	            
	            // 2. Columna Producto
	            tabla.addCell(mov.getProductoNombre());
	            
	            // 3. Columna Origen/Destino (Evita el "null" visual)
	            String origenDestino = (mov.getProveedorNombre() != null) ? mov.getProveedorNombre() : "Cliente / Venta Interna";
	            tabla.addCell(origenDestino);
	            
	            // 4. Columna Cantidad (CORREGIDO: Control del prefijo de signo)
	            if (esSalida) {
	                // Las salidas ya traen el menos incorporado (ej: -15 u.)
	                tabla.addCell(mov.getCantidad() + " u.");
	            } else {
	                // Las entradas necesitan que se les concatene explícitamente el '+'
	                tabla.addCell("+ " + mov.getCantidad() + " u.");
	            }
	            
	            // 5. Columna Fecha
	            tabla.addCell(mov.getFechaMovimiento() != null ? sdf.format(mov.getFechaMovimiento()) : "");
	        }
	        
	        documento.add(tabla);
	        
	    } catch (DocumentException e) {
	        e.printStackTrace();
	    } finally {
	        if (documento.isOpen()) {
	            documento.close(); 
	        }
	    }
	}
}

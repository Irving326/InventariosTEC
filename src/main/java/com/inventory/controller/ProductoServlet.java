package com.inventory.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import com.inventory.dao.ProductoDAO;
import com.inventory.dao.ProveedorDAO;
import com.inventory.model.Producto;
import com.inventory.model.Proveedor;

/**
 * Servlet implementation class ProductoServlet
 */
@WebServlet("/ProductoServlet")
@MultipartConfig
public class ProductoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	private ProductoDAO dao = new ProductoDAO();
	private ProveedorDAO proveedorDao = new ProveedorDAO();
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ProductoServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
	            throws ServletException, IOException {
	        
	    String accion = request.getParameter("accion");
	
	    // Acción de eliminar
	    if ("eliminar".equals(accion)) {
	        int id = Integer.parseInt(request.getParameter("id"));
	        dao.eliminar(id);
	        response.sendRedirect("ProductoServlet?accion=listar&msg=deleted");
	        return; 
	    }
	    
		//Accion Editar artículo
	    if ("editar".equals(accion)) {
	    	int id = Integer.parseInt(request.getParameter("id"));
	    	Producto producto = dao.buscarPorId(id);
	    	List<Proveedor> listaProveedores = proveedorDao.listar();
	    	
	    	request.setAttribute("producto", producto);
	    	request.setAttribute("proveedores", listaProveedores); // Requerido para el select en editar
	    	request.getRequestDispatcher("editar.jsp").forward(request, response);
	    	return;
	    }
	    
	    
	 // Acción de ir al formulario de NUEVO artículo
	    if ("nuevo".equals(accion)) {
	        ProveedorDAO proveedorDao = new ProveedorDAO(); // Instancias el DAO de proveedores
	        List<Proveedor> listaProveedores = proveedorDao.listar();
	        
	        request.setAttribute("proveedores", listaProveedores);
	        request.getRequestDispatcher("NuevoArticulo.jsp").forward(request, response);
	        return;
	    }
	    
	    //Acción de ir al catálogo de artículos
	    
	        List<Producto> listaProductos = dao.listar();
	        request.setAttribute("productos", listaProductos);
	        request.getRequestDispatcher("articulos.jsp").forward(request, response);
	        return;  
	       
	        
	}
    
		

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
		
        
        try {
            //Capturar datos 
            String idStr = request.getParameter("id");
        	String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");
            double precio = Double.parseDouble(request.getParameter("precio"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            String codigo = request.getParameter("codigo");
            //En caso de campo vacío se asignará valor por defecto
            int proveedorId = 0; 
            String provStr = request.getParameter("proveedor_id");
            if (provStr != null && !provStr.trim().isEmpty()) {
                proveedorId = Integer.parseInt(provStr);
            }
           
         //Procesar imagen
            Part filePart = request.getPart("imagen");
            String fileName = "default.png"; // Imagen base

            boolean esEdicion = (idStr != null && !idStr.trim().isEmpty());

            if (filePart != null && filePart.getSize() > 0) {
                
                // 1. Extraer nombre y agregarle el tiempo actual para que sea ÚNICO
                String nombreOriginal = filePart.getSubmittedFileName();
                fileName = System.currentTimeMillis() + "_" + nombreOriginal; 
                
                // 2. Usar la ruta temporal de despliegue de Tomcat
                String uploadPath = getServletContext().getRealPath("") + java.io.File.separator + "imagenes";
                
                // 3. Crear la carpeta en el servidor si no existe
                java.io.File uploadDir = new java.io.File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                // 4. Escribir el archivo
                filePart.write(uploadPath + java.io.File.separator + fileName);
                
            } else if (esEdicion) {
                // Si es edición y no hay foto nueva, mantener la anterior
                int idTemp = Integer.parseInt(idStr);
                Producto prodActual = dao.buscarPorId(idTemp);
                if (prodActual != null && prodActual.getImagen() != null) {
                    fileName = prodActual.getImagen();
                }
            }

            // Crear objeto y guardar
            Producto p = new Producto();
            p.setNombre(nombre);
            p.setDescripcion(descripcion);
            p.setPrecio(precio);
            p.setStock(stock);
            p.setCodigo(codigo);
            p.setImagen(fileName); 
            p.setProveedorId(proveedorId);
            boolean resultado;

            // Registra mediante el ID si se esta editanto o creando un nuevo registro
            
            if (idStr != null && !idStr.trim().isEmpty()) {
                int id = Integer.parseInt(idStr);
                p.setId(id);
                resultado = dao.actualizar(p); // Llama al método de actualizar
            } else {
                resultado = dao.guardar(p); // Llama al método de insertar nuevo
            }

            if (resultado) {
                // Redirige al listado de artículos para ver los cambios reflejados
                response.sendRedirect("ProductoServlet?msg=success");
            } else {
                // Si falla la actualización y existía un ID, regresamos a editar, si no, a NuevoArticulo
                if (idStr != null && !idStr.trim().isEmpty()) {
                    response.sendRedirect("ProductoServlet?accion=editar&id=" + idStr + "&msg=error");
                } else {
                    response.sendRedirect("NuevoArticulo.jsp?msg=error");
                }
            }
            
	        } catch (Exception e) {
	            e.printStackTrace();
	            // Lo mismo para datos inválidos en el formulario
	            String idStr = request.getParameter("id");
	            if (idStr != null && !idStr.trim().isEmpty()) {
	                response.sendRedirect("ProductoServlet?accion=editar&id=" + idStr + "&msg=invalid_data");
	            } else {
	                response.sendRedirect("NuevoArticulo.jsp?msg=invalid_data");
            }
        }
	}
}



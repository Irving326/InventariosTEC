package com.inventory.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import com.inventory.dao.ProveedorDAO;
import com.inventory.model.Proveedor;

/**
 * Servlet implementation class ProveedorServlet
 */
@WebServlet("/ProveedorServlet")
public class ProveedorServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private ProveedorDAO dao = new ProveedorDAO();
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ProveedorServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");
        
     // Acción de ir al formulario de NUEVO proveedor
	    if ("nuevo".equals(accion)) {
	        request.getRequestDispatcher("NuevoProveedor.jsp").forward(request, response);
	        return;
	    }
        
        if ("eliminar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.eliminar(id);
            response.sendRedirect("ProveedorServlet");
            return;
        }
        
        // Si no es eliminar, listar
        request.setAttribute("proveedores", dao.listar());
        request.getRequestDispatcher("registro-proveedor.jsp").forward(request, response);
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Configurar codificación para evitar problemas con acentos o caracteres especiales
        request.setCharacterEncoding("UTF-8");
        
        Proveedor p = new Proveedor();
        p.setNombre(request.getParameter("nombre"));
        p.setDireccion(request.getParameter("direccion"));
        p.setTelefono(request.getParameter("telefono"));
        p.setCorreo(request.getParameter("correo"));

        // Guardamos y capturamos si la operación fue exitosa
        boolean guardadoExitoso = dao.guardar(p); 
        
        if (guardadoExitoso) {
            // Redirige al listado general mandando un mensaje de éxito
            response.sendRedirect("ProveedorServlet?msg=success"); 
        } else {
            // Redirigimos indicando el fallo
            response.sendRedirect("ProveedorServlet?accion=nuevo&msg=error");
        }
        return;
    }

}

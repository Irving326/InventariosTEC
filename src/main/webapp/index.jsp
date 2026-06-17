<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% response.sendRedirect("ProductoServlet?accion=listar"); %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>InventariosTEC | Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
   
   <link href="${pageContext.request.contextPath}/CSS/estilos.css" rel="stylesheet" type="text/css">
</head>
<body class="d-flex">

    <div class="sidebar d-flex flex-column p-3 text-white shadow">
        <a href="ProductoServlet" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-white text-decoration-none">
            <span class="material-icons me-2 fs-2">inventory</span>
            <span class="fs-4 fw-bold">InventariosTEC</span>
        </a>
        <hr>
        <ul class="nav nav-pills flex-column mb-auto gap-2">
		    <li>
		        <a href="ProductoServlet?accion=listar" class="nav-link d-flex align-items-center">
		            <span class="material-icons me-3">add_box</span>
		            Gestión de Artículos
		        </a>
		    </li>
		    <li>
			    <a href="VentaServlet" class="nav-link d-flex align-items-center">
			        <span class="material-icons me-3">point_of_sale</span> Salidas / Ventas
			    </a>
			</li>
		    <li>
		        <a href="ProveedorServlet" class="nav-link d-flex align-items-center">
		            <span class="material-icons me-3">local_shipping</span>
		            Proveedores
		        </a>
		    </li>
		    <li>
		        <a href="StockServlet" class="nav-link d-flex align-items-center">
		            <span class="material-icons me-3">inventory_2</span>
		            Asignar Stock
		        </a>
		    </li>
		    <li>
			    <a href="StockServlet?accion=historial" class="nav-link d-flex align-items-center">
			        <span class="material-icons me-3">history</span>
			        Reportes
			    </a>
			</li>
			
		</ul>
        <hr>
        
    </div>

    

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Inventario | Asignar Stock</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
</head>
<style>
        /* Estilos para que la barra lateral ocupe toda la altura */
        body {
            min-height: 100vh;
            overflow-x: hidden;
        }
        .sidebar {
            width: 280px;
            min-height: 100vh;
            background-color: #212529; /* bg-dark */
        }
        .sidebar .nav-link {
            color: #adb5bd;
            transition: all 0.3s;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            color: #fff;
            background-color: #0d6efd; /* bg-primary */
        }
        .content-area {
            flex-grow: 1;
            background-color: #f8f9fa; /* bg-light */
        }
    </style>
<body class="d-flex">
	<div class="sidebar d-flex flex-column p-3 text-white shadow">
        <a href="ProductoServlet" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-white text-decoration-none">
            <span class="material-icons me-2 fs-2">inventory</span>
            <span class="fs-4 fw-bold">InventariosTEC</span>
        </a>
        <hr>
        <ul class="nav nav-pills flex-column mb-auto gap-2">
            <li>
                <a href="ProductoServlet" class="nav-link d-flex align-items-center">
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
    
	<div class="content-area p-4">
	    <div class="row mb-4">
	        <div class="col-12 d-flex justify-content-between align-items-center">
	            <h2><span class="material-icons align-middle">inventory_2</span> Entrada de Mercancía</h2>
	        </div>
	    </div>
	
	    <c:if test="${param.msg == 'ok'}">
	        <div class="alert alert-success alert-dismissible fade show" role="alert">
	            ¡Stock actualizado correctamente!
	            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	        </div>
	    </c:if>
	
	    <div class="row g-4">
	        <!-- Formulario de Entrada -->
	        <div class="col-md-4">
	    <div class="card shadow-sm border-0">
	        <div class="card-header bg-dark text-white">Registrar Entrada</div>
	        <div class="card-body">
	            <form action="StockServlet" method="post">
	                
	                <div class="mb-3">
	                    <label class="form-label fw-bold">Seleccionar Producto</label>
	                    <select name="producto_id" class="form-select" required>
	                        <option value="" disabled selected>Elegir artículo...</option>
	                        <c:forEach items="${productos}" var="p">
	                            <option value="${p.id}">${p.nombre} (Actual: ${p.stock})</option>
	                        </c:forEach>
	                    </select>
	                </div> 
	                <div class="mb-3">
	                    <label for="proveedor_id" class="form-label fw-bold">Proveedor que surtió</label>
	                    <select class="form-select" id="proveedor_id" name="proveedor_id">
	                        <option value="0" selected>Sin Proveedor/Ajuste manual</option>
	                        <c:forEach items="${proveedores}" var="prov">
	                            <option value="${prov.id}">${prov.nombre}</option>
	                        </c:forEach>
	                    </select>
	                </div>
	                    
	                <div class="mb-3">
	                    <label class="form-label fw-bold">Cantidad a Ingresar</label>
	                    <input type="number" name="cantidad" class="form-control" min="1" required>
	                </div>
	                
	                <button type="submit" class="btn btn-primary w-100">
	                    <span class="material-icons align-middle" style="font-size: 18px;">add</span> Aumentar Stock
	                </button>
	            </form>
	        </div>
	    </div>
	</div>

        <!-- Vista previa de Inventario -->
        <div class="col-md-8">
            <div class="card shadow-sm border-0">
                <div class="card-body p-0">
                    <table class="table table-striped mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Producto</th>
                                <th>Precio</th>
                                <th class="text-center">Stock Actual</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${productos}" var="p">
                                <tr>
                                    <td>${p.nombre}</td>
                                    <td>$${p.precio}</td>
                                    <td class="text-center">
                                        <span class="badge ${p.stock < 5 ? 'bg-danger' : 'bg-success'}">
                                            ${p.stock}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
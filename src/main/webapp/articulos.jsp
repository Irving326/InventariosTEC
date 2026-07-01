<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>InventariosTEC | Artículos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/CSS/estilos.css" rel="stylesheet" type="text/css">
</head>
<body class="d-flex">

    <div class="sidebar d-flex flex-column p-3 text-white shadow">
        <a href="ProductoServlet" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-white text-decoration-none">
            <span class="fs-4 fw-bold">InventariosTEC</span>
        </a>
        <hr>
        <ul class="nav nav-pills flex-column mb-auto gap-2">
            <li>
                <a href="ProductoServlet" class="nav-link active d-flex align-items-center" aria-current="page">
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
    </div>

    <div class="content-area p-4">
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold">Control Central de Artículos</h2>
                <p class="text-muted mb-0">Administre el catálogo, existencias y eliminaciones desde un solo lugar.</p>
            </div>
           	<a href="ProductoServlet?accion=nuevo" class="btn btn-primary">
			    <i class="bi bi-plus-circle"></i> Añadir Nuevo Artículo
			</a>
        </div>

        <c:if test="${param.msg == 'deleted'}">
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                Artículo eliminado correctamente del sistema.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="card border-0 shadow-sm">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th style="width: 80px;">Código</th>
                                <th>Nombre del Producto</th>
                                <th>Descripción</th>
                                <th>Proveedor</th>
                                <th>Imagen</th>
                                <th>Precio Unitario</th>
                                <th class="text-center" style="width: 120px;">Stock Actual</th>
                                <th class="text-center" style="width: 320px;">Acciones de Inventario</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${productos}" var="p">
                                <tr>
                                    <td class="text-muted fw-bold">${p.codigo}</td>
                                    <td>
                                        <span class="fw-semibold text-dark">${p.nombre}</span>
                                    </td>
                                    <td>
                                    	<span class="fw-semibold text-dark">${p.descripcion}</span>
                                    </td>
                                    
									<td>
									    <span class="fw-semibold text-dark">${p.proveedorNombre}</span>
									</td>
                                    
                                    <td>
                                    	<img src="${pageContext.request.contextPath}/imagenes/${p.imagen}" 
									     class="img-thumbnail" 
									     style="max-width: 150px; max-height: 150px;">
                                    </td>
                                    <td class="text-success fw-bold">$${p.precio}</td>
                                    <td class="text-center">
                                        <span class="badge ${p.stock < 5 ? 'bg-danger' : 'bg-success'} px-3 py-2">
                                            ${p.stock} u.
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <div class="d-flex justify-content-center gap-1">
                                            
                                            
                                            <a href="StockServlet" class="btn btn-sm btn-outline-primary d-flex align-items-center gap-1" title="Ir a Stock">
											    <span class="material-icons" style="font-size: 16px;">add</span> Stock
											</a>
											 

                                            <a href="ProductoServlet?accion=eliminar&id=${p.id}" 
                                               class="btn btn-sm btn-danger d-flex align-items-center gap-1"
                                               onclick="return confirm('¿Realmente deseas eliminar permanentemente a: ${p.nombre}?');">
                                                <span class="material-icons" style="font-size: 16px;">delete</span> Eliminar
                                            </a>
                                            
                                            <a href="ProductoServlet?accion=editar&id=${p.id}">
                                            	<span class="material-icons" style="font-size: 16px;">edit</span> Editar
                                            </a>
                                            
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty productos}">
                                <tr>
                                    <td colspan="5" class="text-center py-5 text-muted">
                                        <span class="material-icons display-4 d-block mb-2">inventory_2</span>
                                        No se encontraron artículos registrados en el catálogo.
                                    </td>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div> 
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
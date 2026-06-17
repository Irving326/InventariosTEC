<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>InventariosTEC | Proveedores</title>
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
                <a href="ProveedorServlet" class="nav-link active d-flex align-items-center">
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
        <div class="container-fluid">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div class="d-flex align-items-center gap-2">
                    <span class="material-icons fs-2 text-secondary">local_shipping</span>
                    <h2 class="fw-bold mb-0">Gestión de Proveedores</h2>
                </div>
                <a href="ProveedorServlet?accion=nuevo" class="btn btn-primary d-flex align-items-center">
                    <span class="material-icons me-1" style="font-size: 18px;">add_circle</span> Añadir Nuevo Proveedor
                </a>
            </div>

            <c:if test="${param.msg == 'success'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center" role="alert">
                    <span class="material-icons me-2">check_circle</span>
                    ¡Proveedor registrado y guardado con éxito!
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            
            <c:if test="${param.msg == 'error'}">
                <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
                    <span class="material-icons me-2">error</span>
                    Hubo un problema al intentar guardar el proveedor. Por favor, inténtalo de nuevo.
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="card shadow border-0">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-dark">
                                <tr>
                                    <th class="ps-3">Nombre</th>
                                    <th>Dirección</th>
                                    <th>Teléfono</th>
                                    <th>Correo</th>
                                    <th class="text-center">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty proveedores}">
                                        <tr>
                                            <td colspan="5" class="text-center py-4 text-muted">
                                                No hay proveedores registrados en el sistema.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${proveedores}" var="prov">
                                            <tr>
                                                <td class="ps-3 fw-bold">${prov.nombre}</td>
                                                <td>${prov.direccion}</td>
                                                <td>${prov.telefono}</td>
                                                <td><a href="mailto:${prov.correo}" class="text-decoration-none">${prov.correo}</a></td>
                                                <td class="text-center">
                                                    <a href="ProveedorServlet?accion=eliminar&id=${prov.id}" 
                                                       class="btn btn-sm btn-outline-danger d-inline-flex align-items-center" 
                                                       onclick="return confirm('¿Está seguro de que desea eliminar a este proveedor?')">
                                                        <span class="material-icons me-1" style="font-size: 16px;">delete</span> Eliminar
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div> </div> </div> <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Inventario | Editar Artículo</title>
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
                <a href="ProductoServlet" class="nav-link active d-flex align-items-center">
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
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card shadow-sm">
                        
                        <div class="card-header bg-primary text-white">
                            <h4 class="mb-0">Actualizar Artículo</h4>
                        </div>
                        
                        <div class="card-body p-4">
                            
                            <c:if test="${param.msg == 'error'}">
                                <div class="alert alert-danger">Error al actualizar el artículo en la base de datos.</div>
                            </c:if>
                            <c:if test="${param.msg == 'invalid_data'}">
                                <div class="alert alert-warning">Datos inválidos. Por favor verifica los campos numéricos.</div>
                            </c:if>
                                                    
                            <form action="ProductoServlet" method="post" enctype="multipart/form-data">
                                
                                <input type="hidden" name="id" value="${producto.id}">
                                
                                <div class="mb-3">
                                    <label for="nombre" class="form-label fw-bold">Nombre del Artículo</label>
                                    <input type="text" class="form-control" id="nombre" name="nombre" 
                                           value="${producto.nombre}" required>
                                </div>
                                
                                 <div class="mb-3">
                                    <label for="codigo" class="form-label fw-bold">Código</label>
                                    <input type="text" class="form-control" id="codigo" name="codigo" 
                                           value="${producto.codigo}" required>
                                </div>

                                <div class="mb-3">
                                    <label for="descripcion" class="form-label fw-bold">Descripción</label>
                                    <textarea class="form-control" id="descripcion" name="descripcion" rows="3" required>${producto.descripcion}</textarea>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="precio" class="form-label fw-bold">Precio de Venta</label>
                                        <input type="number" step="0.01" class="form-control" name="precio" id="precio" 
                                               value="${producto.precio}" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="stock" class="form-label fw-bold">Stock Actual</label>
                                        <input type="number" class="form-control" name="stock" id="stock" 
                                               value="${producto.stock}" required>
                                    </div>
                                    
                                    <div class="mb-3">
									    <label for="proveedor_id" class="form-label fw-bold">Proveedor Asignado</label>
									    <select class="form-select" id="proveedor_id" name="proveedor_id" >
									        <option value="0" ${producto.proveedorId == 0 ? 'selected' : ''}>Sin Proveedor</option>
									        
									        <c:forEach items="${proveedores}" var="prov">
									            <option value="${prov.id}" ${prov.id == producto.proveedorId ? 'selected' : ''}>
									                ${prov.nombre}
									            </option>
									        </c:forEach>
									        
									    </select>
									</div>
                                </div>
                                
                                <div class="mb-4">
                                    <label for="imagen" class="form-label fw-bold">Actualizar Imagen (Opcional)</label>
                                    <input class="form-control" type="file" id="imagen" name="imagen" accept="image/*">
                                    <div class="form-text">Formatos permitidos: JPG, PNG. Máximo 2MB.</div>
                                </div>

                                <hr>

                                <div class="d-flex justify-content-between">
                                    <a href="ProductoServlet" class="btn btn-outline-secondary d-flex align-items-center">
                                        <span class="material-icons me-1">arrow_back</span> Volver
                                    </a>

                                    <div>
                                 
                                        
                                        <button type="submit" class="btn btn-success">
                                            Guardar Cambios
                                        </button>
                                    </div>
                                </div>

                            </form>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
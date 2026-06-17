<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Nuevo proveedor</title>
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
                <a href="ProductoServlet" class="nav-link d-flex align-items-center">
                    <span class="material-icons me-3">add_box</span> Gestión de Artículos
                </a>
            </li>
            <li>
			    <a href="VentaServlet" class="nav-link d-flex align-items-center">
			        <span class="material-icons me-3">point_of_sale</span> Salidas / Ventas
			    </a>
			</li>
            <li>
                <a href="ProveedorServlet" class="nav-link active d-flex align-items-center" aria-current="page">
                    <span class="material-icons me-3">local_shipping</span> Proveedores
                </a>
            </li>
            <li>
                <a href="StockServlet" class="nav-link d-flex align-items-center">
                    <span class="material-icons me-3">inventory_2</span> Asignar Stock
                </a>
            </li>
            <li>
			    <a href="StockServlet?accion=historial" class="nav-link d-flex align-items-center">
			        <span class="material-icons me-3">history</span> Reportes
			    </a>
			</li>
        </ul>
    </div>
    
    <div class="content-area p-4">
        <div class="container mt-4">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-dark text-white">
                            <h4 class="mb-0 fs-5">Registrar Nuevo Proveedor</h4>
                        </div>
                        <div class="card-body p-4">
                            
                            <c:if test="${param.msg == 'success'}">
							    <div class="alert alert-success d-flex align-items-center" role="alert">
                                    <span class="material-icons me-2">check_circle</span> ¡Proveedor guardado exitosamente!
                                </div>
							</c:if>
							<c:if test="${param.msg == 'error'}">
							    <div class="alert alert-danger d-flex align-items-center" role="alert">
                                    <span class="material-icons me-2">error</span> Error al guardar el proveedor en la base de datos.
                                </div>
							</c:if>

                            <form action="ProveedorServlet" method="post">
                                
                                <div class="mb-3">
                                    <label for="nombre" class="form-label fw-bold">Nombre o Razón Social</label>
                                    <input type="text" id="nombre" name="nombre" class="form-control" placeholder="Ej. Proveedora Global S.A." required>
                                </div>

								<div class="mb-3">
                                    <label for="direccion" class="form-label fw-bold">Dirección</label>
                                    <input type="text" id="direccion" name="direccion" class="form-control" placeholder="Ej. Av. Principal #123, Col. Centro">
                                </div>
								
                                <div class="mb-3">
                                    <label for="telefono" class="form-label fw-bold">Teléfono de Contacto</label>
                                    <input type="text" id="telefono" name="telefono" class="form-control" placeholder="Ej. 6741234567">
                                </div>

							    <div class="mb-3">
								    <label for="correo" class="form-label fw-bold">Correo Electrónico</label>
								    <input type="email" id="correo" name="correo" class="form-control" placeholder="ejemplo@proveedor.com">
								</div>
			
                                <hr class="my-4">

                                <div class="d-flex justify-content-between">
                                    <a href="ProveedorServlet" class="btn btn-outline-secondary d-flex align-items-center">
                                        <span class="material-icons me-1">arrow_back</span> Volver
                                    </a>

                                    <div>
                                        <button type="reset" class="btn btn-warning me-2 text-dark"> 
                                            Limpiar Campos
                                        </button>
                                        
                                        <button type="submit" class="btn btn-success">
                                            Guardar Proveedor
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
</html>
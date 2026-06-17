<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>InventariosTEC | Historial de Movimientos</title>
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
                <a href="ProveedorServlet" class="nav-link d-flex align-items-center">
                    <span class="material-icons me-3">local_shipping</span> Proveedores
                </a>
            </li>
            <li>
                <a href="StockServlet" class="nav-link d-flex align-items-center">
                    <span class="material-icons me-3">inventory_2</span> Asignar Stock
                </a>
            </li>
            <li>
                <a href="StockServlet?accion=historial" class="nav-link active d-flex align-items-center">
                    <span class="material-icons me-3">history</span> Reportes
                </a>
            </li>
        </ul>
    </div>

    <div class="content-area p-4">
        <div class="container-fluid">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-1">Historial Global de Movimientos</h2>
                    <p class="text-muted mb-0">Kardex centralizado de entradas y salidas de almacén</p>
                </div>
                <div class="d-flex gap-2">
                    <a href="StockServlet?accion=exportarPDF" class="btn btn-danger d-flex align-items-center">
                        <span class="material-icons me-1">picture_as_pdf</span> PDF
                    </a>
                    <a href="StockServlet?accion=exportarCSV" class="btn btn-success d-flex align-items-center">
                        <span class="material-icons me-1">table_view</span> CSV
                    </a>
                    <a href="StockServlet" class="btn btn-primary d-flex align-items-center">
                        <span class="material-icons me-1">playlist_add</span> Registrar Nueva Entrada
                    </a>
                </div>
            </div>

            <div class="card shadow-sm border-0 mb-4">
                <div class="card-body bg-white py-3">
                    <div class="row align-items-center">
                        <div class="col-md-4">
                            <label for="filtroTipo" class="form-label fw-bold text-secondary mb-1">Filtrar por Tipo de Movimiento</label>
                            <select id="filtroTipo" class="form-select" onchange="filtrarTabla()">
                                <option value="TODOS">Mostrar todos los movimientos</option>
                                <option value="ENTRADA">Solo Entradas (Abastecimiento)</option>
                                <option value="SALIDA">Solo Salidas (Ventas / Consumos)</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card shadow-sm border-0">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0" id="tablaMovimientos">
                            <thead class="table-dark">
                                <tr>
                                    <th class="ps-3">Tipo</th>
                                    <th>Producto</th>
                                    <th>Origen / Destino</th>
                                    <th>Cantidad</th>
                                    <th class="pe-4">Fecha y Hora</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty historial}">
                                        <tr>
                                            <td colspan="5" class="text-center py-4 text-muted">
                                                No se han registrado movimientos de inventario aún.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${historial}" var="mov">
                                            <c:set var="esSalida" value="${mov.cantidad < 0}" />
                                            
                                            <tr data-tipo="${esSalida ? 'SALIDA' : 'ENTRADA'}">
                                                <td class="ps-3">
                                                    <c:choose>
                                                        <c:when test="${esSalida}">
                                                            <span class="badge bg-danger d-inline-flex align-items-center px-2 py-1">
                                                                <span class="material-icons fs-6 me-1">trending_down</span> Salida
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-success d-inline-flex align-items-center px-2 py-1">
                                                                <span class="material-icons fs-6 me-1">trending_up</span> Entrada
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="fw-bold">${mov.productoNombre}</td>
                                                <td>
												    <c:choose>
												        <c:when test="${esSalida}">
												            <span class="text-muted fst-italic">Cliente / Venta Interna</span>
												        </c:when>
												        <c:otherwise>
												            <span class="text-dark fw-semibold">${mov.proveedorNombre}</span>
												        </c:otherwise>
												    </c:choose>
												</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${esSalida}">
                                                            <span class="text-danger fw-bold">${mov.cantidad} u.</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-success fw-bold">+${mov.cantidad} u.</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="pe-4 text-muted">
                                                    <fmt:formatDate value="${mov.fechaMovimiento}" pattern="dd/MM/yyyy hh:mm a" />
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function filtrarTabla() {
            const seleccion = document.getElementById("filtroTipo").value;
            const filas = document.querySelectorAll("#tablaMovimientos tbody tr");

            filas.forEach(fila => {
                // Ignorar la fila que indica que la tabla está vacía si existiera
                if(!fila.hasAttribute("data-tipo")) return;

                const tipoFila = fila.getAttribute("data-tipo");

                if (seleccion === "TODOS" || tipoFila === seleccion) {
                    fila.style.display = ""; // Muestra la fila
                } else {
                    fila.style.display = "none"; // Oculta la fila
                }
            });
        }
    </script>
</body>
</html>
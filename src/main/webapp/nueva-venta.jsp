<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>InventariosTEC | Punto de Venta</title>
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
        <h2 class="fw-bold mb-4">Registro de Salida (Punto de Venta)</h2>

        <c:if test="${param.msg == 'success'}">
            <div class="alert alert-success">Venta y salida de almacén registrada con éxito.</div>
        </c:if>

        <div class="row">
            <div class="col-md-4">
                <div class="card shadow-sm mb-3">
                    <div class="card-header bg-dark text-white">Seleccionar Artículo</div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label class="form-label">Producto (Stock disponible)</label>
							<select id="selectProducto" class="form-select" onchange="cargarPrecioAutomatico()">
							    <option value="" disabled selected>Elegir...</option>
							    <c:forEach items="${productos}" var="p">
							        <option value="${p.id}" data-nombre="${p.nombre}" data-stock="${p.stock}" data-precio="${p.precio}">
							            ${p.nombre} (Stock: ${p.stock})
							        </option>
							    </c:forEach>
							</select>
                        </div>
                        <div class="row mb-3">
                            <div class="col-6">
                                <label class="form-label">Cantidad</label>
                                <input type="number" id="inputCantidad" class="form-control" min="1" value="1">
                            </div>
                            <div class="col-6">
                                <label class="form-label">Precio Unit. ($)</label>
                                <input type="number" id="inputPrecio" class="form-control" min="0.1" step="0.01">
                            </div>
                        </div>
                        <button type="button" class="btn btn-outline-primary w-100" onclick="agregarAlCarrito()">
                            <span class="material-icons align-middle fs-6">add_shopping_cart</span> Agregar a la lista
                        </button>
                    </div>
                </div>
            </div>

            <div class="col-md-8">
                <div class="card shadow-sm border-0">
                    <div class="card-body">
                        <form action="VentaServlet" method="post" id="formVenta">
                            
                            <div class="mb-3">
                                <label class="form-label fw-bold">Nombre del Cliente / Motivo de salida</label>
                                <input type="text" name="cliente" class="form-control" placeholder="Ej. Público General o Consumo Interno">
                            </div>

                            <table class="table table-bordered mt-3" id="tablaCarrito">
                                <thead class="table-light">
                                    <tr>
                                        <th>Producto</th>
                                        <th>Cant.</th>
                                        <th>Precio U.</th>
                                        <th>Subtotal</th>
                                        <th>Acción</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    </tbody>
                            </table>

                            <div class="d-flex justify-content-end mb-3">
                                <h4>Total: $<span id="lblTotal">0.00</span></h4>
                                <input type="hidden" name="totalVenta" id="inputTotal" value="0.00">
                            </div>

                            <button type="submit" class="btn btn-success w-100 fs-5" id="btnCobrar" disabled>
                                Confirmar Salida y Actualizar Stock
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        let total = 0;

        function agregarAlCarrito() {
            const select = document.getElementById("selectProducto");
            const cantidad = parseInt(document.getElementById("inputCantidad").value);
            const precio = parseFloat(document.getElementById("inputPrecio").value);
            
            if(select.value === "" || isNaN(cantidad) || isNaN(precio) || cantidad <= 0 || precio <= 0) {
                alert("Por favor completa los datos correctamente.");
                return;
            }

            const opcionSeleccionada = select.options[select.selectedIndex];
            const id = opcionSeleccionada.value;
            const nombre = opcionSeleccionada.getAttribute("data-nombre");
            const stockActual = parseInt(opcionSeleccionada.getAttribute("data-stock"));

            if (cantidad > stockActual) {
                alert("Stock insuficiente. Solo tienes " + stockActual + " unidades de " + nombre);
                return;
            }

            const subtotal = cantidad * precio;
            total += subtotal;

            // Inyectar HTML en la tabla (Incluye los inputs HIDDEN que leerá el Servlet)
            const tbody = document.querySelector("#tablaCarrito tbody");
            const tr = document.createElement("tr");
            tr.innerHTML = `
                <td>
                    \${nombre}
                    <input type="hidden" name="item_id" value="\${id}">
                </td>
                <td>
                    \${cantidad}
                    <input type="hidden" name="item_cantidad" value="\${cantidad}">
                </td>
                <td>$\${precio.toFixed(2)}</td>
                <td>
                    $\${subtotal.toFixed(2)}
                    <input type="hidden" name="item_subtotal" value="\${subtotal.toFixed(2)}">
                </td>
                <td>
                    <button type="button" class="btn btn-sm btn-danger" onclick="eliminarFila(this, \${subtotal})">X</button>
                </td>
            `;
            tbody.appendChild(tr);

            actualizarTotal();
            
            // Limpiar campos
            document.getElementById("inputCantidad").value = "1";
            document.getElementById("inputPrecio").value = "";
            select.value = "";
        }

        function eliminarFila(btn, subtotalFila) {
            total -= subtotalFila;
            btn.closest("tr").remove();
            actualizarTotal();
        }

        function actualizarTotal() {
            document.getElementById("lblTotal").innerText = total.toFixed(2);
            document.getElementById("inputTotal").value = total.toFixed(2);
            
            // Habilitar o deshabilitar botón de cobrar
            document.getElementById("btnCobrar").disabled = (total <= 0);
        }
        function cargarPrecioAutomatico() {
            const select = document.getElementById("selectProducto");
            const inputPrecio = document.getElementById("inputPrecio");
            
            // Si no hay ningún producto seleccionado realmente, limpiamos el campo
            if (select.value === "") {
                inputPrecio.value = "";
                return;
            }

            // Obtener la opción que el usuario acaba de clickear
            const opcionSeleccionada = select.options[select.selectedIndex];
            
            // Extraer el precio guardado en el atributo personalizado
            const precioRegistrado = opcionSeleccionada.getAttribute("data-precio");

            if (precioRegistrado) {
                // Convertimos a flotante y lo asignamos al input con 2 decimales
                inputPrecio.value = parseFloat(precioRegistrado).toFixed(2);
            } else {
                // En caso de que el producto no tenga precio registrado en la BD
                inputPrecio.value = "";
            }
        }
    </script>
</body>
</html>
# InventariosTEC 

Sistema web de gestión, control de inventarios, asignación de stock y registro contable de salidas o ventas de mercancía.

## Tecnologías Utilizadas

* **Lenguaje:** Java (JDK 21)
* **Tecnología Web:** Jakarta EE (Servlets y JSP)
* **Base de Datos:** PostgreSQL
* **Servidor de Aplicaciones:** Apache Tomcat 10.1.55
* **Diseño Interfaz:** Bootstrap 5 & Material Icons
* **Persistencia:** JDBC nativo

## Características del sistema
* **Historial unificado:** Control en tiempo real de las transacciones hechas
* **Punto de venta integrado:** Carga automática de precios con opcion a editar
* **Reportes:** Posibilidad de descargar reportes en formatos PDF y CSV

## Instalación y Configuración Local

Sigue estos pasos para replicar el entorno de desarrollo en tu máquina local.

### Prerrequisitos
Asegúrate de tener instalado:
* Eclipse IDE (Enterprise Java and Web Developers edition)
* PostgreSQL (Versión 14 o superior)
* Apache Tomcat 10.x

### Librerías Requeridas

El proyecto incluye y requiere las siguientes dependencias físicas `.jar` dentro de la carpeta `src/main/webapp/WEB-INF/lib/`:

**`postgresql-42.7.2.jar`**: Driver oficial de JDBC para la conexión de la aplicación con la base de datos PostgreSQL.
**`openpdf-2.0.3.jar`**: Biblioteca para la generación dinámica de los reportes en formato PDF.
**`jakarta.servlet.jsp.jstl-3.0.1.jar` y `jakarta.servlet.jsp.jstl-api-3.0.0.jar`**: Implementación de JSTL (Jakarta Standard Tag Library) para permitir el uso de etiquetas dinámicas (`<c:forEach>`, `<c:if>`, etc.) en los archivos JSP sobre Tomcat

### Configuración de la Base de Datos
 Abre tu gestor de base de datos (pgAdmin o terminal) y crea una base de datos llamada `inventariostec`:
   ```sql
   CREATE DATABASE inventariostec;
  ```
Ejecuta el script de estructura inicial ubicado en la carpeta del proyecto (o utiliza las siguientes sentencias estructurales para el módulo transaccional):
Estructura de las tablas principales:
```sql
CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    stock INT DEFAULT 0,
    precio DECIMAL(10,2) NOT NULL
);

CREATE TABLE proveedores (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE historial_stock (
    id SERIAL PRIMARY KEY,
    producto_id INT REFERENCES productos(id),
    proveedor_id INT REFERENCES proveedores(id) ON DELETE SET NULL,
    cantidad INT NOT NULL,
    fecha_movimiento TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ventas (
    id SERIAL PRIMARY KEY,
    cliente_nombre VARCHAR(100) DEFAULT 'Público General',
    total DECIMAL(10,2) NOT NULL,
    fecha_venta TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE detalle_ventas (
    id SERIAL PRIMARY KEY,
    venta_id INT REFERENCES ventas(id) ON DELETE CASCADE,
    producto_id INT REFERENCES productos(id),
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL
);
```
### Conexión a bases de datos
Abre el archivo DBConnection.java ubicado en el paquete com.inventory.util y actualiza tus credenciales locales de PostgreSQL:

private static final String URL = "jdbc:postgresql://localhost:5432/inventariostec";
private static final String USER = "postgres";
private static final String PASSWORD = "admin";

### Despliegue desde eclipse
Abre Eclipse IDE.

1. Ve a File -> Import... -> Existing Projects into Workspace.

2. Selecciona la carpeta raíz de SistemaInventarios (o InventariosTEC) y finaliza.

3. Asegúrate de tener los drivers de conexión y las librerías JSTL dentro de la ruta src/main/webapp/WEB-INF/lib/.

4. Haz clic derecho sobre el proyecto -> Run As -> Run on Server.

5. Selecciona tu servidor Apache Tomcat 10.1.55 configurado y presiona Finish.

   

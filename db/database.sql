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
CREATE DATABASE BodegaTech_DB

-- ══════════════════════════════════════════
-- BodegaTech — Script de Inventario
-- Autor: Agustin Martinez
-- Fecha: 24/7/2026
-- ══════════════════════════════════════════

-- ── SECCIÓN DDL ──────────────────────────

DROP TABLE IF EXISTS inventario;

-- CREATE TABLE

CREATE TABLE inventario (
id_producto INT Primary Key,
nombre_producto VARCHAR(100) NOT NULL,
categoria VARCHAR(50) NOT NULL,
precio_unitario DECIMAL(10,2) NOT NULL,
stock_actual INT NOT NULL,
stock_minimo INT NOT NULL,
fecha_ingreso DATE NOT NULL,
activo TINYINT NOT NULL
);

-- ── SECCIÓN DML ──────────────────────────

-- INSERT INTO

INSERT INTO inventario
(id_producto, nombre_producto, categoria, precio_unitario, stock_actual, stock_minimo, fecha_ingreso, activo)
VALUES
(1, 'Laptop Pro 15', 'Computación', 1200.00, 15, 3, '2024-01-10', 1),
(2, 'Mouse Inalámbrico', 'Accesorios', 28.00, 80, 10, '2024-01-10', 1),
(3, 'Monitor 4K 27"', 'Computación', 450.00, 12, 2, '2024-01-15', 1),
(4, 'Teclado Mecánico', 'Accesorios', 95.00, 40, 5, '2024-01-15', 1),
(5, 'Laptop Basic 14', 'Computación', 650.00, 20, 3, '2024-02-01', 1),
(6, 'Auriculares BT Pro', 'Audio', 120.00, 35, 5, '2024-02-01', 1),
(7, 'Hub USB-C 7 puertos', 'Accesorios', 45.00, 60, 10, '2024-02-10', 1),
(8, 'Webcam HD 1080p', 'Accesorios', 85.00, 25, 5, '2024-02-10', 1),
(9, 'SSD Externo 1TB', 'Almacenamiento', 130.00, 18, 3, '2024-03-01', 1),
(10, 'Parlante Bluetooth', 'Audio', 60.00, 45, 8, '2024-03-01', 1);

-- UPDATE ventas del día

UPDATE inventario
SET stock_actual = stock_actual - 3
WHERE id_producto = 1;

UPDATE inventario
SET stock_actual = stock_actual - 12
WHERE id_producto = 2;

UPDATE inventario
SET stock_actual = stock_actual - 5
WHERE id_producto = 6;

-- UPDATE producto descontinuado

UPDATE inventario
SET activo = 0
WHERE id_producto = 8;

-- Ver la tabla completa para confirmar que los datos se cargaron

SELECT * FROM inventario;

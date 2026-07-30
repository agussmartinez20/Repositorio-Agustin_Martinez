
-- =====================================
-- PRE-ENTREGABLE MÓDULO 4
-- RETAILPRO
-- Alumno: Agustín Martínez
-- Fecha de entrega: 30/7/2026
-- =====================================

-- Consulta 1: Resumen ejecutivo mensual

SELECT
  MONTH(fecha_venta) AS mes,
  SUM(cantidad * precio_unitario) AS total_facturado,
  COUNT(*) AS cantidad_pedidos,
  AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- Consulta 2: Ranking de productos

SELECT TOP 5
id_producto,
  SUM(cantidad) AS unidades_vendidas,
  SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

-- Consulta 3: Clientes recurrentes

SELECT
  id_cliente,
  COUNT(*) AS cantidad_pedidos,
  SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

-- Consulta 4: Meses por encima o por debajo del promedio

WITH ventas_mensuales AS
(
SELECT
  MONTH(fecha_venta) AS mes,
  SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY MONTH(fecha_venta)
)

SELECT mes,total_facturado,
CASE
WHEN total_facturado >
  (SELECT AVG(total_facturado) 
  FROM ventas_mensuales) 
  THEN 'Por encima'
  ELSE 'Por debajo'
  END AS estado
FROM ventas_mensuales
ORDER BY mes;

-- ==================================
-- HALLAZGOS DEL ANÁLISIS
-- ==================================

-- 1. El producto con ID 3 fue el que mayor facturación generó.

-- 2. El mes de marzo quedó por debajo del promedio mensual.

-- 3. El cliente con ID 1 fue el que mas gastó

  
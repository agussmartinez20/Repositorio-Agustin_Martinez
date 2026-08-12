-- =====================================================
-- PRE-ENTREGA MÓDULO 5 - CONSULTAS CON JOINS
-- Proyecto: RetailPro
-- Alumno: Agustin Martinez
-- Fecha de entrega: 11/8/2026
-- =====================================================


-- =====================================================
-- 1. CREAR TABLA TERRITORIOS YA QUE NO EXISTE
-- =====================================================

IF OBJECT_ID('dbo.territorios', 'U') IS NULL
BEGIN
    CREATE TABLE territorios (
        id_territorio INT PRIMARY KEY,
        region VARCHAR(50) NOT NULL,
        pais VARCHAR(50) NOT NULL,
        zona VARCHAR(50) NOT NULL
    );
END;


-- =====================================================
-- 2. CARGAR TERRITORIOS SIN DUPLICAR
-- =====================================================

IF NOT EXISTS (
    SELECT 1 FROM territorios WHERE id_territorio = 1
)
BEGIN
    INSERT INTO territorios
    (id_territorio, region, pais, zona)
    VALUES
    (1, 'Buenos Aires', 'Argentina', 'Centro');
END;

IF NOT EXISTS (
    SELECT 1 FROM territorios WHERE id_territorio = 2
)
BEGIN
    INSERT INTO territorios
    (id_territorio, region, pais, zona)
    VALUES
    (2, 'Córdoba', 'Argentina', 'Centro');
END;

IF NOT EXISTS (
    SELECT 1 FROM territorios WHERE id_territorio = 3
)
BEGIN
    INSERT INTO territorios
    (id_territorio, region, pais, zona)
    VALUES
    (3, 'Santa Fe', 'Argentina', 'Litoral');
END;


-- =====================================================
-- 3. AGREGAR SEGMENTO A CLIENTES SI NO EXISTE
-- =====================================================

IF COL_LENGTH('dbo.clientes', 'segmento') IS NULL
BEGIN
    ALTER TABLE clientes
    ADD segmento VARCHAR(50);
END;


-- Completar solamente los clientes que todavía no tengan segmento

UPDATE clientes
SET segmento =
    CASE
        WHEN id_cliente IN (1, 2) THEN 'Minorista'
        WHEN id_cliente IN (3, 4) THEN 'PyME'
        ELSE 'Corporativo'
    END
WHERE segmento IS NULL;


-- =====================================================
-- 4. AGREGAR ID_TERRITORIO A VENTAS SI NO EXISTE
-- =====================================================

IF COL_LENGTH('dbo.ventas', 'id_territorio') IS NULL
BEGIN
    ALTER TABLE ventas
    ADD id_territorio INT;
END;


-- =====================================================
-- 5. AGREGAR CANAL A VENTAS SI NO EXISTE
-- =====================================================

IF COL_LENGTH('dbo.ventas', 'canal') IS NULL
BEGIN
    ALTER TABLE ventas
    ADD canal VARCHAR(20);
END;


-- =====================================================
-- 6. COMPLETAR TERRITORIOS DE LAS VENTAS
-- =====================================================

UPDATE ventas
SET id_territorio =
    CASE
        WHEN id_cliente IN (1, 4) THEN 1
        WHEN id_cliente IN (2, 5) THEN 2
        ELSE 3
    END
WHERE id_territorio IS NULL;


-- =====================================================
-- 7. COMPLETAR CANAL DE LAS VENTAS
-- =====================================================

UPDATE ventas
SET canal =
    CASE
        WHEN id_venta % 2 = 0 THEN 'Online'
        ELSE 'Presencial'
    END
WHERE canal IS NULL;


-- =====================================================
-- 8. CREAR CLAVE FORÁNEA HACIA TERRITORIOS
-- =====================================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_ventas_territorios'
      AND parent_object_id = OBJECT_ID('dbo.ventas')
)
BEGIN
    ALTER TABLE ventas
    ADD CONSTRAINT FK_ventas_territorios
    FOREIGN KEY (id_territorio)
    REFERENCES territorios(id_territorio);
END;


-- =====================================================
-- 9. VALIDAR LA ESTRUCTURA
-- =====================================================

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN
(
    'clientes',
    'productos',
    'categorias',
    'ventas',
    'territorios'
)
ORDER BY
    TABLE_NAME,
    ORDINAL_POSITION;


-- =====================================================
-- CONSULTA 1
-- VISTA BASE DEL PROYECTO
-- INNER JOIN
-- =====================================================

SELECT
    v.fecha_venta AS fecha,
    c.nombre AS nombre_cliente,
    c.segmento,
    t.region,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta,
    v.canal
FROM ventas AS v

INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente

INNER JOIN productos AS p
    ON v.id_producto = p.id_producto

INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria

INNER JOIN territorios AS t
    ON v.id_territorio = t.id_territorio;


-- =====================================================
-- CONSULTA 2
-- CLIENTES SIN COMPRAS
-- LEFT JOIN + IS NULL
-- =====================================================

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes AS c

LEFT JOIN ventas AS v
    ON c.id_cliente = v.id_cliente

WHERE v.id_venta IS NULL;


-- =====================================================
-- CONSULTA 3
-- PRODUCTOS SIN VENTAS
-- LEFT JOIN + IS NULL
-- =====================================================

SELECT
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos AS p

INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria

LEFT JOIN ventas AS v
    ON p.id_producto = v.id_producto

WHERE v.id_venta IS NULL;


-- =====================================================
-- CONSULTA 4
-- CONSOLIDADO POR CANAL
-- UNION ALL + GROUP BY
-- =====================================================

WITH ventas_por_canal AS
(
    SELECT
        'Online' AS canal,
        cantidad * precio_unitario AS total_venta
    FROM ventas
    WHERE canal = 'Online'

    UNION ALL

    SELECT
        'Presencial' AS canal,
        cantidad * precio_unitario AS total_venta
    FROM ventas
    WHERE canal = 'Presencial'
)

SELECT
    canal,
    SUM(total_venta) AS total_facturado
FROM ventas_por_canal
GROUP BY canal
ORDER BY canal;


-- =====================================================
-- FIN DEL SCRIPT
-- =====================================================
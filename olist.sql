/*Descague un dataset Kaggle que la reduje a 1000 registros*/
--DDL
-- creacion de la DB y latablas con los campos correspondientes
CREATE DATABASE Preentrega3_Olist;
GO
USE Preentrega3_Olist;
GO
-- TABLA PEDIDOS
CREATE TABLE pedidos (
    id_pedido VARCHAR(50) PRIMARY KEY,
    id_cliente VARCHAR(50) NOT NULL,
    estado_pedido VARCHAR(30) NOT NULL,
    fecha_compra DATETIME2 NOT NULL,
    fecha_aprobacion DATETIME2,
    fecha_entrega_transportista DATETIME2,
    fecha_entrega_cliente DATETIME2,
    fecha_estimada_entrega DATETIME2 NOT NULL
);
-- TABLA RESEÑAS
CREATE TABLE resenas (
    id_resena VARCHAR(50) NOT NULL,
    id_pedido VARCHAR(50) NOT NULL,
    puntuacion INT NOT NULL CHECK (puntuacion BETWEEN 1 AND 5),
    titulo_resena NVARCHAR(500),
    comentario_resena NVARCHAR(MAX),
    fecha_resena DATETIME2,
    fecha_respuesta DATETIME2,

    CONSTRAINT FK_resenas_pedidos
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
);

/*IMPORTE LOS DATOS DEL DATASET RESENAS.CSV Y OLIST_PEDIDOS_1000.CSV*/
-- VERIFICAR CANTIDAD DE PEDIDOS Y CANTIDAD DE RESENAS
SELECT COUNT(*) AS total_pedidos
FROM pedidos;

SELECT COUNT(*) AS total_resenas
FROM resenas;
--MUESTRA PRINT 1
-- HICE UN JOIN ENTRE AMBAS TABLAS 
SELECT
    p.id_pedido,
    p.estado_pedido,
    p.fecha_estimada_entrega,
    p.fecha_entrega_cliente,
    r.puntuacion
FROM pedidos p
INNER JOIN resenas r
    ON p.id_pedido = r.id_pedido;
-- DE ESTE MODO SE PODRIA ANALIZAR SI LAS ENTREGAS TARDIAS ESTAN RELACIONADAS A LAS MALAS RESENAS MUESTRO EN PRINT 2
--
--LUEGO ANALICE LAS ENTREGAS TARDIAS PRINT 3
SELECT
    p.id_pedido,
    p.fecha_estimada_entrega,
    p.fecha_entrega_cliente,
    r.puntuacion,
    CASE
        WHEN p.fecha_entrega_cliente > p.fecha_estimada_entrega
        THEN '%Entrega tardia%'
        ELSE '%Entrega a tiempo%'
    END AS estado_entrega
FROM pedidos p
INNER JOIN resenas r
    ON p.id_pedido = r.id_pedido
WHERE p.fecha_entrega_cliente IS NOT NULL;

--Y CONTE LAS MALAS RESENAS O RESENAS NEGATIVAS. MUESTRO EN PRINT 4
USE Preentrega3_Olist;

SELECT
    COUNT(*) AS total_resenas_negativas,

    SUM(CASE
        WHEN p.fecha_entrega_cliente > p.fecha_estimada_entrega
        THEN 1
        ELSE 0
    END) AS entregas_tardias,

    ROUND(
        100.0 * SUM(CASE
            WHEN p.fecha_entrega_cliente > p.fecha_estimada_entrega
            THEN 1
            ELSE 0
        END) / COUNT(*), 2
    ) AS porcentaje_entregas_tardias

FROM pedidos p
INNER JOIN resenas r
    ON p.id_pedido = r.id_pedido

WHERE r.puntuacion IN (1, 2) AND p.fecha_entrega_cliente IS NOT NULL;

--COMPARARE AMBAS. MUESTRO EN PRINT 5
SELECT
    CASE
        WHEN p.fecha_entrega_cliente > p.fecha_estimada_entrega
        THEN 'Entrega tardia'
        ELSE 'Entrega a tiempo'
    END AS estado_entrega,

    COUNT(*) AS total_resenas,

    SUM(CASE
        WHEN r.puntuacion IN (1, 2)
        THEN 1 ELSE 0
    END) AS resenas_negativas

FROM pedidos p
INNER JOIN resenas r
    ON p.id_pedido = r.id_pedido

WHERE p.fecha_entrega_cliente IS NOT NULL

GROUP BY
    CASE
        WHEN p.fecha_entrega_cliente > p.fecha_estimada_entrega
        THEN 'Entrega tardia'
        ELSE 'Entrega a tiempo'
    END;

--Y FINALMENTE CALCILE EL PORCENTAJE . PRINT 6

SELECT
    CASE
        WHEN p.fecha_entrega_cliente > p.fecha_estimada_entrega
        THEN 'Entrega tardia'
        ELSE 'Entrega a tiempo'
    END AS estado_entrega,

    COUNT(*) AS total_resenas,

    SUM(CASE
        WHEN r.puntuacion IN (1, 2)
        THEN 1 ELSE 0
    END) AS resenas_negativas,

    ROUND(
        100.0 * SUM(CASE
            WHEN r.puntuacion IN (1, 2)
            THEN 1 ELSE 0
        END) / COUNT(*), 2
    ) AS porcentaje_negativas

FROM pedidos p
INNER JOIN resenas r
    ON p.id_pedido = r.id_pedido

WHERE p.fecha_entrega_cliente IS NOT NULL

GROUP BY
    CASE
        WHEN p.fecha_entrega_cliente > p.fecha_estimada_entrega
        THEN 'Entrega tardia'
        ELSE 'Entrega a tiempo'
    END;

SELECT
    id_pedido,
    COUNT(*) AS cantidad_resenas
FROM resenas
GROUP BY id_pedido
HAVING COUNT(*) > 1;
SELECT
    id_pedido,
    id_resena,
    puntuacion,
    fecha_resena
FROM resenas
WHERE id_pedido IN (
    SELECT id_pedido
    FROM resenas
    GROUP BY id_pedido
    HAVING COUNT(*) > 1
)
ORDER BY id_pedido, fecha_resena;


WITH resenas_ordenadas AS (
    SELECT
        id_pedido,
        id_resena,
        puntuacion,
        fecha_resena,
        ROW_NUMBER() OVER (
            PARTITION BY id_pedido
            ORDER BY fecha_resena DESC, id_resena DESC
        ) AS numero
    FROM resenas
)
SELECT *
FROM resenas_ordenadas
WHERE numero = 1;
SELECT COUNT(DISTINCT id_pedido) AS total_pedidos_unicos
FROM resenas;
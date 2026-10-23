/*Corregi de resenas duplicadas

Encontre 5 pedidos que tenian dos resenas cada uno.
Para evitar contar dos veces el mismo pedido,
conserve la resena mas reciente segun la fecha.

Despues volvi a calcular los porcentajes para comparar
los resultados con el analisis original.
*/

-- Identifico los pedidos que tienen mas de una resena
-- RESULTADO: 5 pedidos con 2 resenas cada uno.

SELECT id_pedido,
    COUNT(*) AS cantidad_resenas
FROM resenas
GROUP BY id_pedido
HAVING COUNT(*) > 1;

-- REVISE LAS RESENIAS DE LOS PEDIDOS DUPLICADOS
-- COMPARE PUNTUACIONES Y FECHAS
SELECT id_pedido, id_resena, puntuacion, fecha_resena
FROM resenas
WHERE id_pedido IN (
    SELECT id_pedido
    FROM resenas
    GROUP BY id_pedido
    HAVING COUNT(*) > 1
)
ORDER BY id_pedido, fecha_resena;

-- IDENTIFICO LA FECHA MAS RECIENTE DE CADA PEDIDO DUPLICADO.
SELECT id_pedido,
    MAX(fecha_resena) AS ultima_fecha
FROM resenas
GROUP BY id_pedido
HAVING COUNT(*) > 1;

--VERIFIQUE SI HAY PEDIDOS CON RESENIAS EN LA MISMA FECHA
--LA CONSULTA NO DEVOLVIO RESULTADOS.
SELECT id_pedido,fecha_resena,
    COUNT(*) AS cantidad
FROM resenas
GROUP BY id_pedido, fecha_resena
HAVING COUNT(*) > 1;


--SELECCIONE LA RESENIA MAS RECIENTE DE CADA PEDIDO
--COMO RESULTADO OBTUVE 991 RESENIAS, UNA POR PEDIDO.
WITH ultimas_resenas AS (
    SELECT id_pedido,
        MAX(fecha_resena) AS ultima_fecha
    FROM resenas
    GROUP BY id_pedido
)
SELECT r.id_pedido, r.id_resena, r.puntuacion, r.fecha_resena
FROM resenas r
INNER JOIN ultimas_resenas u
    ON r.id_pedido = u.id_pedido
    AND r.fecha_resena = u.ultima_fecha;


--REVISE LOS PORCENTAJES DE RESENIAS NEGATIVAS.
--COMPARE LAS ENTREGAS TARDIAS CON LAS ENTREGAS A TIEMPO.
-- UTILICE SOLO LA RESENAS MSS RECIENTE DE CADA PEDIDO.

WITH ultimas_resenas AS (
    SELECT
        id_pedido,
        MAX(fecha_resena) AS ultima_fecha
    FROM resenas
    GROUP BY id_pedido
)
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
INNER JOIN ultimas_resenas u
    ON r.id_pedido = u.id_pedido
    AND r.fecha_resena = u.ultima_fecha

WHERE p.fecha_entrega_cliente IS NOT NULL

GROUP BY
    CASE
        WHEN p.fecha_entrega_cliente > p.fecha_estimada_entrega
        THEN 'Entrega tardia'
        ELSE 'Entrega a tiempo'
    END;
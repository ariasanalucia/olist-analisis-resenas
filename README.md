# olist-analisis-resenas
analisis de la relacion entre las demoras en las entregas y las resenas negativas de clientes de Olist.
---------------------------------------------------------
# Análisis de reseñas negativas y demoras en las entregas — Olist

## Descripción del proyecto

En este proyecto busqué analizar si los pedidos que llegan tarde tienen más reseñas negativas que los que llegan a tiempo.
Para hacerlo, trabajé con un dataset de Olist que contiene información sobre los pedidos, las fechas de entrega y las calificaciones de los clientes.
Mi objetivo fue ver si existe una relación entre las demoras y las malas reseñas, y cómo esta información podría servirle a la empresa para mejorar las entregas y la experiencia de sus clientes.

## Herramientas utilizadas

- **SQL Server:** para crear las tablas, cargar los datos y realizar las consultas.
- **Excel:** para crear el gráfico de barras con los resultados del análisis.
- **Canva:** para preparar la presentación de los resultados.
- **GitHub:** para guardar y compartir el proyecto.

## Metodología de trabajo

Para organizar el proyecto utilicé la metodología CRISP-DM.
- **Comprensión del negocio:** definí que quería analizar si las demoras en las entregas están relacionadas con las reseñas negativas.
- **Comprensión de los datos:** revisé las tablas de pedidos y reseñas del dataset de Olist.
- **Preparación de los datos:** cargué los archivos CSV en SQL Server y relacioné las tablas mediante el ID del pedido.
- **Análisis:** realicé consultas SQL para comparar los porcentajes de reseñas negativas entre las entregas tardías y las entregadas a tiempo.
- **Presentación de resultados:** hice un gráfico de barras en Excel y una presentación en Canva.

## Resultados del análisis

Al comparar las entregas tardías con las entregadas a tiempo, obtuve estos resultados:

- **Entregas a tiempo:** 11,16 % de reseñas negativas.
- **Entregas tardías:** 54,79 % de reseñas negativas.

También encontré que, de las 143 reseñas negativas, 40 correspondían a pedidos entregados tarde, es decir, un 27,97 %.

Con estos resultados pude observar que los pedidos que llegan tarde tienen una mayor proporción de reseñas negativas.

**Aclaración:** Los resultados son preliminares porque encontré 5 pedidos con reseñas duplicadas y todavía me falta ajustar ese detalle.

## Cómo reproducir el proyecto

Para realizar el análisis:

1. Descargue el dataset de Olist desde Kaggle.
2. Cree la base de datos y las tablas en SQL Server.
3. Cargue los archivos CSV de pedidos y reseñas.
4. Ejecute las consultas SQL para relacionar las tablas y calcular los porcentajes de reseñas negativas.
5. Utilice los resultados para crear un gráfico de barras en Excel.

Para este trabajo utilicé una muestra reducida de 1000 pedidos.

## Próximos pasos

Me gustaría continuar el proyecto realizando algunas mejoras:
- Calcular los días de demora de cada pedido.
- Analizar si las categorías de productos y los costos de envío también están relacionados con las reseñas negativas.
- Más adelante, evaluar la posibilidad de crear un modelo predictivo.

## Conclusión

Este proyecto me permitió practicar la creación de tablas, la carga de datos y las consultas en SQL Server.
También pude relacionar los resultados con un problema de negocio y representarlos en un gráfico para que sean más fáciles de interpretar.

Aunque todavía tengo algunas mejoras pendientes, pude realizar una primera comparación entre las demoras en las entregas y las calificaciones de los clientes.

----------------------------------------------------------------------------------------------------------------------------------------------------------------


Actualización — 23/10/2026

Corrección de resenas duplicadas
Después de recibir la devolución, retomé el análisis para corregir las resenas duplicadas.
Encontré 5 pedidos que tenían dos resenas cada uno. Para evitar contar dos veces el mismo pedido, decidí conservar la resena más reciente según la fecha.
Para hacerlo utilicé consultas SQL con GROUP BY, MAX(), WITH y JOIN, sin eliminar registros de la base de datos.
De esta manera, pasé de 996 reseñas a 991 reseñas, una por pedido.
Las consultas utilizadas quedaron guardadas en el archivo correccion_resenas.sql.

--Comparación de resultados
Después de realizar la corrección, volví a calcular los porcentajes y los comparé con los resultados originales.

Resultado                                   Antes   Después

Total de reseñas negativas                    143    141

Resenias neg. de entregas tardías              40     40

% reseñas neg.entregas a tiempo             11,16%  11,00%

% reseñas neg. entregas tardías             54,79%  54,79%

% de todas las reseñas neg. que 
corresponde a entregas tardías              27,97%  28,37%

--Interpretación de los resultados
Los resultados muestran dos datos diferentes:
54,79 %: de las resenas correspondientes a entregas tardías, ese porcentaje fue negativo.
28,37 %: del total de resenas negativas, ese porcentaje correspondió a entregas tardías.
Después de corregir los duplicados, los porcentajes cambiaron muy poco.

**Conclusión actualizada
La corrección de las resenas duplicadas me permitió mejorar la calidad de los datos y comprobar que los resultados originales eran consistentes.
La conclusión principal se mantiene: las entregas tardías tienen una mayor proporción de resenas negativas que las entregas a tiempo.
A partir de estos resultados, recomendaría que la empresa preste más atención a los pedidos con riesgo de demora y mejore la comunicación con los clientes para evitar posibles reclamos.
Este análisis muestra una relación entre las demoras y las reseñas negativas, aunque no permite afirmar que las demoras sean la única causa de las malas calificaciones.

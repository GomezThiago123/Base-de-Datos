/*Thiago David Gomez Ovelar 5ºB
1)Título de la película,
 dirección, ciudad y país del local 
 del nombre de una película a elección.
*/
SELECT 
    f.title AS titulo_pelicula,
    a.address AS direccion,
    c.city AS ciudad,
    co.country AS pais
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN store s ON i.store_id = s.store_id
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id
WHERE f.title = 'ACADEMY DINOSAUR';
/*
2) Mostrar título, categoría, 
idioma, rating y duración de las películas 
que estén entre 1 hs y 2 hs.
*/ 
 SELECT 
    f.title AS titulo,
    c.name AS categoria,
    l.name AS idioma,
    f.rating,
    f.length AS duracion_minutos
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN language l ON f.language_id = l.language_id
WHERE f.length BETWEEN 60 AND 120;
/*
3) Mostrar nombre, apellido y 
dirección (con ciudad y país) 
de los encargados del local.
*/ 
SELECT 
    s.first_name AS nombre,
    s.last_name AS apellido,
    a.address AS direccion,
    ci.city AS ciudad,
    co.country AS pais
FROM staff s
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;
/*
4) Mostrar el título, la fecha
 mínima y máxima de devolución 
 de una película.
*/ 
SELECT 
    f.title AS titulo,
    MIN(r.return_date) AS fecha_minima_devolucion,
    MAX(r.return_date) AS fecha_maxima_devolucion
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title;
/*
5)¿Se puede realizar una unión de todas las tablas? En caso de que se pueda
 realizar la sentencia que corresponde para unir las tablas. Seleccionando 
 los datos que ustedes consideren necesarios de cada tabla.
*/ 
SELECT 
    c.first_name || ' ' || c.last_name AS cliente,
    f.title AS pelicula,
    r.rental_date AS fecha_alquiler,
    r.return_date AS fecha_devolucion,
    s.first_name || ' ' || s.last_name AS encargado,
    st.store_id AS tienda,
    a.address AS direccion,
    ci.city AS ciudad,
    co.country AS pais
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN staff s ON r.staff_id = s.staff_id
JOIN store st ON s.store_id = st.store_id
JOIN address a ON st.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;
/*
6)¿Cuántas películas hay en cada tipo
 de "rating" (g, pg, pg13, r, nc17)
*/ 
SELECT 
    rating,
    COUNT(*) AS cantidad_peliculas
FROM film
GROUP BY rating;
/*
7)¿Cuántas películas hay
 en cada "categoría"?
*/ 
SELECT 
    c.name AS categoria,
    COUNT(fc.film_id) AS cantidad_peliculas
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name;
/*
8)Cuales son los 10 actores/actrices 
que más aparecen en las películas
*/ 
SELECT 
    a.first_name || ' ' || a.last_name AS actor,
    COUNT(fa.film_id) AS cantidad_peliculas
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY actor
ORDER BY cantidad_peliculas DESC
LIMIT 10;
/*
9)¿Cuántos ejemplares (inventory) en total hay en cada local? 
 Como no hay nombre del local, poner en su lugar la dirección incluyendo 
 ciudad y país además de la cantidad
*/ 
SELECT 
    a.address || ', ' || ci.city || ', ' || co.country AS direccion_local,
    COUNT(i.inventory_id) AS cantidad_ejemplares
FROM inventory i
JOIN store s ON i.store_id = s.store_id
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
GROUP BY direccion_local;
/*
10)¿Cuántas películas distintas hay en cada local? Como no hay 
nombre del local, poner en su lugar la dirección incluyendo ciudad
 y país además de la cantidad
*/ 
SELECT 
    a.address || ', ' || ci.city || ', ' || co.country AS direccion_local,
    COUNT(DISTINCT i.film_id) AS cantidad_peliculas_distintas
FROM inventory i
JOIN store s ON i.store_id = s.store_id
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
GROUP BY direccion_local;
/*
11)Calcular el costo de alquiler promedio
 de las película de cada categoría.
*/ 
SELECT 
    c.name AS categoria,
    ROUND(AVG(f.rental_rate), 2) AS costo_promedio_alquiler
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY costo_promedio_alquiler DESC;
/*
12)De la película “ALABAMA DEVIL” mostrar de cada alquiler: 
el costo total, los días, costo por día, el día que se alquiló y
 que día se devolvió ordenado por algún criterio a elección
*/ 
SELECT 
    r.rental_date AS fecha_alquiler,
    r.return_date AS fecha_devolucion,
    ROUND(julianday(r.return_date) - julianday(r.rental_date)) AS dias_alquiler,
    f.rental_rate AS costo_total,
    CASE 
        WHEN julianday(r.return_date) > julianday(r.rental_date)
        THEN ROUND(f.rental_rate / (julianday(r.return_date) - julianday(r.rental_date)), 2)
        ELSE f.rental_rate
    END AS costo_por_dia
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE f.title = 'ALABAMA DEVIL'
ORDER BY r.rental_date DESC;
/*
13)Nombre, duración y categoria de todas
 las peliculas ordenados del más largo al más corto.
*/ 
SELECT 
    f.title AS nombre_pelicula,
    f.length AS duracion_minutos,
    c.name AS categoria
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
ORDER BY f.length DESC;
/*
14)Nombre de las peliculas que arranquen
‘’w’’ con al menos 5 actores.
*/ 
SELECT 
    c.first_name AS nombre,
    c.last_name AS apellido,
    ROUND(SUM(p.amount), 2) AS total_pagado
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_pagado DESC;

/*
15)Calcular la suma total de los pagos (amount) 
con nombre y apellido de cada cliente.
*/
SELECT 
    c.first_name AS nombre,
    c.last_name AS apellido,
    SUM(p.amount) AS total_pagado
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_pagado DESC;


/*
16)Nombre de la pelicula, duración y nombre 
del actor de las peliculas más cortas.
*/ 
SELECT 
    f.title AS nombre_pelicula,
    f.length AS duracion_minutos,
    CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE f.length = (SELECT MIN(length) FROM film)
ORDER BY nombre_pelicula, nombre_actor;
/*
17)apellido del cliente con su ciudad, pais, direccion, 
sus alquileres y pagos, ordenado los pagos de menor a mayor.
*/
SELECT 
    c.last_name AS apellido_cliente,
    a.address AS direccion,
    ci.city AS ciudad,
    co.country AS pais,
    COUNT(DISTINCT r.rental_id) AS cantidad_alquileres,
    SUM(p.amount) AS total_pagado
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.last_name, a.address, ci.city, co.country
ORDER BY total_pagado ASC;

/*
18)Insertarse uno mismo como actor
 con todos sus campos.
*/
INSERT INTO actor (actor_id, first_name, last_name, last_update)
VALUES (201, 'THIAGO', 'GOMEZ', DATETIME('now'));
/*
19)Insertar 2 amigos o nombres que consideren.
*/
INSERT INTO actor (actor_id, first_name, last_name, last_update)
VALUES 
(202, 'MIGUEL', 'DIAZ', DATETIME('now')),
(203, 'JOEL', 'CARI', DATETIME('now'));
/*
20)Modificar los 3 datos ingresados por
 datos nuevos o de gente famosa.
*/
UPDATE actor
SET first_name = 'RYAN', last_name = 'GOSLING', last_update = DATETIME('now')
WHERE actor_id = 201;

UPDATE actor
SET first_name = 'BRAD', last_name = 'PITT', last_update = DATETIME('now')
WHERE actor_id = 202;

UPDATE actor
SET first_name = 'ADAM', last_name = 'SANDLER', last_update = DATETIME('now')
WHERE actor_id = 203;
/*
21)Borrar todos los datos ingresados finalmente.
*/
DELETE FROM film_actor
WHERE actor_id IN (201, 202, 203);

DELETE FROM actor
WHERE actor_id IN (201, 202, 203);

SELECT * FROM actor WHERE actor_id IN (201, 202, 203);
/**
Consignas SAKILA: HECHO, COMPROBADO Y FINALIZADO
/
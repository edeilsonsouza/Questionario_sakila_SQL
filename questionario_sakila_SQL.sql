USE sakila;
SET SQL_SAFE_UPDATES = 0;

-- 1) Quais os paises cadastrados
SELECT country FROM country;

-- 2) Quantos países estão cadastrados?
SELECT COUNT(country) FROM country;  -- 109 paises.

-- 3) Quantos países que terminam com a letra "A" estão cadastrados?
SELECT COUNT(country) FROM country 
WHERE country LIKE '%A';  -- 40 paises. 

-- 4) Listar, sem repetição, os anos que houveram lançamento de filme.
SELECT DISTINCT release_year FROM film; -- Temos filmes lançados somente no ano de 2006.

-- 5) Alterar o ano de lançamento igual 2007 para filmes que iniciem com a Letra "B".
UPDATE film SET release_year = 2007 
WHERE title LIKE 'b%';

-- 6) Listar os filmes que possuem duração do filme maior que 100 e classificação igual a "G".
SELECT title FROM film 
WHERE length > 100 AND rating = "G";

-- 7) Alterar o ano de lançamento igual 2008 para filmes que possuem duração da locação menor que 4 e classificação igual a "PG".
UPDATE film SET release_year = 2008 
WHERE rental_duration < 4 AND rating = "PG";

-- 8) Listar a quantidade de filmes que estejam classificados como "PG-13" e preço da locação maior que 2.40.
SELECT count(*) FROM film 
WHERE rental_rate > 2.40 AND rating = "PG-13";

-- 9) Quais os idiomas que possuem filmes cadastrados?
SELECT DISTINCT name from film
INNER JOIN language ON film.language_id = language.language_id;

-- 10) Alterar o idioma para "GERMAN" dos filmes que possuem preço da locação maior que 4.

UPDATE film SET language_id = 6
WHERE rental_rate > 4;
-- Teste
SELECT name, rental_rate from film
INNER JOIN language ON language.language_id = film.language_id 
GROUP BY name, rental_rate;

-- 11) Alterar o idioma para "JAPANESE" dos filmes que possuem preço da locação igual 0.99.
SELECT * FROM language; -- JAPANESE --> language_id = 3
SELECT * FROM film;
UPDATE film SET language_id = 3 
WHERE rental_rate = 0.99;

-- 12) Listar a quantidade de filmes por classificação.
SELECT * FROM film;
SELECT rating, COUNT(rating) FROM film 
GROUP BY rating;

-- 13) Listar, sem repetição, os preços de locação dos filmes cadastrados.
SELECT * FROM film;
SELECT DISTINCT rental_rate FROM film;
-- OU --
SELECT rental_rate FROM film 
GROUP BY rental_rate;

-- 14) Listar a quantidade de filmes por preço da locação.
SELECT rental_rate, COUNT(rental_rate) FROM film GROUP
BY rental_rate;

-- 15) Listar os precos da locação que possuam mais de 340 filmes.
SELECT rental_rate, COUNT(rental_rate) FROM film
GROUP BY rental_rate 
HAVING COUNT(rental_rate) > 340;

-- 16) Listar a quantidade de atores por filme ordenando por quantidade de atores crescente.
SELECT film_id, COUNT(actor_id) FROM film_actor
GROUP BY film_id 
ORDER BY COUNT(actor_id) ASC;

-- 17) Listar a quantidade de atores para os filmes que possuem mais de 5 atores ordenando por quantidade de atores decrescente.
SELECT film_id, COUNT(actor_id) FROM film_actor
GROUP BY film_id
HAVING COUNT(actor_id) > 5 
ORDER BY COUNT(actor_id) DESC;

-- 18) Listar o título e a quantidade de atores para os filmes que possuem o idioma "ENGLISH" e 
-- mais de 10 atores ordenando por ordem alfabética de título e ordem crescente de quantidade de atores.
SELECT title, COUNT(actor_id) FROM film 
INNER JOIN film_actor 
ON film.film_id = film_actor.film_id
WHERE language_id = 1
GROUP BY title
HAVING COUNT(actor_id) > 10
ORDER BY COUNT(actor_id), title ASC; 

-- 19) Qual a maior duração da locação dentre os filmes?
SELECT MAX(rental_duration) FROM film;

-- 20) Quantos filmes possuem a maior duração de locação?
SELECT count(rental_duration) FROM film
WHERE rental_duration = (SELECT MAX(rental_duration) FROM film); -- 191 filmes

-- 21) Quantos filmes do idioma "JAPANESE" ou "GERMAN" possuem a maior duração de locação?
SELECT * FROM language; -- 3 - japanese | 6 - german
SELECT count(rental_duration) FROM film
WHERE rental_duration = (SELECT MAX(rental_duration) FROM film)
AND (language_id = 3 OR language_id = 6);  -- 121 filmes

-- 22) Qual a quantidade de filmes por classificação e preço da locação?
SELECT rating, rental_rate, COUNT(*) FROM film
GROUP BY rating, rental_rate
ORDER BY rating, rental_rate ASC;

-- 23) Qual o maior tempo de duração de filme por categoria?
SELECT name, MAX(length) FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN film ON film_category.film_id = film.film_id
GROUP BY name;

-- 24) Listar a quantidade de filmes por categoria.
SELECT name, COUNT(*) FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN film ON film_category.film_id = film.film_id
GROUP BY name;

-- 25) Listar a quantidade de filmes classificados como "G" por categoria.
SELECT name, COUNT(*) FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN film ON film_category.film_id = film.film_id
WHERE rating = "G"
GROUP BY name;

-- 26) Listar a quantidade de filmes classificados como "G" OU "PG" por categoria.
SELECT name, COUNT(*) FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN film ON film_category.film_id = film.film_id
WHERE rating = "G" OR rating = "PG"
GROUP BY name;

-- 27) Listar a quantidade de filmes por categoria e classificação.
SELECT name, rating, COUNT(*) FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN film ON film_category.film_id = film.film_id
GROUP BY name, rating;

-- 28) Qual a quantidade de filmes por Ator ordenando decrescente por quantidade?
SELECT first_name, last_name, COUNT(film_id) FROM actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY first_name, last_name;

-- 29) Qual a quantidade de filmes por ano de lançamento ordenando por quantidade crescente?
SELECT release_year, COUNT(film_id) FROM film
GROUP BY release_year
ORDER BY COUNT(film_id);

-- 30) Listar os anos de lançamento que possuem mais de 400 filmes?
SELECT release_year, COUNT(film_id) > 400 FROM film;
-- GROUP BY release_year
-- ORDER BY COUNT(film_id);

-- 31) Listar os anos de lançamento dos filmes que possuem mais de 100 filmes
-- com preço da locação maior que a média do preço da locação dos filmes da categoria "Children"?
SELECT * FROM category;
SELECT release_year, COUNT(*) FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
WHERE rental_rate > 2.99 AND name = 'children'
GROUP BY release_year
HAVING COUNT(*) > 100;

-- 32) Quais as cidades e seu pais correspondente que pertencem a um país que inicie com a Letra “E”?
SELECT city, country FROM country
INNER JOIN city ON city.country_id = country.country_id
WHERE country LIKE "e%";

-- 33) Quais os países que possuem mais de 3 cidades que iniciam com a Letra “A”?
SELECT country FROM country
INNER JOIN city ON city.country_id = country.country_id
WHERE city LIKE "a%" 
GROUP BY country
HAVING COUNT(*) > 3; 

-- 34) Quais os países que possuem mais de 3 cidades que iniciam com a Letra “A” ou tenha "R" ordenando por quantidade crescente?
SELECT country FROM country
INNER JOIN city ON city.country_id = country.country_id
WHERE city LIKE "a%" OR city LIKE "%r%"
GROUP BY country
HAVING COUNT(*) > 3
ORDER BY country ASC; 

-- 35) Quais os clientes moram no país “United States”?
SELECT first_name, last_name FROM customer
INNER JOIN address ON customer.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id
WHERE country = 'United States'
ORDER BY first_name ASC, last_name ASC;

-- 36) Quantos clientes moram no país “Brazil”?
SELECT COUNT(*) FROM customer
INNER JOIN address ON customer.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id
WHERE country = 'Brazil';

-- 37) Qual a quantidade de clientes por pais
SELECT country, COUNT(*) FROM customer
INNER JOIN address ON customer.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id
GROUP BY country;

-- 38) Quais países possuem mais de 10 clientes?
SELECT country FROM customer
INNER JOIN address ON customer.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id
GROUP BY country
HAVING COUNT(country) > 10
ORDER BY country ASC;

-- 39) Qual a média de duração dos filmes por idioma?
SELECT name, AVG(length) FROM film
INNER JOIN language ON film.language_id = language.language_id
GROUP BY name;

-- 40) Qual a quantidade de atores que atuaram nos filmes do idioma “English”?
SELECT COUNT(actor_id) FROM film 
INNER JOIN film_actor ON film.film_id = film_actor.film_id
WHERE language_id = 1;

-- 41) Quais os atores do filme “BLANKET BEVERLY”?
SELECT first_name, last_name  FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
INNER JOIN actor ON film_actor.actor_id = actor.actor_id
WHERE title = 'BLANKET BEVERLY';

-- 42) Quais categorias possuem mais de 60 filmes cadastrados?
SELECT name from category
INNER JOIN film_category ON film_category.category_id = category.category_id
INNER JOIN film ON film.film_id = film_category.film_id
GROUP BY name
HAVING COUNT(title) > 60;

-- 43) Quais os filmes alugados (sem repetição) para clientes que moram na “Argentina”?
SELECT DISTINCT title FROM rental
INNER JOIN customer ON rental.customer_id = customer.customer_id
INNER JOIN address ON customer.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id
WHERE country = 'Argentina'
GROUP BY title;

-- 44) Qual a quantidade de filmes alugados por Clientes que moram na “Chile”?
SELECT COUNT(title) FROM rental
INNER JOIN customer ON rental.customer_id = customer.customer_id
INNER JOIN address ON customer.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id
WHERE country = 'Chile';

-- 45) Qual a quantidade de filmes alugados por funcionario?
SELECT staff_id, COUNT(title) FROM rental
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id
GROUP BY staff_id;

-- 46) Qual a quantidade de filmes alugados por funcionario para cada categoria?
SELECT name, staff_id, COUNT(title) FROM rental
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
GROUP BY name, staff_id;

-- 47) Quais Filmes possuem preço da Locação maior que a média de preço da locação?
SELECT title, rental_rate FROM film
GROUP BY title
HAVING rental_rate > (SELECT AVG(rental_rate) FROM film);

-- 48) Qual a soma da duração dos Filmes por categoria?
SELECT name, SUM(length) FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN film ON film_category.film_id = film.film_id
GROUP BY name;

-- 49) Qual a quantidade de filmes locados mês a mês por ano?
SELECT month(rental_date), year(rental_date), count(rental_id) FROM rental
group by MONTH(rental_date), year(rental_date);

-- 50) Qual o total pago por classificação de filmes alugados no ano de 2006?
SELECT SUM(amount) FROM payment
WHERE YEAR(payment_date) = 2006;

-- 51) Qual a média mensal do valor pago por filmes alugados no ano de 2005?
SELECT month(payment_date), count(rental_id), sum(amount), avg(amount) FROM payment
WHERE YEAR(payment_date) = 2005
GROUP BY month(payment_date);

-- 52) Qual o total pago por filme alugado no mês de Junho de 2006 por cliente?
SELECT SUM(amount) from payment
where year(payment_date) = 2006 AND month(payment_date) = 06
group by customer_id;





 














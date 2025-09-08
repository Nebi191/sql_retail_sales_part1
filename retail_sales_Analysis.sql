CREATE TABLE retail_sales
(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(25),
	quantity INT,
	price_per_unit NUMERIC(10,2),
	cogs NUMERIC(10,2),
	total_sale NUMERIC(10,2)
);

--1 '2022-11-05' tarihinde yapılan satışların tüm sütunlarını almak için bir SQL sorgusu yazın:
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

--2 Kasım-2022 ayında 'Giyim' kategorisine ait ve satılan miktarın 4'ten fazla olduğu tüm işlemleri almak için bir SQL sorgusu yazın:
SELECT * FROM retail_sales
WHERE category = 'Clothing'
AND 
TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND quantity >= 4;

--3 Her kategori için toplam satışları (total_sale) hesaplayan bir SQL sorgusu yazın.
SELECT 
	category,
	SUM(total_sale) AS total_sale,
	COUNT(*)  AS total_orders
FROM retail_sales
GROUP BY 1;

--4 'Güzellik' kategorisinden ürün satın alan müşterilerin ortalama yaşını bulmak için bir SQL sorgusu yazın.
SELECT
	ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';


--5 total_sale'in 1000'den büyük olduğu tüm işlemleri bulmak için bir SQL sorgusu yazın.
SELECT
	total_sale
FROM retail_sales
WHERE total_sale > 1000;

--6 Her cinsiyetin her kategoride yaptığı toplam işlem sayısını (transaction_id) bulmak için bir SQL sorgusu yazın.
SELECT
	gender,
	category,
	COUNT(DISTINCT transactions_id) AS total_transactions,
	SUM(quantity) AS total_quantity
	FROM retail_sales
	GROUP BY gender, category
	ORDER BY gender, category;



--7 Her ayın ortalama satışını hesaplamak için bir SQL sorgusu yazın. Her yılın en çok satan ayını bulun:

SELECT 
	year,
	month,
	avg_sale
FROM
(
SELECT
	EXTRACT(YEAR FROM sale_date) AS year,
	EXTRACT(MONTH FROM sale_date) AS month,
	AVG(total_sale) AS avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY 1, 2
) AS t1
WHERE rank = 1

--8 **Toplam satışları en yüksek olan ilk 5 müşteriyi bulmak için bir SQL sorgusu yazın**:
SELECT
	customer_id,
	total_sale,
	SUM(total_sale) AS total_sales
	
FROM retail_sales
GROUP BY customer_id, total_sale
HAVING COUNT(*) > 5
ORDER BY total_sales DESC
LIMIT 5;
	

	
--9 Her kategoriden ürün satın alan benzersiz müşteri sayısını bulmak için bir SQL sorgusu yazın.
SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category
ORDER BY unique_customers DESC;

-- 10 Her vardiyayı ve sipariş sayısını oluşturmak için bir SQL sorgusu yazın (Örnek Sabah <12, Öğleden Sonra 12 ile 17 Arası, Akşam >17):
WITH hourly_sale
AS
(
SELECT
	*,
CASE
	WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening' END as shift
FROM retail_sales
)
SELECT
	shift,
	COUNT(*) AS total_orders
	FROM hourly_sale
	GROUP BY shift
	
	






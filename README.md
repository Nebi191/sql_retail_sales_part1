# Perakende Satış Analizi SQL Projesi

## Projeye Genel Bakış

**Proje Başlığı**: Perakende Satış Analizi
**Seviye**: Başlangıç
**Veritabanı**: `p1_retail_db`

Bu proje, veri analistleri tarafından perakende satış verilerini incelemek, temizlemek ve analiz etmek için kullanılan SQL becerilerini ve tekniklerini göstermek üzere tasarlanmıştır. Proje, bir perakende satış veritabanı oluşturmayı, keşifsel veri analizi (EDA) gerçekleştirmeyi ve SQL sorguları aracılığıyla belirli iş sorularını yanıtlamayı içerir. Bu proje, veri analizi yolculuğuna yeni başlayan ve SQL'de sağlam bir temel oluşturmak isteyenler için idealdir.

## Hedefler

1. **Bir perakende satış veritabanı kurun**: Sağlanan satış verileriyle bir perakende satış veritabanı oluşturun ve doldurun.
2. **Veri Temizleme**: Eksik veya boş değer içeren kayıtları belirleyin ve kaldırın.
3. **Keşifsel Veri Analizi (EDA)**: Veri kümesini anlamak için temel keşifsel veri analizi gerçekleştirin. 4. **İş Analizi**: Belirli iş sorularını yanıtlamak ve satış verilerinden içgörüler elde etmek için SQL kullanın.

## Proje Yapısı

### 1. Veritabanı Kurulumu

- **Veritabanı Oluşturma**: Proje, `p1_retail_db` adlı bir veritabanı oluşturarak başlar.
- **Tablo Oluşturma**: Satış verilerini depolamak için `retail_sales` adlı bir tablo oluşturulur. Tablo yapısı, işlem kimliği, satış tarihi, satış saati, müşteri kimliği, cinsiyet, yaş, ürün kategorisi, satılan miktar, birim fiyat, satılan malın maliyeti (COGS) ve toplam satış tutarı sütunlarını içerir.

```sql
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Veri Araştırması ve Temizleme

- **Kayıt Sayısı**: Veri kümesindeki toplam kayıt sayısını belirleyin.
- **Müşteri Sayısı**: Veri kümesinde kaç benzersiz müşteri olduğunu öğrenin.
- **Kategori Sayısı**: Veri kümesindeki tüm benzersiz ürün kategorilerini belirleyin.
- **Boş Değer Kontrolü**: Veri kümesinde boş değer olup olmadığını kontrol edin ve eksik veri içeren kayıtları silin.
```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```



Aşağıdaki SQL sorguları belirli iş sorularını yanıtlamak için geliştirilmiştir:

1. **'2022-11-05' tarihinde yapılan satışların tüm sütunlarını almak için bir SQL sorgusu yazın**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Kasım-2022 ayında 'Giyim' kategorisine ait ve satılan miktarın 4'ten fazla olduğu tüm işlemleri almak için bir SQL sorgusu yazın**:
```sql
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4
```

3. **Her kategori için toplam satışları (total_sale) hesaplayan bir SQL sorgusu yazın.**:
```sql
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1
```

4. **'Beauty' kategorisinden ürün satın alan müşterilerin ortalama yaşını bulmak için bir SQL sorgusu yazın.**:
```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
```

5. **total_sale'in 1000'den büyük olduğu tüm işlemleri bulmak için bir SQL sorgusu yazın.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000
```

6. **Her cinsiyetin her kategoride yaptığı toplam işlem sayısını (transaction_id) bulmak için bir SQL sorgusu yazın.**:
```sql
SELECT
	gender,
	category,
	COUNT(DISTINCT transactions_id) AS total_transactions,
	SUM(quantity) AS total_quantity
	FROM retail_sales
	GROUP BY gender, category
	ORDER BY gender, category;

```

7. **Her ayın ortalama satışını hesaplamak için bir SQL sorgusu yazın. Her yılın en çok satan ayını bulun:**:
```sql
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1
```

8. **Toplam satışları en yüksek olan ilk 5 müşteriyi bulmak için bir SQL sorgusu yazın **:
```sql
SELECT
	customer_id,
	total_sale,
	SUM(total_sale) AS total_sales
	
FROM retail_sales
GROUP BY customer_id, total_sale
HAVING COUNT(*) > 5
ORDER BY total_sales DESC
LIMIT 5;
```

9. **Her kategoriden ürün satın alan benzersiz müşteri sayısını bulmak için bir SQL sorgusu yazın.**:
```sql
SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category
ORDER BY unique_customers DESC;
```

10. **10 Her vardiyayı ve sipariş sayısını oluşturmak için bir SQL sorgusu yazın (Örnek Sabah <12, Öğleden Sonra 12 ile 17 Arası, Akşam >17)**:
```sql
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
```








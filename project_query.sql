SELECT * FROM walmart;
SELECT count(*) FROM walmart;


-- Business Problems

--Q.1 Find different payment method and number of transactions, number of qty sold
SELECT
	 payment_method,
	 COUNT(*) as no_payments,
	 SUM(quantity) as no_qty_sold
FROM walmart
GROUP BY payment_method;



 -- Q.2
 -- Identify the highest-rated category in each branch, displaying the branch, category
 -- AVG RATING
SELECT *
FROM
(
SELECT
    branch,
    category,
    AVG(rating) as avg_rating,
    RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) as rank
    FROM walmart
    GROUP BY branch, category

    )
WHERE rank=1;



-- Q.3 Identify the busiest day for each branch based on the number of transactions
SELECT *
FROM
	(SELECT
		branch,
		TO_CHAR(date, 'Day') AS day_name,
		COUNT(*) as no_transactions,
		RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) as rank
	FROM walmart
	GROUP BY 1, 2
	)
WHERE rank = 1;



-- Q. 4
-- Calculate the total quantity of items sold per payment method. List payment_method and total_quantity.
SELECT
       payment_method,
       SUM(quantity)
FROM walmart
GROUP BY payment_method;



-- Q.5
-- Determine the average, minimum, and maximum rating of category for each city.
-- List the city, average_rating, min_rating, and max_rating.
SELECT
       city ,
       category,
       AVG(rating) as avg_rating,
       MAX(rating) as max_rating,
       MIN(rating) as min_rating
FROM walmart
GROUP BY city , category;



-- Q.6
-- Calculate the total profit for each category by considering total_profit as
-- (unit_price * quantity * profit_margin).
-- List category and total_profit, ordered from highest to lowest profit.

SELECT
       category,
       SUM(unit_price * quantity * profit_margin) as total_profit
FROM walmart
GROUP BY category
ORDER BY total_profit DESC;



-- Q.7
-- Determine the most common payment method for each Branch.
-- Display Branch and the preferred_payment_method.
SELECT *
FROM (
    SELECT
        branch,
        payment_method,
        COUNT(*) AS total_trans,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank
    FROM walmart
    GROUP BY branch, payment_method
) AS ranked_payments
WHERE rank = 1;



-- Q.8
-- Categorize sales into 3 group MORNING, AFTERNOON, EVENING
-- Find out each of the shift and number of invoices
SELECT
	branch,
CASE
		WHEN EXTRACT(HOUR FROM(time::time)) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM(time::time)) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END day_time,
	COUNT(*)
FROM walmart
GROUP BY 1, 2
ORDER BY 1, 3 DESC;
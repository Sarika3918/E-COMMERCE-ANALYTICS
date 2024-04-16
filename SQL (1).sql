USE olist_store_analysis;


/* KPI 1 */
# Weekday vs Weekend (order_purchase_timestamp) payment Statistics


SELECT 
	CASE WHEN DAYOFWEEK(STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d')) 
    IN (1, 7) THEN 'Weekend' ELSE 'Weekday' END AS DayType,
    COUNT(DISTINCT o.order_id) AS TotalOrders,
    round(SUM(p.payment_value)) AS TotalPayments,
    round(AVG(p.payment_value)) AS AveragePayment
FROM
	orders_dataset o
JOIN
	payments_dataset p ON o.order_id = p.order_id
GROUP BY
	DayType;
    
    
# 2nd KPI---
# Number or orders with a review score of 5 and payment type as credit card.alter


SELECT 
	COUNT(DISTINCT p.order_id) AS NumberOforders
FROM 
	payments_dataset p
JOIN
	reviews_dataset r ON p.Order_id = r.Order_id
WHERE
	r.Review_score = 5
    AND p.Payment_type = 'Credit_card';
    
# 3rd KPI---
# The Average number of days taken for order_delivered_customer_date for pet_shop

SELECT
	product_category_name,
    round(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp))) AS avg_delivery_time
FROM
	orders_dataset o
JOIN
	items_dataset i ON i.order_id = o.order_id
JOIN
	products_dataset p ON p.product_id=i.product_id
WHERE
	p.product_category_name = 'pet_shop'
    AND o.order_delivered_customer_date IS NOT NULL;
    
    
# 4th KPI---
# Average price and payment values from customers of Sao Paulo City

SELECT
	round(AVG(i.price)) AS average_price,
    round(AVG(p.payment_value)) AS average_payment
FROM
	customers_dataset c
JOIN
	orders_dataset o ON c.customer_id = o.customer_id
JOIN
	items_dataset i ON o.order_id = i.order_id
JOIN
	payments_dataset p ON o.order_id = p.order_id
WHERE
	c.customer_city = 'Sao Paulo';
    
    
# 5th KPI---
# Realtionship between shipping days (order_delivered_customer_date - order_purchase_timestamp) vs review scores


SELECT
	Review_score,
	round(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)),0) AS "Avg Shipping Days"
FROM
	orders_dataset o 
JOIN
	reviews_dataset r ON o.order_id = r.order_id
WHERE
	order_delivered_customer_date IS NOT NULL
    AND order_purchase_timestamp IS NOT NULL
GROUP BY
	review_score
ORDER BY
	review_score;
    
    

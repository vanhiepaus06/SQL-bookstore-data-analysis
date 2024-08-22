/* Question 1: How many books have been ordered by each customer? 
Categorize the order volume of each customer as 'Low', 'Medium', and 'High' based on the number of N books ordered:
Low: N < 5 
Medium: 5 <= N <= 10
High: N > 10
*/

WITH CustomerOrders AS (
    SELECT customer_id, COUNT(book_id) AS BooksOrdered
    FROM cust_order co
    JOIN order_line ol ON co.order_id = ol.order_id
    GROUP BY customer_id
)
SELECT customer_id,
       BooksOrdered,
       CASE 
           WHEN BooksOrdered < 5 THEN 'Low'
           WHEN BooksOrdered BETWEEN 5 AND 10 THEN 'Medium'
		   -- WHEN BooksOrdered <= 10 THEN 'Medium'
           ELSE 'High'
       END AS OrderVolumeCategory
FROM CustomerOrders
ORDER BY customer_id;


/*
Question 2: What is the latest status of each order? 
(Rank the orders for each order_id based on status_date and create a view to store the latest orders status).
*/
CREATE VIEW [LastOrdersView] AS
SELECT
    RankedOrders.order_id,
    RankedOrders.status_date,
    RankedOrders.status_value
FROM
    (SELECT
         oh.order_id, 
         os.status_value,
         oh.status_date,
         RANK() OVER (PARTITION BY oh.order_id ORDER BY oh.status_date DESC) AS [LastOrderFilter]
     FROM 
         order_history oh
     INNER JOIN 
         order_status os ON oh.status_id = os.status_id
    ) AS RankedOrders
WHERE
    RankedOrders.LastOrderFilter = 1;


select * from [LastOrdersView]


/* 
Question 3: Rank the customers based on the total price of their orders. 
Note: Only count the orders whose latest status is not 'Cancelled' or 'Returned'.
*/

WITH TotalSpending AS (
    SELECT customer_id, SUM(price) AS TotalSpent
    FROM cust_order co
    JOIN order_line ol ON co.order_id = ol.order_id
	JOIN [LastOrdersView] l on l.order_id = co.order_id
	WHERE status_value not like 'Cancelled%' and status_value not like 'Returned%'
    GROUP BY customer_id 
	)


SELECT customer_id, TotalSpent,
       RANK() OVER(ORDER BY TotalSpent DESC) AS SpendingRank
FROM TotalSpending

/*
Question 4: Rank the author by their popularity and categorize them as 'Bestseller', 'Popular', or 'Others' based on their rank R for the number of orders:
'Bestseller': R <= 5
'Popular': 5 < R <= 10
'Others': R > 10
Note: Only count the orders whose latest status is not 'Cancelled' or 'Returned'.
*/

SELECT a.author_name,
	   COUNT(l.order_id) Number_of_orders,
       RANK() OVER(ORDER BY COUNT(l.order_id) DESC) PopularityRank,
       CASE 
           WHEN RANK() OVER(ORDER BY COUNT(l.order_id) DESC) <= 5 THEN 'Bestseller'
           WHEN RANK() OVER(ORDER BY COUNT(l.order_id) DESC) <= 10 THEN 'Popular'
           ELSE 'Others'
       END Category
FROM order_line ol join book b on ol.book_id = b.book_id
join book_author ba on ba.book_id = b.book_id
join author a on a.author_id = ba.author_id
join cust_order co on co.order_id = ol.order_id 
join [LastOrdersView] l on l.order_id = co.order_id
WHERE status_value not like 'Cancelled%' and status_value not like 'Returned%'
GROUP BY a.author_name

/*
Question 5: For each shipping method, rank the countries by 
the number of orders and categorize the ranking of demand as 'High' (for top 10), 'Medium' (for top 11-20), or 'Low' (for the rest).
Note: Only count the orders whose latest status is not 'Cancelled' or 'Returned'.
*/

SELECT sm.method_name, co.country_name,
	   COUNT(o.order_id) Number_of_orders,
       RANK() OVER(PARTITION BY sm.method_name ORDER BY COUNT(o.order_id) DESC) AS CountryRank,
       CASE
           WHEN RANK() OVER(PARTITION BY sm.method_name ORDER BY COUNT(o.order_id) DESC) = 1 THEN 'High'
           WHEN RANK() OVER(PARTITION BY sm.method_name ORDER BY COUNT(o.order_id) DESC) <= 3 THEN 'Medium'
           ELSE 'Low'
       END AS DemandCategory
FROM shipping_method sm
JOIN cust_order o ON sm.method_id = o.shipping_method_id
JOIN address a ON o.dest_address_id = a.address_id
JOIN country co ON a.country_id = co.country_id
JOIN [LastOrdersView] l on l.order_id = o.order_id
WHERE status_value not like 'Cancelled%' and status_value not like 'Returned%'
GROUP BY sm.method_name, co.country_name;

/*
Question 6.1: Create a temporary table showing the number of books sold by each publisher for each month.
*/

SELECT 
    p.publisher_name,
    MONTH(co.order_date) AS SaleMonth,
    COUNT(ol.book_id) AS BooksSold
	INTO #BookSales
FROM cust_order co
JOIN order_line ol ON co.order_id = ol.order_id
JOIN book b ON ol.book_id = b.book_id
JOIN publisher p ON b.publisher_id = p.publisher_id
GROUP BY p.publisher_name, MONTH(co.order_date)

SELECT * FROM #BookSales

/*
Question 6.2: Pivot the temp table to show the number of books sold monthly by each publisher (Note: Show null values as "0").
*/

SELECT 
    publisher_name,
    isnull([1], 0) AS January,
    isnull([2], 0) AS February,
    isnull([3], 0) AS March,
    isnull([4], 0) AS April,
    isnull([5], 0) AS May,
    isnull([6], 0) AS June,
    isnull([7], 0) AS July,
    isnull([8], 0) AS August,
    isnull([9], 0) AS September,
    isnull([10], 0) AS October,
    isnull([11], 0) AS November,
    isnull([12], 0) AS December
FROM 
    #BookSales
PIVOT
(
    SUM(BooksSold)
    FOR SaleMonth IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
) AS MonthlySalesPivot;

/*
Question 7: How many orders have been placed by new vs. returning customers each year?
*/

WITH CustomerFirstOrderYear AS (
    SELECT
        customer_id,
        MIN(YEAR(order_date)) AS FirstOrderYear
    FROM cust_order
    GROUP BY customer_id
),
OrdersByYear AS (
    SELECT 
		customer_id,
        YEAR(order_date) AS OrderYear        
    FROM cust_order
)
SELECT
    o.OrderYear,
    COUNT(DISTINCT CASE WHEN o.OrderYear = c.FirstOrderYear THEN o.customer_id END) AS NewCustomers,
    COUNT(DISTINCT CASE WHEN o.OrderYear > c.FirstOrderYear THEN o.customer_id END) AS ReturningCustomers
FROM OrdersByYear o
JOIN CustomerFirstOrderYear c ON o.customer_id = c.customer_id
GROUP BY o.OrderYear
ORDER BY o.OrderYear;

/*
Question 8: What is the average delivery time for each shipping method?
*/

WITH DeliveryTimes AS (
    SELECT
        co.shipping_method_id,
        co.order_id,
        -- Calculate the delivery time as the difference between the order date and the latest status date marked as 'Delivered'
        DATEDIFF(day, MIN(co.order_date), MAX(oh.status_date)) AS DeliveryTime
    FROM cust_order co
    JOIN order_history oh ON co.order_id = oh.order_id
    JOIN order_status os ON oh.status_id = os.status_id
	WHERE status_value != 'Cancelled' or status_value != 'Returned'
    GROUP BY co.shipping_method_id, co.order_id
)
SELECT
    sm.method_name,
    ROUND(AVG(CONVERT(FLOAT, dt.DeliveryTime)), 2) AS AverageDeliveryTime
FROM DeliveryTimes dt
JOIN shipping_method sm ON dt.shipping_method_id = sm.method_id
GROUP BY sm.method_name
ORDER BY AverageDeliveryTime;


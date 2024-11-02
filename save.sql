-- 1. retrive the total no. of order placed --

select count(order_id) as total_orders from orders;


-- 2. Calculate the total revenue generated from pizza sales --

SELECT 
    ROUND(SUM((order_details.quantity) * (pizzas.price)),
            2) AS total_revenue
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;
    

-- 3. identify the highest price pizza. --

SELECT 
    pizza_types.name, pizzas.price AS maximum_pricePizza
FROM
    pizzas
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;


-- 4. Identify the most common pizza size --

SELECT 
    pizzas.size,
    COUNT(order_details.order_details_id) AS order_count
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC;


-- 5. List the top 5 most ordered pizzatype along with it's quantity --

select pizza_types.name , sum(order_details.quantity) as quantity
from pizzas join pizza_types join order_details 
on  pizza_types.pizza_type_id = pizzas.pizza_type_id and order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name 
order by quantity desc
limit 5;

-- 6. Join the nessary table to find the total quantity of each pizza catagory ordered. --
select pizza_types.category , sum(order_details.quantity) as quantity
from pizzas join pizza_types 
on  pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details 
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by quantity desc;

-- 7. Determine the distribtion of order by hours of the day. --
SELECT HOUR(order_time) AS hours, COUNT(order_id) as counts
FROM orders
GROUP BY hours
order by counts DESC;

-- 8. Join the nessary table to find the catagory wise distribution of pizza. --
SELECT pizza_types.category as category , count(pizza_types.name) as total
from pizza_types 
group by category
order by total DESC;

-- 9. Group the order by date and calculate the avrage number of pizza ordered per a day. --
SELECT round(AVG(order_sum),0) AS average_quantity
FROM (
    SELECT orders.order_date AS order_date, SUM(order_details.quantity) AS order_sum
    FROM orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date
) AS order_quantity;

-- 10. Determine the top 3 most ordered pizza based on the revenue. --
-- 1. retrive the total no. of order placed --

select count(order_id) as total_orders from orders;


-- 2. Calculate the total revenue generated from pizza sales --

SELECT 
    ROUND(SUM((order_details.quantity) * (pizzas.price)),
            2) AS total_revenue
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;
    

-- 3. identify the highest price pizza. --

SELECT 
    pizza_types.name, pizzas.price AS maximum_pricePizza
FROM
    pizzas
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;


-- 4. Identify the most common pizza size --

SELECT 
    pizzas.size,
    COUNT(order_details.order_details_id) AS order_count
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC;


-- 5. List the top 5 most ordered pizzatype along with it's quantity --

select pizza_types.name , sum(order_details.quantity) as quantity
from pizzas join pizza_types join order_details 
on  pizza_types.pizza_type_id = pizzas.pizza_type_id and order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name 
order by quantity desc
limit 5;

-- 6. Join the nessary table to find the total quantity of each pizza catagory ordered. --
select pizza_types.category , sum(order_details.quantity) as quantity
from pizzas join pizza_types 
on  pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details 
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by quantity desc;

-- 7. Determine the distribtion of order by hours of the day. --
SELECT HOUR(order_time) AS hours, COUNT(order_id) as counts
FROM orders
GROUP BY hours
order by counts DESC;

-- 8. Join the nessary table to find the catagory wise distribution of pizza. --
SELECT pizza_types.category as category , count(pizza_types.name) as total
from pizza_types 
group by category
order by total DESC;

-- 9. Group the order by date and calculate the avrage number of pizza ordered per a day. --
SELECT round(AVG(order_sum),0) AS average_quantity
FROM (
    SELECT orders.order_date AS order_date, SUM(order_details.quantity) AS order_sum
    FROM orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date
) AS order_quantity;

-- 10. Determine the top 3 most ordered pizza based on the revenue. --
SELECT  pizza_types.name  ,  ROUND(SUM((order_details.quantity) * (pizzas.price)), 2) AS total_revenue
from pizza_types 
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.name
order by total_revenue desc
limit 3;

-- 11. calculate the contribution of each pizza type to total revenue. --

SELECT  pizza_types.category  ,  ROUND(SUM((order_details.quantity) * (pizzas.price)) /(SELECT 
    ROUND(SUM((order_details.quantity) * (pizzas.price)),
            2) AS total_revenue
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id) *100, 2) AS total_revenue
from pizza_types 
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.category
order by total_revenue desc; 

-- 12. analyse the cumulative revenue generated over time. --
SELECT 
    sales.order_date, 
    SUM(sales.total_revenue) OVER(ORDER BY sales.order_date) AS cumulative_revenue
FROM 
    (SELECT 
         orders.order_date, 
         ROUND(SUM(order_details.quantity * pizzas.price), 2) AS total_revenue
     FROM 
         orders
     JOIN 
         order_details ON orders.order_id = order_details.order_id
     JOIN 
         pizzas ON pizzas.pizza_id = order_details.pizza_id 
     GROUP BY 
         orders.order_date) AS sales;



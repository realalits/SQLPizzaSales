
create database PizzaSale;
use PizzaSale;
select name from sys.tables;
select * from pizzas;
select * from pizza_types;
select * from orders;
select * from order_details;

--Retrieve the total number of orders placed.

select count(*) as total_order from orders;

--Calculate the total revenue generated from pizza sales.

select 
round(sum(order_details.quantity * pizzas.price),2) as total_sale
from order_details join pizzas 
on pizzas.pizza_id = order_details.pizza_id;


--Identify the highest-priced pizza.
select  Top 5 pizza_types.name, round(pizzas.price,2)
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price  desc;


--Identify the most common pizza size ordered.

select 
pizzas.size, count(order_details.quantity) as total_pizzas
from pizzas join order_details 
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size;

--List the top 5 most ordered pizza types along with their quantities.

select pizza_types.name , sum(order_details.quantity)
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by sum(order_details.quantity) desc;







-----Intermediate:
--Join the necessary tables to find the total quantity of each pizza category 
--ordered.



select pizza_types.category,sum(order_details.quantity)
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on
order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category;


--Determine the distribution of orders by hour of the day.

select Datepart(hour,order_time) as orders_hour , count(order_id) as order_count  from orders
group by Datepart(hour,order_time) order by orders_hour;

--Join relevant tables to find the category-wise distribution of pizzas.


select category , count(name) from pizza_types group by category;

--Group the orders by date and calculate the average number of pizzas ordered per day.

-- to being sub querry

select avg(quantity ) from
(select o.order_date, sum(od.quantity) as quantity from orders as o
join order_details as od on 
o.order_id = od.order_id 
group by o.order_date  ) as order_quantity;


-- Determine the top 3 most ordered pizza types based on revenue.

select top 3 pizza_types.name , sum(order_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details 
on  order_details.pizza_id = pizzas.pizza_id
GROUP BY  pizza_types.name  ORDER BY revenue desc;


                                        -- Advanced:
-- Calculate the percentage contribution of each pizza type to total revenue.



select  pt.category ,sum(p.price * od.quantity) as revenue ,
ROUND(100.0 * sum(p.price * od.quantity) /
SUM(sum(p.price * od.quantity)) over (),2) 
as percentage 
from pizzas as p 
join pizza_types as pt 
on p.pizza_type_id = pt.pizza_type_id
join order_details as od
on od.pizza_id = p.pizza_id
GROUP BY   pt.category
ORDER BY revenue;

-- formula
-- (item revenue / total revenue) * 100

select * from pizzas;
select * from pizza_types;
select * from orders;
select * from order_details;

create database ecommerce

create table customer(
customer_id int primary key identity,
first_name varchar (300),
last_name varchar (300),
email varchar (300),
password varchar (300),
address varchar (800))

create table products(
product_id int primary key identity,
name varchar (300),
price money,
description varchar(600),
stockQuantity int)

create table cart(
cart_id int primary key identity,
customer_id int,
product_id int ,
quantity int,
constraint fk_cid foreign key (customer_id) references customer(customer_id),
constraint fk_pid foreign key (product_id) references products(product_id))

create table orders(
order_id int primary key identity,
customer_id int,
order_date date,
total_price money,
shipping_address varchar(800),
constraint fk_cuid foreign key (customer_id) references customer(customer_id))

create table order_items(
order_items_id int primary key identity,
order_id int,
product_id int,
quantity int,
item_amount money,
constraint fk_oid foreign key (order_id) references orders(order_id),
constraint fk_prid foreign key (product_id) references products(product_id))


insert into customer (first_name,last_name,email,password,address) values
('John','Doe','johndoe@example.com','jd123','123 Main St, City'),
('Jane','Smith','janesmith@example.com','js123','456 Elm St, Town'),
('Robert','Johnson','robert@example.com','rj123','789 Oak St, Village'),
('Sarah','Brown','sarah@example.com','sb123','101 Pine St, Suburb'),
('David','Lee','david@example.com','dl123','234 Cedar St, District'),
('Laura','Hall','laura@example.com','lh123','567 Birch St, County'),
('Michael','Davis','michael@example.com','md123','890 Maple St, State'),
('Emma','Willson','emma@example.com','ew123','321 Redwood St, Country'),
('William','Taylor','william@example.com','wt123','432 Spruce St, Province'),
('Olivia','Adams','olivia@example.com','oa123','765 Fir St, Territory')


insert into products (name,description,price,stockQuantity) values
('Laptop','High-performance laptop',800,10),
('SmartPhone','Latest smartphone',600,15),
('Tablet','Portable tablet',300,20),
('Headphones','Noise-canceling',150,30),
('TV','4K Smart TV',900,5),
('Coffee maker','Automatic coffee maker',50,25),
('refrigerator','Energy-efficient',700,10),
('Microwave Oven','Countertop microwave',80,15),
('Blender','High-speed blender',70,20),
('Vaccum cleaner','Bagless vacuum cleaner',120,10)


insert into cart(customer_id,product_id,quantity) values
(1,1,2),
(1,3,1),
(2,2,3),
(3,4,4),
(3,5,2),
(4,6,1),
(5,1,1),
(6,10,2),
(6,9,3),
(7,7,2)

insert into orders(customer_id,order_date,total_price,shipping_address) values
(1,'2023-01-05',1200,'123 ab street'),
(2,'2023-02-10',900,'23 sdc st'),
(3,'2023-03-15',300,'32 dsc st'),
(4,'2023-04-20',150,'54 bhg st'),
(5,'2023-05-25',1800,'23 qd st'),
(6,'2023-06-30',400,'34 ko st'),
(7,'2023-07-05',700,'23 ks st'),
(8,'2023-08-10',160,'95 dk st'),
(9,'2023-09-15',140,'92 pcst'),
(10,'2023-10-20',1400,'23 pl st')

insert into order_items(order_id,product_id,quantity,item_amount) values
(1,1,2,1600),
(1,3,1,300),
(2,2,3,1800),
(3,5,2,1800),
(4,4,4,600),
(4,6,1,50),
(5,1,1,800),
(5,2,2,1200),
(6,10,2,240),
(6,9,3,210)


--1. Update refrigerator product price to 800.
update products set price=800 where name='refrigerator'

--2. Remove all cart items for a specific customer.
delete cart where customer_id=4

--3. Retrieve Products Priced Below $100.
select * from products where price<100

--4. Find Products with Stock Quantity Greater Than 5.
select * from products where stockQuantity>5

--5. Retrieve Orders with Total Amount Between $500 and $1000.
select * from orders where total_price between 500 and 1000

--6. Find Products which name end with letter ‘r’.
select * from products where name like ('%r')

--7. Retrieve Cart Items for Customer 5.
select * from cart where customer_id=5

--8. Find Customers Who Placed Orders in 2023.
select c.first_name,c.last_name,o.order_date from customer c
join orders o on c.customer_id=o.customer_id
where year(o.order_date)=2023

--9. Determine the Minimum Stock Quantity for Each Product Category.
select name,stockQuantity from products

--10. Calculate the Total Amount Spent by Each Customer.
select c.first_name,c.last_name, o.total_price from customer c
join orders o on c.customer_id=o.customer_id

--11. Find the Average Order Amount for Each Customer.
select c.first_name, c.last_name, avg(o.total_price) as Average from customer c
join orders o on c.customer_id=o.customer_id
group by c.first_name,c.last_name,o.total_price

--12. Count the Number of Orders Placed by Each Customer.
select c.first_name,c.last_name, count(o.order_id) as count from customer c
join orders o on c.customer_id=o.customer_id
group by c.first_name,c.last_name,o.order_id

--13. Find the Maximum Order Amount for Each Customer.	
select c.first_name,c.last_name, max(o.total_price) as Maximum_amt from customer c
join orders o on c.customer_id=o.customer_id
group by c.first_name,c.last_name,o.total_price

--14. Get Customers Who Placed Orders Totaling Over $1000.
select c.first_name,c.last_name, o.total_price from customer c
join orders o on c.customer_id=o.customer_id
where o.total_price>1000

--15. Subquery to Find Products Not in the Cart.
select * from products
where product_id not in (select product_id from cart)

--16. Subquery to Find Customers Who Haven't Placed Orders.
select first_name,last_name from customer 
where customer_id not in (select customer_id from orders)

--17. Subquery to Calculate the Percentage of Total Revenue for a Product.
select product_id, name, (select sum(item_amount) from order_items where products.product_id=order_items.product_id)/(select sum(item_amount) from order_items)*100 as Total
from products

--18. Subquery to Find Products with Low Stock.
select name, stockQuantity from products
where product_id in (select product_id from products where stockQuantity<10)

--19. Subquery to Find Customers Who Placed High-Value Orders.
select first_name, last_name from customer
where customer_id in (select customer_id from orders where total_price>800)

select* from customer
select* from products
select* from orders
select* from order_items
select* from cart


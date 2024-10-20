----Created a new database and set it as the current database
Created database BikeStores;
---Created 2 Schemas: Production ,Sales
Create schema PRODUCTION;
Create schema SALES;

----Created a table stores
CREATE OR REPLACE TABLE sales.stores(
store_id INT PRIMARY KEY,
store_name VARCHAR(255) NOT NULL,
phone VARCHAR(25),
email VARCHAR (255),
street VARCHAR(255),
city VARCHAR(255),
state VARCHAR(10),
zip_code VARCHAR(5)
);

SELECT * FROM sales.stores;

----Created table Staffs
CREATE OR REPLACE TABLE sales.staffs(
staff_id INT PRIMARY KEY,

first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
email VARCHAR(255),
phone VARCHAR(25),
active tinyint NOT NULL,
store_id INT NOT NULL,
manager_id INT
);
SELECT * FROM sales.staffs;


----Created table categories
CREATE OR REPLACE TABLE production.categories(
category_id INT PRIMARY KEY,
category_name VARCHAR(255) NOT NULL
);

SELECT * FROM production.categories;

----Created table brands
CREATE OR REPLACE TABLE production.brands(
brand_id INT PRIMARY KEY,
brand_name varchar(255) NOT NULL
);
SELECT * FROM production.brands;


----Created table products
CREATE OR REPLACE TABLE production.products(
product_id INT PRIMARY KEY,
product_name VARCHAR(255) NOT NULL,

brand_id INT NOT NULL,
category_id INT NOT NULL,
model_year SMALLINT NOT NULL,
list_price DECIMAL(10,2) NOT NULL
);
SELECT * FROM production.products;


----Created table customers
CREATE OR REPLACE TABLE sales.customers(
customer_id INT PRIMARY KEY,
first_name VARCHAR(255),
last_name VARCHAR(255),
phone VARCHAR(25),
email VARCHAR(255) NOT NULL,
street VARCHAR(255),
city VARCHAR(50),
state VARCHAR(25),
zip_code VARCHAR(5)
);
SELECT * FROM sales.customers ;


----Created table orders
CREATE OR REPLACE TABLE sales.orders(
order_id INT PRIMARY KEY,
customer_id INT,
order_status tinyint NOT NULL,
order_date DATE NOT NULL,

required_date DATE NOT NULL,
shipped_date DATE,
store_id INT NOT NULL,
staff_id INT NOT NULL
);
SELECT * FROM sales.orders;

----Created table order_items
CREATE OR REPLACE TABLE sales.order_items(
order_id INT ,
item_id INT,
product_id INT NOT NULL,
quantity INT NOT NULL,
list_price DECIMAL(10,2) NOT NULL,
discount DECIMAL(4,2) NOT NULL DEFAULT 0,
PRIMARY KEY(order_id,item_id)
);
SELECT * FROM sales.order_items;


----Created table stocks
CREATE TABLE production.stocks (
store_id INT IDENTITY (1,1),
product_id INT,
quantity INT,
PRIMARY KEY (store_id, product_id)
);

SELECT * FROM production.stocks;

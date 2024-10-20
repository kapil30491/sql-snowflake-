CREATE DATABASE LEET_CODE;


Create table If Not Exists Visits(visit_id int, customer_id int);

Create table If Not Exists Transactions(transaction_id int, visit_id int, amount int);

--Truncate table Visits
insert into Visits (visit_id, customer_id) values ('1', '23');
insert into Visits (visit_id, customer_id) values ('2', '9');
insert into Visits (visit_id, customer_id) values ('4', '30');
insert into Visits (visit_id, customer_id) values ('5', '54');
insert into Visits (visit_id, customer_id) values ('6', '96');
insert into Visits (visit_id, customer_id) values ('7', '54');
insert into Visits (visit_id, customer_id) values ('8', '54');
--Truncate table Transactions
insert into Transactions (transaction_id, visit_id, amount) values ('2', '5', '310');
insert into Transactions (transaction_id, visit_id, amount) values ('3', '5', '300');
insert into Transactions (transaction_id, visit_id, amount) values ('9', '5', '200');
insert into Transactions (transaction_id, visit_id, amount) values ('12', '1', '910');
insert into Transactions (transaction_id, visit_id, amount) values ('13', '2', '970');


SELECT * FROM VISITS;

SELECT * FROM TRANSACTIONS;


SELECT V.CUSTOMER_ID,COUNT(V.VISIT_ID) AS COUNT_NO_TRANS
FROM VISITS AS V
LEFT JOIN TRANSACTIONS AS T
ON T.VISIT_ID = V.VISIT_ID
WHERE T.TRANSACTION_ID IS NULL
GROUP BY 1;



SELECT v.customer_id, COUNT(v.visit_id) AS count_no_trans 
from Visits v 
LEFT JOIN Transactions t 
ON v.visit_id = t.visit_id  
WHERE t.transaction_id IS NULL 
GROUP BY v.customer_id;
-----------------------------------------------------------------------------------------------------------------
Create table If Not Exists Weather (id int, recordDate date, temperature int);

insert into Weather (id, recordDate, temperature) values ('1', '2015-01-01', '10');
insert into Weather (id, recordDate, temperature) values ('2', '2015-01-02', '25');
insert into Weather (id, recordDate, temperature) values ('3', '2015-01-03', '20');
insert into Weather (id, recordDate, temperature) values ('4', '2015-01-04', '30');


SELECT * FROM WEATHER;

-- Write your MySQL query statement below

--EXPECTED O/P

-- --Output: 
-- +----+
-- | id |
-- +----+
-- | 2  |
-- | 4  |
-- +----+ ;




SELECT W1.ID
FROM WEATHER W1
JOIN WEATHER W2
ON DATEDIFF(day, W2.RECORDDATE, W1.RECORDDATE) = 1
WHERE W1.TEMPERATURE > W2.TEMPERATURE;

-------------------------------------------------------------------------------------------

Create table If Not Exists Signups (user_id int, time_stamp datetime);

CREATE OR REPLACE TABLE Confirmations (
    user_id INT,
    time_stamp TIMESTAMP_LTZ,
    action VARCHAR
);


insert into Signups (user_id, time_stamp) values ('3', '2020-03-21 10:16:13');
insert into Signups (user_id, time_stamp) values ('7', '2020-01-04 13:57:59');
insert into Signups (user_id, time_stamp) values ('2', '2020-07-29 23:09:44');
insert into Signups (user_id, time_stamp) values ('6', '2020-12-09 10:39:37');

insert into Confirmations (user_id, time_stamp, action) values ('3', '2021-01-06 03:30:46', 'timeout');
insert into Confirmations (user_id, time_stamp, action) values ('3', '2021-07-14 14:00:00', 'timeout');
insert into Confirmations (user_id, time_stamp, action) values ('7', '2021-06-12 11:57:29', 'confirmed');
insert into Confirmations (user_id, time_stamp, action) values ('7', '2021-06-13 12:58:28', 'confirmed');
insert into Confirmations (user_id, time_stamp, action) values ('7', '2021-06-14 13:59:27', 'confirmed');
insert into Confirmations (user_id, time_stamp, action) values ('2', '2021-01-22 00:00:00', 'confirmed');
insert into Confirmations (user_id, time_stamp, action) values ('2', '2021-02-28 23:59:59', 'timeout');


SELECT * FROM SIGNUPS;


SELECT * FROM CONFIRMATIONS;

SELECT S.USER_ID,ROUND(SUM(C.ACTION ='CONFIRMED')/COUNT(*),2) AS CONFIRMATION_RATE

FROM SIGNUPS S
LEFT JOIN CONFIRMATIONS C
ON S.USER_ID= C.USER_ID
GROUP BY S.USER_ID;




SELECT S.USER_ID,
CASE 
    WHEN C.TIME_STAMP IS NULL THEN 0.00
    ELSE ROUND(SUM(C.ACTION ='CONFIRMED')/COUNT(*),2)
    END AS CONFIRMATION_RATE
FROM SIGNUPS S
LEFT JOIN CONFIRMATIONS C
ON S.USER_ID = C.USER_ID
GROUP BY S.USER_ID;

--------------------------------------------------------------------------------------------------------------------

Create table If Not Exists Prices (product_id int, start_date date, end_date date, price int);

insert into Prices (product_id, start_date, end_date, price) values ('1', '2019-02-17', '2019-02-28', '5');
insert into Prices (product_id, start_date, end_date, price) values ('1', '2019-03-01', '2019-03-22', '20');
insert into Prices (product_id, start_date, end_date, price) values ('2', '2019-02-01', '2019-02-20', '15');
insert into Prices (product_id, start_date, end_date, price) values ('2', '2019-02-21', '2019-03-31', '30');


Create table If Not Exists UnitsSold (product_id int, purchase_date date, units int);



insert into UnitsSold (product_id, purchase_date, units) values ('1', '2019-02-25', '100');
insert into UnitsSold (product_id, purchase_date, units) values ('1', '2019-03-01', '15');
insert into UnitsSold (product_id, purchase_date, units) values ('2', '2019-02-10', '200');
insert into UnitsSold (product_id, purchase_date, units) values ('2', '2019-03-22', '30');




-- Write a solution to find the average selling price for each product. average_price should be rounded to 2 decimal places.

-- Return the result table in any order.

-- Explanation: 
-- Average selling price = Total Price of Product / Number of products sold.
-- Average selling price for product 1 = ((100 * 5) + (15 * 20)) / 115 = 6.96
-- Average selling price for product 2 = ((200 * 15) + (30 * 30)) / 230 = 16.96


-- Output: 
-- +------------+---------------+
-- | product_id | average_price |
-- +------------+---------------+
-- | 1          | 6.96          |
-- | 2          | 16.96         |
-- +------------+---------------+


SELECT * FROM Prices;

SELECT * FROM UNITSSOLD;

SELECT P.PRODUCT_ID,ROUND(SUM(P.PRICE*U.UNITS)/SUM(UNITS),2)AS AVG_PRICE
FROM PRICES P
LEFT JOIN UNITSSOLD U
ON P.PRODUCT_ID = U.PRODUCT_ID
AND U.PURCHASE_DATE >=P.START_DATE
AND U.PURCHASE_DATE <=P.END_DATE
GROUP BY P.PRODUCT_ID;


-----------------------------------------------------------------------------------------------------------------

Create table If Not Exists Project (project_id int, employee_id int);
Create table If Not Exists Employee (employee_id int, name varchar(10), experience_years int);

insert into Project (project_id, employee_id) values ('1', '1');
insert into Project (project_id, employee_id) values ('1', '2');
insert into Project (project_id, employee_id) values ('1', '3');
insert into Project (project_id, employee_id) values ('2', '1');
insert into Project (project_id, employee_id) values ('2', '4');

insert into Employee (employee_id, name, experience_years) values ('1', 'Khaled', '3');
insert into Employee (employee_id, name, experience_years) values ('2', 'Ali', '2');
insert into Employee (employee_id, name, experience_years) values ('3', 'John', '1');
insert into Employee (employee_id, name, experience_years) values ('4', 'Doe', '2');

SELECT * FROM PROJECT;

SELECT * FROM EMPLOYEE;




-- Output: 
-- +-------------+---------------+
-- | project_id  | average_years |
-- +-------------+---------------+
-- | 1           | 2.00          |
-- | 2           | 2.50          |
-- +-------------+---------------+


SELECT P.PROJECT_ID, ROUND(AVG(E.EXPERIENCE_YEARS),2) AS AVERAGE_YEARS
FROM PROJECT  P
LEFT JOIN EMPLOYEE E
ON P.EMPLOYEE_ID = E.EMPLOYEE_ID
GROUP BY P.PROJECT_ID;



------------------------------------------------------------------------------------------------------------------------

Create table If Not Exists Users (user_id int, user_name varchar(20));

insert into Users (user_id, user_name) values ('6', 'Alice');
insert into Users (user_id, user_name) values ('2', 'Bob');
insert into Users (user_id, user_name) values ('7', 'Alex');


Create table If Not Exists Register (contest_id int, user_id int);

insert into Register (contest_id, user_id) values ('215', '6');
insert into Register (contest_id, user_id) values ('209', '2');
insert into Register (contest_id, user_id) values ('208', '2');
insert into Register (contest_id, user_id) values ('210', '6');
insert into Register (contest_id, user_id) values ('208', '6');
insert into Register (contest_id, user_id) values ('209', '7');
insert into Register (contest_id, user_id) values ('209', '6');
insert into Register (contest_id, user_id) values ('215', '7');
insert into Register (contest_id, user_id) values ('208', '7');
insert into Register (contest_id, user_id) values ('210', '2');
insert into Register (contest_id, user_id) values ('207', '2');
insert into Register (contest_id, user_id) values ('210', '7');



SELECT * FROM USERS;

SELECT * FROM REGISTER;


-- Write a solution to find the percentage of the users registered in each contest rounded to two decimals.

-- Return the result table ordered by percentage in descending order. In case of a tie, order it by contest_id in ascending order.


-- Output: 
-- +------------+------------+
-- | contest_id | percentage |
-- +------------+------------+
-- | 208        | 100.0      |
-- | 209        | 100.0      |
-- | 210        | 100.0      |
-- | 215        | 66.67      |
-- | 207        | 33.33      |
-- +------------+------------+

SELECT CONTEST_ID,
ROUND(COUNT(DISTINCT USER_ID)/(SELECT COUNT(USER_ID) FROM USERS)* 100,2) AS PERCENTAGE
FROM REGISTER
GROUP BY CONTEST_ID
ORDER BY PERCENTAGE DESC,CONTEST_ID;


-----------------------------------------------------------------------------------------------------------

Create table If Not Exists Queries (query_name varchar(30), result varchar(50), position int, rating int);


insert into Queries (query_name, result, position, rating) values ('Dog', 'Golden Retriever', '1', '5');
insert into Queries (query_name, result, position, rating) values ('Dog', 'German Shepherd', '2', '5');
insert into Queries (query_name, result, position, rating) values ('Dog', 'Mule', '200', '1');
insert into Queries (query_name, result, position, rating) values ('Cat', 'Shirazi', '5', '2');
insert into Queries (query_name, result, position, rating) values ('Cat', 'Siamese', '3', '3');
insert into Queries (query_name, result, position, rating) values ('Cat', 'Sphynx', '7', '4');

-- We define query quality as:
-- The average of the ratio between query rating and its position.
-- We also define poor query percentage as:
-- The percentage of all queries with rating less than 3.
-- Write a solution to find each query_name, the quality and poor_query_percentage.
-- Both quality and poor_query_percentage should be rounded to 2 decimal places.
-- Return the result table in any order

SELECT *FROM QUERIES;




WITH DOG_CAT AS (

SELECT QUERY_NAME,RATING/POSITION AS RATIO,
CASE
    WHEN RATING < 3 THEN 1
    ELSE 0
    END AS POOR_QUALITY
FROM QUERIES
)

SELECT QUERY_NAME,
ROUND(AVG(RATIO),2) AS QUALITY,
ROUND(SUM(POOR_QUALITY)/COUNT(*) *100,2) AS POOR_QUERY_PERCENTAGE
 FROM DOG_CAT
 WHERE QUERY_NAME IS NOT NULL
 GROUP BY QUERY_NAME;





select distinct query_name , round(avg(rating/position) over(partition by query_name) ,2) as quality,
round(avg(case when rating<3 then 1 else 0 end) over(partition by query_name)*100,2) as poor_query_percentage from queries
where query_name is not null;

--------------------------------------------------------------------------------------------------------------------------

-- 1193. Monthly Transactions I

CREATE OR REPLACE TABLE Transactions (
    id INT,
    country VARCHAR(4),
    state VARCHAR(10) ,
    amount INT,
    trans_date DATE
);


insert into Transactions (id, country, state, amount, trans_date) values ('121', 'US', 'approved', '1000', '2018-12-18');
insert into Transactions (id, country, state, amount, trans_date) values ('122', 'US', 'declined', '2000', '2018-12-19');
insert into Transactions (id, country, state, amount, trans_date) values ('123', 'US', 'approved', '2000', '2019-01-01');
insert into Transactions (id, country, state, amount, trans_date) values ('124', 'DE', 'approved', '2000', '2019-01-07');



SELECT * FROM TRANSACTIONS;



SELECT 
TO_CHAR(TRANS_DATE, 'YYYY-MM') AS MONTH,
COUNTRY,
COUNT(ID) AS TRANS_COUNTS,
SUM(CASE
    WHEN STATE = 'APPROVED' THEN 1 
    ELSE 0 END) AS APPROVED_COUNT,
SUM(AMOUNT)AS TRANS_TOTAL_AMOUNT,
SUM(CASE
    WHEN STATE='APPROVED' THEN AMOUNT
    ELSE 0 END) AS   APPROVED_AMOUNT
    

FROM TRANSACTIONS
GROUP BY MONTH,COUNTRY;

select TO_CHAR(TRANS_DATE, 'YYYY-MM') as month
         , country
         , count(id) as trans_count
         , sum(case 
             when state = 'approved' then 1
             else 0 end) as approved_count
         , sum(amount) as trans_total_amount 
         , sum(case 
             when state = 'approved' then amount
             else 0 end) as approved_total_amount 
from Transactions 
group by month,country;

--------------------------------------------------------------------------------------------------------------------------

-- 1174. Immediate Food Delivery II

Create table If Not Exists Delivery (
delivery_id int, 
customer_id int, 
order_date date, 
customer_pref_delivery_date date);

insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('1', '1', '2019-08-01', '2019-08-02');
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('2', '2', '2019-08-02', '2019-08-02');
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('3', '1', '2019-08-11', '2019-08-12');
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('4', '3', '2019-08-24', '2019-08-24');
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('5', '3', '2019-08-21', '2019-08-22');
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('6', '2', '2019-08-11', '2019-08-13');
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('7', '4', '2019-08-09', '2019-08-09');


-- If the customer's preferred delivery date is the same as the order date, then the order is called immediate; otherwise, it is called scheduled.

-- The first order of a customer is the order with the earliest order date that the customer made. It is guaranteed that a customer has precisely one first order.

-- Write a solution to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.

-- The result format is in the following example




-- Output: 
-- +----------------------+
-- | immediate_percentage |
-- +----------------------+
-- | 50.00                |
-- +----------------------+


SELECT * FROM DELIVERY;



WITH IMMEDIATE AS (
    SELECT *,
           RANK() OVER (PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE) AS RNK,
           CASE
               WHEN ORDER_DATE = CUSTOMER_PREF_DELIVERY_DATE THEN 'IMMEDIATE'
               ELSE 'SCHEDULED'
           END AS ORDER_TYPE
    FROM DELIVERY
)
SELECT ROUND(
    (SUM(CASE WHEN ORDER_TYPE = 'IMMEDIATE' THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
    2
) AS IMMEDIATE_PERCENTAGE
FROM IMMEDIATE
WHERE RNK = 1;


---------------------------------------------------------------------------------------------------------==-
-- 550. Game Play Analysis IV

Create table If Not Exists Activity (
player_id int, 
device_id int, 
event_date date, 
games_played int);

insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-03-01', '5');
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-03-02', '6');
insert into Activity (player_id, device_id, event_date, games_played) values ('2', '3', '2017-06-25', '1');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '1', '2016-03-02', '0');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '4', '2018-07-03', '5');


SELECT * FROM ACTIVITY;


-- Write a solution to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, then divide that number by the total number of players.

-- Output: 
-- +-----------+
-- | fraction  |
-- +-----------+
-- | 0.33      |
-- +-----------+

-- WITH CTE AS(
-- SELECT PLAYER_ID,MIN(EVENT_DATE)AS FIRST_LOGIN
-- FROM ACTIVITY
-- GROUP BY PLAYER_ID
-- )
-- SELECT *,DATEADD(FIRST_LOGIN,INTERVAL 1 DAY) AS NEXT_DATE
-- FROM CTE;

-- -----

-- SELECT * FROM ACTIVITY;

-- WITH FIRST_DATE AS (
-- SELECT PLAYER_ID,MIN(EVENT_DATE) AS FIRST_DATE
-- FROM ACTIVITY
-- GROUP BY PLAYER_ID),

-- CTE2 AS(
-- SELECT *,DATEADD(DAY,1,FIRST_DATE)AS NEXT_DATE
-- FROM FIRST_DATE
-- )

-- SELECT COUNT(DISTINCT PLAYER_ID)
-- FROM ACTIVITY
-- WHERE(PLAYER_ID,EVENT_DATE) IN (SELECT PLAYER_ID,NEXT_DATE FROM CTE2))/(SELECT COUNT(DISTINCT PLAYER_ID) FROM ACTIVITY)


--------------------------------------------------------------------------------------------------------------------
-- 1070. Product Sales Analysis III


Create table If Not Exists Sales (sale_id int, product_id int, year int, quantity int, price int);
Create table If Not Exists Product (product_id int, product_name varchar(10));

insert into Sales (sale_id, product_id, year, quantity, price) values ('1', '100', '2008', '10', '5000');
insert into Sales (sale_id, product_id, year, quantity, price) values ('2', '100', '2009', '12', '5000');
insert into Sales (sale_id, product_id, year, quantity, price) values ('7', '200', '2011', '15', '9000');

insert into Product (product_id, product_name) values ('100', 'Nokia');
insert into Product (product_id, product_name) values ('200', 'Apple');
insert into Product (product_id, product_name) values ('300', 'Samsung');



-- Output: 
-- +------------+------------+----------+-------+
-- | product_id | first_year | quantity | price |
-- +------------+------------+----------+-------+ 
-- | 100        | 2008       | 10       | 5000  |
-- | 200        | 2011       | 15       | 9000  |
-- +------------+------------+----------+-------+

-- Write a solution to select the product id, year, quantity, and price for the first year of every product sold.
-- Return the resulting table in any order.

SELECT * FROM SALES;

-- METHOD CTE
WITH CTE AS (
SELECT *,
RANK() OVER(PARTITION BY PRODUCT_ID ORDER BY YEAR) AS RNK
FROM SALES
)
 SELECT PRODUCT_ID,YEAR AS FIRST_YEAR,QUANTITY,PRICE
 FROM CTE
 WHERE RNK = 1;


-- METHOD.2- SUBQUERY


SELECT * FROM SALES;


SELECT PRODUCT_ID,
YEAR AS FIRST_YEARS,
QUANTITY,
PRICE
FROM SALES
WHERE 
      (PRODUCT_ID,YEAR) IN(SELECT PRODUCT_ID,MIN(YEAR)FROM SALES GROUP BY PRODUCT_ID);

---------------------------------------------------------------------------------------------------------
-- 619. Biggest Single Number

Create table If Not Exists MyNumbers (num int);

insert into MyNumbers (num) values ('8');
insert into MyNumbers (num) values ('8');
insert into MyNumbers (num) values ('3');
insert into MyNumbers (num) values ('3');
insert into MyNumbers (num) values ('1');
insert into MyNumbers (num) values ('4');
insert into MyNumbers (num) values ('5');
insert into MyNumbers (num) values ('6');

SELECT * FROM MYNUMBERS;

-- Find the largest single number. If there is no single number, report null.
-- The result format is in the following example.

-- Output: 
-- +-----+
-- | num |
-- +-----+
-- | 6   |
-- -- +---

-- SUBQUERY

SELECT MAX(NUM) AS NUM 
FROM MYNUMBERS
WHERE NUM IN (SELECT NUM FROM MYNUMBERS GROUP BY NUM HAVING COUNT(*)=1);



-- CTE


WITH NUMBER_CTE AS
(SELECT NUM 
FROM MYNUMBERS
GROUP BY NUM
HAVING COUNT(NUM)=1)

SELECT CASE WHEN COUNT(NUM)>0 THEN MAX(NUM) ELSE NULL END AS NUM
FROM NUMBER_CTE;


--------------------------------------------------------------------------------------------------------------
-- 1045. Customers Who Bought All Products

Create table If Not Exists Customer (customer_id int, product_key int);

insert into Customer (customer_id, product_key) values ('1', '5');
insert into Customer (customer_id, product_key) values ('2', '6');
insert into Customer (customer_id, product_key) values ('3', '5');
insert into Customer (customer_id, product_key) values ('3', '6');
insert into Customer (customer_id, product_key) values ('1', '6');


Create table Product (product_key int);

insert into Product (product_key) values ('5');
insert into Product (product_key) values ('6');


-- Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.
-- Return the result table in any order.


-- Output: 
-- +-------------+
-- | customer_id |
-- +-------------+
-- | 1           |
-- | 3           |
-- +-------------+

SELECT * FROM CUSTOMER;

SELECT CUSTOMER_ID
FROM CUSTOMER
GROUP BY CUSTOMER_ID
HAVING COUNT(DISTINCT PRODUCT_KEY)=(SELECT COUNT(PRODUCT_KEY) FROM PRODUCT);


-----------------------------------------------------------------------------------;
-- 610 TRIANGLE JUDGEMENT
Create table If Not Exists Triangle (x int, y int, z int);

insert into Triangle (x, y, z) values ('13', '15', '30');
insert into Triangle (x, y, z) values ('10', '20', '15');


-- Report for every three line segments whether they can form a triangle.
-- Return the result table in any order.

-- Output: 
-- +----+----+----+----------+
-- | x  | y  | z  | triangle |
-- +----+----+----+----------+
-- | 13 | 15 | 30 | No       |
-- | 10 | 20 | 15 | Yes      |
-- +----+----+----+----------+

-- 1ST METHOD

SELECT *,
CASE WHEN (X+Y > Z AND Y+Z > X AND X+Z>Y) THEN 'YES'
ELSE 'NO' END AS TRIANGLE
FROM TRIANGLE;

-- 2ND METHOD

SELECT *,
       IFF (X+Y>Z AND Y+Z > X AND X+Z > Y ,'YES','NO')AS TRIANGLE
FROM TRIANGLE;

-----------------------------------------------------------------------------------------
-- 180. Consecutive Numbers

Create table If Not Exists Logs (id int, num int);

insert into Logs (id, num) values ('1', '1');
insert into Logs (id, num) values ('2', '1');
insert into Logs (id, num) values ('3', '1');
insert into Logs (id, num) values ('4', '2');
insert into Logs (id, num) values ('5', '1');
insert into Logs (id, num) values ('6', '2');
insert into Logs (id, num) values ('7', '2');


-- Find all numbers that appear at least three times consecutively.
-- Return the result table in any order.

-- Output: 
-- +-----------------+
-- | ConsecutiveNums |
-- +-----------------+
-- | 1               |
-- +-----------------+

SELECT * FROM LOGS;


WITH CONS_NUM AS
(SELECT *,
LEAD(NUM,1) OVER(ORDER BY NUM) AS NEXT_NUM,
LEAD(NUM,2)OVER(ORDER BY NUM) AS NEXT_2_NEXT
FROM LOGS)

SELECT DISTINCT NUM AS CONSECUTIVE_NUMBER 
FROM
CONS_NUM
WHERE NEXT_NUM=1 AND NEXT_2_NEXT=1;

-----------------------------------------------------------------------------
CREATE OR REPLACE TABLE Orders(
OrderID   int, 
CustomerID  int,   
OrderDate   date,
Amount    decimal


); 

insert into Orders
 (OrderID, CustomerID, OrderDate,  Amount)
 values
 
 (1, 101, '2023-08-01', 250.00),
 (2, 102, '2023-08-01', 450.00),
 (3, 101, '2023-08-02', 150.00),
 (4, 101, '2023-08-03', 300.00),
 (5, 103, '2023-08-03', 200.00),
 (6, 101, '2023-08-04', 400.00);


 SELECT * FROM ORDERS;






SELECT * FROM ORDERS;
WITH CTE AS
(SELECT CUSTOMERID,
ORDERDATE AS DAY1,
LEAD(ORDERDATE,1) OVER(PARTITION BY CUSTOMERID ORDER BY ORDERDATE) AS DAY2,
LEAD(ORDERDATE,2) OVER(PARTITION BY CUSTOMERID ORDER BY ORDERDATE) AS DAY3
FROM ORDERS)

SELECT DISTINCT CUSTOMERID
FROM CTE
WHERE DATEDIFF(DAY,DAY1,DAY2)=1 AND
DATEDIFF(DAY,DAY1,DAY3)=2;

-------------------------------------------------------------------------------------------------

-- 1164. Product Price at a Given Date

Create table If Not Exists Products (product_id int, new_price int, change_date date);

insert into Products (product_id, new_price, change_date) values ('1', '20', '2019-08-14');
insert into Products (product_id, new_price, change_date) values ('2', '50', '2019-08-14');
insert into Products (product_id, new_price, change_date) values ('1', '30', '2019-08-15');
insert into Products (product_id, new_price, change_date) values ('1', '35', '2019-08-16');
insert into Products (product_id, new_price, change_date) values ('2', '65', '2019-08-17');
insert into Products (product_id, new_price, change_date) values ('3', '20', '2019-08-18');


-- Write a solution to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.
-- Return the result table in any order.

-- Output: 
-- +------------+-------+
-- | product_id | price |
-- +------------+-------+
-- | 2          | 50    |
-- | 1          | 35    |
-- | 3          | 10    |
-- +------------+-------

WITH CTE AS
(SELECT *,
RANK()OVER(PARTITION BY PRODUCT_ID ORDER BY CHANGE_DATE DESC) AS RNK
FROM PRODUCTS
WHERE CHANGE_DATE <= '2019-08-16')

SELECT PRODUCT_ID, NEW_PRICE AS PRICE
FROM CTE
WHERE RNK=1

UNION
SELECT PRODUCT_ID,10 AS PRICE
FROM PRODUCTS
WHERE PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM CTE);
















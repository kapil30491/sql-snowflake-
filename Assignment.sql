-- 1. Customer and Sales Performance Analysis

select * from transactions;
-- •	Task 1: Rank customers based on their total purchase amount per year. Identify the top 5 customers each year and track their ranking over time. (Use RANK())

with year_txns as(
select customer_id,
extract(year from transaction_date) as purchase_dt,
sum(transaction_amount) as tot_pur_amnt,
from transactions
group by 1,2 
),
rank_customer as(

select customer_id,
purchase_dt,
tot_pur_amnt,
rank()over(partition by purchase_dt order by tot_pur_amnt desc ) as rnk
from year_txns
)

select customer_id,purchase_dt,tot_pur_amnt,rnk
from rank_customer
where rnk<=5
order by purchase_dt,rnk;


-- Task 2: For each customer, get their previous transaction amount and compare it with their current one. (Use LAG())

select * from transactions;

select customer_id,transaction_amount as current_txn,
lag(transaction_amount)over(partition by customer_id order by transaction_date) as prev_txn
from transactions
order by customer_id;


-- Task 3: Calculate the running total of sales for each customer in the last 3 years. (Use SUM() OVER)



WITH CTE AS(
SELECT CUSTOMER_ID,
SALE_AMOUNT,
SALE_DATE FROM SALES
WHERE SALE_DATE >=DATEADD(YEAR,-3,SALE_DATE)

)

SELECT CUSTOMER_ID,SALE_AMOUNT,SALE_DATE,
SUM(SALE_AMOUNT)OVER(PARTITION BY CUSTOMER_ID ORDER BY SALE_DATE ) RUN_TOT
FROM CTE
ORDER BY CUSTOMER_ID,SALE_DATE;


-- Task 4: Divide customers into quartiles based on their total sales per year and analyze their spending patterns. (Use NTILE())

SELECT * FROM SALES;

WITH  quartiles AS (
SELECT CUSTOMER_ID,
EXTRACT(YEAR FROM SALE_DATE)AS YRS,
SUM(SALE_AMOUNT) AS TOT_SALES
FROM SALES
GROUP BY 1,2
)
SELECT CUSTOMER_ID,YRS,TOT_SALES,
NTILE(4)OVER(PARTITION BY YRS ORDER BY TOT_SALES) AS quartiles
FROM QUARTILES;



-- 2. Employee Performance Evaluation


-- Task 1: Track the rank of employees in terms of monthly evaluation scores within each department for the last 3 years. (Use DENSE_RANK())


WITH EVAL AS (
SELECT 
E.EMPLOYEE_ID,
E.EMPLOYEE_NAME,
D.DEPARTMENT_NAME,
EL.EVALUATION_MONTH,
EL.EVALUATION_SCORE
FROM EVALUATIONS EL
JOIN EMPLOYEES E
ON EL.EMPLOYEE_ID=E.EMPLOYEE_ID
JOIN DEPARTMENTS D
ON E.EMPLOYEE_ID=D.EMPLOYEE_ID
WHERE EVALUATION_MONTH >= DATE_TRUNC(YEARS,EVALUATION_MONTH)- INTERVAL '3 YEARS'
),

RANKS AS(
SELECT EMPLOYEE_ID,EMPLOYEE_NAME,DEPARTMENT_NAME,EVALUATION_MONTH,EVALUATION_SCORE,
DENSE_RANK()OVER(PARTITION BY DEPARTMENT_NAME ORDER BY EVALUATION_SCORE) AS D_RNK
FROM EVAL)

SELECT *
FROM RANKS
WHERE D_RNK <=5;



-- Task 2: Identify employees whose performance improved consistently over the last 6 months by comparing their current evaluation with their previous ones. (Use LAG())


SELECT 
E.EMPLOYEE_ID,
E.EMPLOYEE_NAME,
EL.EVALUATION_MONTH,
EL.EVALUATION_SCORE,
LAG(EL.EVALUATION_SCORE)OVER(PARTITION BY E.EMPLOYEE_ID ORDER BY EL.EVALUATION_SCORE) AS PREV_SCORE
FROM EVALUATIONS EL
JOIN EMPLOYEES E
ON EL.EMPLOYEE_ID=E.EMPLOYEE_ID
WHERE EL.EVALUATION_MONTH >= DATEADD(MONTH, -6, EL.EVALUATION_MONTH);



-- Task 3: Find the first department each employee joined and their current department.
-- (Use FIRST_VALUE(), LAST_VALUE())

SELECT * FROM DEPARTMENTS;

SELECT E.EMPLOYEE_ID,
E.EMPLOYEE_NAME,
FIRST_VALUE(D.DEPARTMENT_NAME)OVER(PARTITION BY E.EMPLOYEE_ID ORDER BY D.TRANSFER_DATE ) AS FRST_DEPART,
LAST_VALUE(D.DEPARTMENT_NAME)OVER(PARTITION BY E.EMPLOYEE_ID ORDER BY TRANSFER_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS CURR_DEPT
FROM EMPLOYEES E

JOIN DEPARTMENTS D
ON E.EMPLOYEE_ID=D.EMPLOYEE_ID
ORDER BY E.EMPLOYEE_ID;


-- Task 4: Calculate the cumulative average evaluation score of each employee over the years. (Use AVG() OVER)
SELECT *  FROM EVALUATIONS;

SELECT EMPLOYEE_ID,EVALUATION_MONTH, EVALUATION_SCORE,
AVG(EVALUATION_SCORE)OVER(PARTITION BY EMPLOYEE_ID ORDER BY EVALUATION_MONTH ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW )AS AVG_EVAL_SCR
FROM EVALUATIONS
ORDER BY EMPLOYEE_ID,EVALUATION_MONTH;


-- •	Business Scenario: You are tasked with analyzing product pricing trends and their impact on sales. You have datasets for product prices, sales transactions, and promotions. The company wants to understand how price changes and promotions affect product sales.
-- •	Window Functions: LEAD(), LAG(), SUM() OVER, MAX() OVER
-- Assignment Problem:
-- •	Task 1: For each product, compare the current price with the previous price and the next price, and analyze how price changes affect sales. (Use LAG(), LEAD())
-- •	Task 2: Calculate the cumulative sales for each product per month over the last 2 years. (Use SUM() OVER)
-- •	Task 3: Find the maximum price each product has ever been sold at and compare it to the current price. (Use MAX() OVER)
-- •	Task 4: Identify products that had promotional discounts and track their sales before, during, and after the promotion. (Use LAG(), LEAD())
-- Tables:
-- •	products (Product Information)
-- •	prices (Product Pricing History)
-- •	promotions (Promotional Events)
-- •	sales (Sales Transactions Data)

-- DDL For Tables:
-- Products Table


-- CREATE OR REPLACE TABLE products (
--     product_id VARCHAR(50) PRIMARY KEY,
--     product_name VARCHAR(255),
--     category VARCHAR(100)
-- );

-- -- Prices Table
-- CREATE OR REPLACE  TABLE prices (
--     price_id INT PRIMARY KEY,
--     product_id VARCHAR(50) REFERENCES products(product_id),
--     price DECIMAL(10, 2),
--     price_date DATE
-- );

-- -- Promotions Table
-- CREATE OR REPLACE TABLE promotions (
--     promotion_id INT PRIMARY KEY,
--     product_id VARCHAR(50) REFERENCES products(product_id),
--     discount DECIMAL(5, 2),
--     start_date DATE,
--     end_date DATE
-- );

-- -- Sales Table
-- CREATE OR REPLACE  TABLE sales (
--     sale_id INT PRIMARY KEY,
--     product_id VARCHAR(50) REFERENCES products(product_id),
--     sale_date DATE,
--     quantity_sold INT,
--     total_amount DECIMAL(10, 2)
-- );






CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255),
    region VARCHAR(100),
    join_date DATE
);

-- Accounts Table
CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    account_type VARCHAR(100),
    balance DECIMAL(15, 2),
    opened_date DATE
);

-- Transactions Table
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT REFERENCES accounts(account_id),
    transaction_date DATE,
    transaction_amount DECIMAL(15, 2),
    transaction_type VARCHAR(50)
);

-- Suspicious Activities Table
CREATE TABLE suspicious_activities (
    activity_id INT PRIMARY KEY,
    transaction_id INT REFERENCES transactions(transaction_id),
    flagged_reason VARCHAR(255),
    flagged_date DATE
);



SELECT * FROM SUSPICIOUS_ACTIVITIES;
SELECT * FROM TRANSACTIONS;
SELECT * FROM ACCOUNTS;
SELECT * FROM CUSTOMERS;




    
 
-- Task 1: Detect anomalies in customer purchasing behavior by identifying customers whose current transaction amount is 3 times larger than their previous one. (Use LAG() to compare current and previous transaction amounts, and flag outliers.)

WITH PREV_TRANSACTIONS AS(
SELECT CUSTOMER_ID,TRANSACTION_DATE,TRANSACTION_AMOUNT,
LAG(TRANSACTION_AMOUNT)OVER(PARTITION BY CUSTOMER_ID ORDER BY TRANSACTION_DATE) AS PREV_TRN
FROM TRANSACTIONS)

SELECT CUSTOMER_ID,TRANSACTION_DATE, TRANSACTION_AMOUNT,PREV_TRN,
CASE WHEN
 TRANSACTION_AMOUNT >=3*PREV_TRN THEN 'ANOMALY' ELSE 'NORMAL' END AS TRANSACTION_STATUS

FROM PREV_TRANSACTIONS
WHERE PREV_TRN IS NOT NULL;


--Task 2: For each customer, calculate their rolling average transaction amount for the last 3 transactions and identify customers whose latest transaction is significantly above their rolling average. (Use LAG() and SUM() OVER for a rolling calculation.)

WITH ROLLING_AVG AS(
SELECT CUSTOMER_ID,TRANSACTION_DATE,TRANSACTION_AMOUNT,
LAG(TRANSACTION_AMOUNT)OVER(PARTITION BY CUSTOMER_ID ORDER BY TRANSACTION_DATE) AS PREV_TRANS,
AVG(TRANSACTION_AMOUNT)OVER(PARTITION BY CUSTOMER_ID ORDER BY TRANSACTION_DATE ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)AS AVG_3_DAY

FROM TRANSACTIONS
)

SELECT *
FROM ROLLING_AVG
WHERE TRANSACTION_AMOUNT > AVG_3_DAY
ORDER BY CUSTOMER_ID,TRANSACTION_DATE DESC;



--Task 3: Rank products based on total sales in the last year and divide them into quartiles. Analyze the spending behavior of customers who bought products in the top quartile versus the bottom quartile. (Use RANK() and NTILE() to divide products into groups.)

-- •	Dataset: employees, departments, evaluations



SELECT * FROM DEPARTMENTS;
SELECT * FROM EMPLOYEES;
SELECT * FROM EVALUATIONS;


-- ======================================================================================================
-- =====================================================================================================

-- restaurant_customers Table

CREATE OR REPLACE TABLE restaurant_customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL
);

-- 2. restaurant_transactions Table

-- This table stores details of each transaction made by customers over the last 3 years.

CREATE OR REPLACE TABLE restaurant_transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    transaction_date DATE,
    transaction_amount DECIMAL(10, 2),
    items_ordered INT,
    payment_method VARCHAR(50),
    branch VARCHAR(50),
    customer_feedback INT CHECK (customer_feedback BETWEEN 1 AND 5),
    FOREIGN KEY (customer_id) REFERENCES restaurant_customers(customer_id)
);


CREATE OR REPLACE TABLE restaurant_transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    transaction_date DATE,
    transaction_amount DECIMAL(10, 2),
    items_ordered INT,
    payment_method VARCHAR(50),
    branch VARCHAR(50),
    customer_feedback INT,
    FOREIGN KEY (customer_id) REFERENCES restaurant_customers(customer_id)
);



-- Task 1: For each branch, rank customers based on their total spending over the last 2 years. Identify the top 5 customers from each branch.


SELECT * FROM RESTAURANT_CUSTOMERS;

SELECT * FROM RESTAURANT_TRANSACTIONS
LIMIT 10 ;


WITH TOT_SPENT AS (
SELECT CUSTOMER_ID,BRANCH, 
sum(transaction_amount) as tot_spent
FROM RESTAURANT_TRANSACTIONS
WHERE TRANSACTION_DATE >= DATEADD(YEAR,-2,TRANSACTION_DATE)
GROUP BY 1,2
),
TOP_5_CUSTOMER AS(
SELECT *,
DENSE_RANK()OVER(PARTITION BY BRANCH ORDER BY TOT_SPENT DESC) AS RNK
FROM TOT_SPENT
)
SELECT *
FROM TOP_5_CUSTOMER
WHERE RNK<=5
ORDER BY BRANCH,RNK;


-- Task 2: Calculate the running total of transaction amounts for each customer and branch. Track how much each customer spent cumulatively and identify customers whose spending reached $1,000 first.


WITH RUNNING_TOT AS(
SELECT CUSTOMER_ID,BRANCH,TRANSACTION_DATE,TRANSACTION_AMOUNT,
SUM(TRANSACTION_AMOUNT)OVER(PARTITION BY CUSTOMER_ID,BRANCH ORDER BY TRANSACTION_DATE)AS COMM_TOT_SPEND,
ROW_NUMBER()OVER(PARTITION BY CUSTOMER_ID,BRANCH ORDER BY TRANSACTION_DATE) AS ROW_NUM
FROM RESTAURANT_TRANSACTIONS
)

SELECT CUSTOMER_ID, BRANCH,TRANSACTION_DATE,COMM_TOT_SPEND
FROM RUNNING_TOT
WHERE COMM_TOT_SPEND >=1000 ;
-- AND ROW_NUM=1;




-- Task 3: For each branch, assign a rank to customers based on their spending in the last 6 months. If two customers spent the same amount, give them the same rank (use RANK()), but ensure no gaps in ranking (use DENSE_RANK()).


WITH LAST_6_MONTH AS(
SELECT CUSTOMER_ID,BRANCH,
SUM(TRANSACTION_AMOUNT) AS TOT_SPEND,
FROM RESTAURANT_TRANSACTIONS
WHERE TRANSACTION_DATE >= DATEADD(MONTH, -6, TRANSACTION_DATE)
GROUP BY CUSTOMER_ID,BRANCH
)

SELECT CUSTOMER_ID, BRANCH,TOT_SPEND,
DENSE_RANK()OVER(PARTITION BY BRANCH ORDER BY TOT_SPEND) AS SPEND_RNK
FROM LAST_6_MONTH;




-- 2. Customer Loyalty Analysis


-- For each customer, calculate the change in their transaction amount compared to their previous transaction. Identify customers whose spending consistently increased for their last 3 transactions.

WITH CONSISTENTLY AS (

SELECT CUSTOMER_ID,
TRANSACTION_DATE,
TRANSACTION_AMOUNT AS CURR_TXN,
LAG(TRANSACTION_AMOUNT,1)OVER(PARTITION BY CUSTOMER_ID ORDER BY TRANSACTION_DATE) AS PREV_TXN,
LAG(TRANSACTION_AMOUNT,2)OVER(PARTITION BY CUSTOMER_ID ORDER BY TRANSACTION_DATE) AS PREV_TO_PREV_TXN
FROM RESTAURANT_TRANSACTIONS

)
SELECT CUSTOMER_ID,TRANSACTION_DATE
FROM CONSISTENTLY
WHERE CURR_TXN > PREV_TXN AND PREV_TXN > PREV_TO_PREV_TXN;





-- 3. Branch Performance Analysis
-- •	Goal: Analyze how each restaurant branch is performing in terms of customer satisfaction and revenue.
-- •	Window Functions: AVG() OVER, MAX() OVER, MIN() OVER
-- Problem Statements:
-- •	Task 1: For each branch, calculate the average transaction amount and compare the highest and lowest transaction amounts within each branch over the last 3 years.

SELECT * FROM RESTAURANT_TRANSACTIONS;

SELECT BRANCH,
ROUND(AVG(TRANSACTION_AMOUNT),2) AS AVG_TXN,
MAX(TRANSACTION_AMOUNT)AS MAX_TXN,
MIN(TRANSACTION_AMOUNT) AS MIN_TXN
FROM RESTAURANT_TRANSACTIONS
WHERE TRANSACTION_DATE >= DATEADD(YEAR,-3,TRANSACTION_DATE)
GROUP BY 1;



-- Task 2: Track monthly performance for each branch. Use window functions to calculate the rolling average transaction amount for each branch and identify months where the rolling average significantly drops.


-- WITH MONTHLY AS (
-- SELECT BRANCH,
-- DATE_TRUNC(MONTH,TRANSACTION_DATE)AS MONTH_TXN,
-- SUM(TRANSACTION_AMOUNT) AS TOT_MONTH_TXN
-- FROM RESTAURANT_TRANSACTIONS
-- GROUP BY 1,2
-- )

-- SELECT BRANCH,MONTH_TXN,TOT_MONTH_TXN,
-- ROUND(AVG(TOT_MONTH_TXN)OVER(PARTITION BY BRANCH ORDER BY MONTH_TXN),2)AS ROLLING_AVG
-- FROM MONTHLY;


-- Rank branches based on their total revenue and average customer feedback. Identify the branch with the highest revenue but lowest feedback score.


WITH BANK_PER AS(
SELECT BRANCH,
SUM(TRANSACTION_AMOUNT)AS TOT_REV,
AVG(CUSTOMER_FEEDBACK)AS AVG_FEEDBACK
FROM RESTAURANT_TRANSACTIONS
GROUP BY BRANCH
),

RANKED AS(
SELECT BRANCH,TOT_REV,AVG_FEEDBACK,
RANK()OVER(ORDER BY TOT_REV DESC) AS REV_RNK
FROM BANK_PER
)
SELECT BRANCH TOT_REV,AVG_FEEDBACK
FROM RANKED
WHERE TOT_REV = (SELECT MAX(TOT_REV) FROM BANK_PER)
ORDER BY AVG_FEEDBACK;




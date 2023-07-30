-- Bank Customer Churn Analysis

-- This analysis was done in postgresql

-- Dataset Link
/* 
https://www.kaggle.com/datasets/shantanudhakadd/bank-customer-churn-prediction
*/


-- Tables used:
/*
•	Bank_Churn
•	Active_Customer
•	Credit_Card
•	Exit_Customer
*/


-- Problem Statement
/* 
 The aim of this project is to understand the key factors influencing churn and create strategies to reduce customer attrition.
*/

-- Project Summary
/*
A bank customer churn analysis was conducted using a dataset sourced from Kaggle. 
Three new tables were added to the database: active_customer, credit_card, and exit_customer. 
The tables were loaded into PostgreSQL and the analysis was performed entirely in PostgreSQL. 
Exploratory data analysis (EDA) was conducted, and useful insights were derived. 
Recommendations were then made to reduce customer churn. 
The analysis revealed that incentives need to be offered to customers who are at risk of churning, 
such as discounts, additional benefits, or personalized outreach. 
This includes customers with Fair or Poor credit scores, inactive customers, customers with credit cards, 
customers in Germany or France, customers who only use one product, customers who have been with the bank for 1 year, 
and customers in the age group of 41-50 and with a balance of 100,000-150,000.
*/

-- Business Objective
/*
The objective of bank customer churn analysis is to examine data and identify patterns, trends,
and factors influencing customer churn. By analyzing customer demographics, account activity, product usage, 
and satisfaction metrics, significant predictors of churn can be determined. 
Personalized retention strategies will be implemented, including tailored incentives, loyalty programs, 
and proactive support, to mitigate churn risk. Achieving this objective will improve customer retention, 
boost profitability, foster long-term customer relationships, and establish a competitive advantage in the banking industry.
*/


/* Queries used */


--Create The Tables 
CREATE TABLE IF NOT EXISTS bank_churn
(
	RowNumber SERIAL,
	CustomerId INTEGER PRIMARY KEY,
	Surname VARCHAR(50) NOT NULL,
	CreditScore INTEGER NOT NULL,
	Geography VARCHAR(50),
	Gender VARCHAR(50),
	Age INTEGER,
	Tenure INTEGER,
	Balance FLOAT,
	NumOfProducts INTEGER,
	HasCrCard INTEGER,
	IsActiveMember INTEGER,
	EstimatedSalary FLOAT,
	Exited INTEGER
);

COPY Bank_Churn FROM 'E:\Almabetter course material\Projects\My SQL Project\Bank churn\Bank_Churn.csv' with CSV HEADER;

CREATE TABLE IF NOT EXISTS active_customer
(
	IsActiveMember INTEGER,
	Active_Category VARCHAR(10) 
);

COPY Active_Customer FROM 'E:\Almabetter course material\Projects\My SQL Project\Bank churn\Active_Customer.csv' with CSV HEADER;

CREATE TABLE IF NOT EXISTS credit_card
(
	HasCrCard INTEGER PRIMARY KEY,
	Credit_card VARCHAR(10)
);

COPY Credit_Card FROM 'E:\Almabetter course material\Projects\My SQL Project\Bank churn\Credit_Card.csv' with CSV HEADER;

CREATE TABLE IF NOT EXISTS exit_customer
(
	Exited INTEGER PRIMARY KEY,
	Exit_category VARCHAR(10)
);

COPY Exit_Customer FROM 'E:\Almabetter course material\Projects\My SQL Project\Bank churn\Exit_Customer.csv' with CSV HEADER;

--First dataset look
SELECT * FROM bank_churn;
SELECT * FROM active_customer;
SELECT * FROM credit_card;
SELECT * FROM exit_customer;


-- Database Size
SELECT pg_size_pretty(pg_database_size('Bank_customer_churn')) AS database_size;

-- Table Sizes
SELECT pg_size_pretty(pg_relation_size('bank_churn'));
SELECT pg_size_pretty(pg_relation_size('active_customer'));
SELECT pg_size_pretty(pg_relation_size('credit_card'));
SELECT pg_size_pretty(pg_relation_size('exit_customer'));

-- Dataset Information
/*
•	RowNumber—corresponds to the record (row) number and has no effect on the output.
•	CustomerId—contains random values and has no effect on customer leaving the bank.
•	Surname—the surname of a customer has no impact on their decision to leave the bank.
•	CreditScore—can have an effect on customer churn, since a customer with a higher credit score is less likely to leave the bank.

Credit score:
•	Excellent: 800–850
•	Very Good: 740–799
•	Good: 670–739
•	Fair: 580–669
•	Poor: 300–579

•	Geography— customer’s location.
•	Gender—gender of the customer.
•	Age—age of the customers.
•	Tenure—refers to the number of years that the customer has been a client of the bank.
•	Balance— amount currently available in the bank.
•	NumOfProducts— refers to the number of products that a customer has purchased through the bank.
•	HasCrCard— denotes whether or not a customer has a credit card. 1 represents credit card holder, 0 represents non credit card holder
•	IsActiveMember— active customers are less likely to leave the bank. 1 represents Active Member, 0 represents Inactive Member
•	EstimatedSalary— an estimate of the salary of the customer.
•	Exited— whether or not the customer left the bank. 0 represents Retain, 1 represents Exit.
*/


-- row count of tables
SELECT COUNT(*) AS Row_Count FROM bank_churn;
SELECT COUNT(*) AS Row_Count FROM active_customer;
SELECT COUNT(*) AS Row_Count FROM credit_card;
SELECT COUNT(*) AS Row_Count FROM exit_customer;


-- column count of bank_churn table
SELECT COUNT(*) AS column_Count
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'bank_churn';


-- Check Dataset Information of bank_churn table 
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'bank_churn';


-- Get column names with data type of bank_churn data 
select column_name,data_type
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='bank_churn';

-- Calculating number of null values in each column
SELECT
    COUNT(CASE WHEN RowNumber IS NULL THEN 1 END) AS RowNumber_null_count,
    COUNT(CASE WHEN CustomerId IS NULL THEN 1 END) AS CustomerId_null_count,
    COUNT(CASE WHEN Surname IS NULL THEN 1 END) AS Surname_null_count,
    COUNT(CASE WHEN CreditScore IS NULL THEN 1 END) AS CreditScore_null_count,
    COUNT(CASE WHEN Geography IS NULL THEN 1 END) AS Geography_null_count,
    COUNT(CASE WHEN Gender IS NULL THEN 1 END) AS Gender_null_count,
    COUNT(CASE WHEN Age IS NULL THEN 1 END) AS Age_null_count,
    COUNT(CASE WHEN Tenure IS NULL THEN 1 END) AS Tenure_null_count,
    COUNT(CASE WHEN Balance IS NULL THEN 1 END) AS Balance_null_count,
    COUNT(CASE WHEN NumOfProducts IS NULL THEN 1 END) AS NumOfProducts_null_count,
    COUNT(CASE WHEN HasCrCard IS NULL THEN 1 END) AS HasCrCard_null_count,
    COUNT(CASE WHEN IsActiveMember IS NULL THEN 1 END) AS IsActiveMember_null_count,
    COUNT(CASE WHEN EstimatedSalary IS NULL THEN 1 END) AS EstimatedSalary_null_count,
    COUNT(CASE WHEN Exited IS NULL THEN 1 END) AS Exited_null_count
FROM bank_churn;
-- No null value found

-- Dropping Unnecessary column like rownumber 
ALTER TABLE bank_churn
DROP COLUMN rownumber;

select * from bank_churn 
limit 10;
-- rownumber column removed



-- Total customers of Bank
SELECT COUNT(*) AS total_customers
FROM bank_churn;

-- Total active members
SELECT COUNT(*) AS active_customers_count
FROM bank_churn
INNER JOIN active_customer
ON bank_churn.IsActiveMember = active_customer.IsActiveMember
WHERE active_customer.active_category = 'Yes';

-- Total In-active members
SELECT COUNT(*) - (SELECT COUNT(*) 
FROM bank_churn
INNER JOIN active_customer
ON bank_churn.IsActiveMember = active_customer.IsActiveMember
WHERE active_customer.active_category = 'Yes') AS in_active_customers_count
FROM bank_churn;

-- Total credit card holders
SELECT COUNT(*) AS credit_card_holders_count
FROM bank_churn
INNER JOIN credit_card
ON bank_churn.hascrcard = credit_card.hascrcard
WHERE credit_card.credit_card = 'Yes';

-- Total non-credit card holders
SELECT COUNT(*) AS non_credit_card_holders_count
FROM bank_churn
INNER JOIN credit_card
ON bank_churn.hascrcard = credit_card.hascrcard
WHERE credit_card.credit_card = 'No';

-- Total customers Exited
SELECT COUNT(*) AS customers_exited_count
FROM bank_churn
INNER JOIN exit_customer
ON bank_churn.exited = exit_customer.exited
WHERE exit_customer.exit_category = 'Yes';

-- Total retained customers 
SELECT COUNT(*) AS customers_retained_count
FROM bank_churn
INNER JOIN exit_customer
ON bank_churn.exited = exit_customer.exited
WHERE exit_customer.exit_category = 'No';

-- Credit score type based on credit score
SELECT creditscore,
CASE 
    WHEN creditscore >= 800 AND creditscore <= 850 THEN 'Excellent'
	WHEN creditscore >= 740 AND creditscore <= 799 THEN 'Very Good'
	WHEN creditscore >= 670 AND creditscore <= 739 THEN 'Good'
	WHEN creditscore >= 580 AND creditscore <= 669 THEN 'Fair'
	ELSE 'Poor'
END AS credit_score_type
FROM bank_churn
LIMIT 5;

-- Customer churn with respect to credit score type
SELECT 
CASE 
    WHEN creditscore >= 800 AND creditscore <= 850 THEN 'Excellent'
	WHEN creditscore >= 740 AND creditscore <= 799 THEN 'Very Good'
	WHEN creditscore >= 670 AND creditscore <= 739 THEN 'Good'
	WHEN creditscore >= 580 AND creditscore <= 669 THEN 'Fair'
	ELSE 'Poor'
END AS credit_score_type,COUNT(CustomerId)AS exit_customer_count
FROM bank_churn
INNER JOIN exit_customer
ON bank_churn.Exited = exit_customer.Exited
WHERE exit_customer.exit_category = 'Yes'
GROUP BY credit_score_type
ORDER BY exit_customer_count DESC;
/* This shows that the customers who have Fair and poor credit score type are more prone to exit bank and 
the customer who have credit score type as Excellent are least expected to exit the bank. */

-- Customer churn with respect to whether the customer is an active member or not
SELECT Active_Category, COUNT(CustomerId)AS exit_customer_count
FROM bank_churn
INNER JOIN exit_customer ON bank_churn.Exited = exit_customer.Exited
INNER JOIN active_customer ON bank_churn.IsActiveMember = active_customer.IsActiveMember
WHERE exit_customer.exit_category = 'Yes'
GROUP BY Active_Category
ORDER BY exit_customer_count DESC;
/* This shows that the customers who are inactive have higher chance to exit bank than the ones who are active. */ 

-- Customer churn with respect to HasCrCard
SELECT credit_card,COUNT(customerId) AS exit_customer_count
FROM bank_churn
INNER JOIN exit_customer ON bank_churn.Exited = exit_customer.Exited
INNER JOIN credit_card ON bank_churn.HasCrCard = credit_card.HasCrCard
WHERE exit_customer.exit_category = 'Yes'
GROUP BY credit_card
ORDER BY exit_customer_count DESC;
/* Customers who have credit card are more likely to exit bank as compared to who don't have credit card. */

-- Customer churn with respect to Geography
SELECT geography,COUNT(customerId) AS exit_customer_count
FROM bank_churn
INNER JOIN exit_customer 
ON bank_churn.Exited = exit_customer.Exited
WHERE exit_customer.exit_category = 'Yes'
GROUP BY geography
ORDER BY exit_customer_count DESC;
/* Customers from Germany and France are most likely to exit the bank. */

-- Customer churn with respect to Number of products
SELECT NumOfProducts,COUNT(customerId) AS exit_customer_count
FROM bank_churn
INNER JOIN exit_customer 
ON bank_churn.Exited = exit_customer.Exited
WHERE exit_customer.exit_category = 'Yes'
GROUP BY NumOfProducts
ORDER BY exit_customer_count DESC;
/* Customers who avail only 1 product are most likely to exit the bank. */

-- Customer churn with respect to Tenure
SELECT Tenure,COUNT(customerId) AS exit_customer_count
FROM bank_churn
INNER JOIN exit_customer 
ON bank_churn.Exited = exit_customer.Exited
WHERE exit_customer.exit_category = 'Yes'
GROUP BY Tenure
ORDER BY exit_customer_count DESC
LIMIT 5;
/* Customers who have a tenure of 1 year are most likely to exit the bank. */

-- Customer churn with respect to age group
WITH CTE_1 AS
(
	SELECT *,
CASE 
    WHEN age >= 18 AND age <= 20 THEN '18-20'
	WHEN age >= 21 AND age <= 30 THEN '21-30'
	WHEN age >= 31 AND age <= 40 THEN '31-40'
	WHEN age >= 41 AND age <= 50 THEN '41-50'
	WHEN age >= 51 AND age <= 60 THEN '51-60'
	ELSE '>60'
END AS age_group
FROM bank_churn
)

SELECT age_group,COUNT(CustomerId)AS exit_customer_count
FROM CTE_1
INNER JOIN exit_customer
ON CTE_1.Exited = exit_customer.Exited
WHERE exit_customer.exit_category = 'Yes'
GROUP BY age_group
ORDER BY exit_customer_count DESC;
/* Customers in the age group of 41-50 are most likely to exit the bank. */

-- Customer churn with respect to balance group
WITH CTE_1 AS
(
	SELECT *,
CASE 
    WHEN balance >= 0 AND balance <= 100000 THEN '0-100000'
	WHEN balance >= 100001 AND balance <= 150000 THEN '100000-150000'
	WHEN balance >= 150001 AND balance <= 200000 THEN '150001-200000'
	WHEN balance >= 200001 AND balance <= 250000 THEN '200001-250000'
	ELSE '>250000'
END AS balance_group
FROM bank_churn
)
,CTE_2 AS 
(
SELECT balance_group,COUNT(CustomerId)AS exit_customer_count,
	DENSE_RANK() OVER(ORDER BY COUNT(CustomerId) DESC) AS rank
FROM CTE_1
INNER JOIN exit_customer
ON CTE_1.Exited = exit_customer.Exited
WHERE exit_customer.exit_category = 'Yes'
GROUP BY balance_group
)

SELECT balance_group, exit_customer_count
FROM CTE_2
WHERE rank = 1;
/* Customers in the balance group 100000-150000 are most likely to exit the bank. */

-- Customer churn with respect to Gender
SELECT Gender,COUNT(customerId) AS exit_customer_count
FROM bank_churn
INNER JOIN exit_customer 
ON bank_churn.Exited = exit_customer.Exited
WHERE exit_customer.exit_category = 'Yes'
GROUP BY Gender
ORDER BY exit_customer_count DESC;
/* Female customers are more likely to exit the bank in comparison to male customers. */

/* Since Female customers are having more tendency to exit the bank, so now studying the effect of other parameters
on the female customers churn */


-- Effect of Geography leading to Female customers churn
CREATE EXTENSION tablefunc;

SELECT Gender,France,Germany,Spain
FROM CROSSTAB('SELECT Gender 
    			, Geography
    			, COUNT(customerId) as exit_customer_count
    			FROM Bank_churn 
    			INNER JOIN exit_customer
                ON Bank_churn.Exited = exit_customer.Exited
                WHERE exit_customer.exit_category = ''Yes'' AND gender = ''Female''
    			GROUP BY Gender,Geography
    			ORDER BY Gender,Geography',
            'VALUES (''France''), (''Germany''), (''Spain'')')
    AS final_result(Gender VARCHAR, France BIGINT, Germany BIGINT, Spain BIGINT);
/* Female Customers who are from France are most likely to exit bank. */

-- Effect of credit score type and Geography leading to female customers churn
CREATE TEMPORARY TABLE credit_score AS
(SELECT *,
CASE 
    WHEN creditscore >= 800 AND creditscore <= 850 THEN 'Excellent'
	WHEN creditscore >= 740 AND creditscore <= 799 THEN 'Very Good'
	WHEN creditscore >= 670 AND creditscore <= 739 THEN 'Good'
	WHEN creditscore >= 580 AND creditscore <= 669 THEN 'Fair'
	ELSE 'Poor'
END AS credit_score_type
FROM bank_churn);

	SELECT credit_score_type,France,Germany,Spain
	FROM CROSSTAB('SELECT credit_score_type 
    			, Geography
    			, COUNT(customerId) as exit_customer_count
    			FROM credit_score 
    			INNER JOIN exit_customer
                ON credit_score.Exited = exit_customer.Exited
                WHERE exit_customer.exit_category = ''Yes'' AND gender = ''Female''
    			GROUP BY credit_score_type,Geography
				ORDER BY credit_score_type,Geography',
            'VALUES (''France''), (''Germany''), (''Spain'')')
    AS final_result(credit_score_type VARCHAR, France BIGINT, Germany BIGINT, Spain BIGINT);
/* Female Customers having Fair credit score type and who are from Germany are most likely to exit bank. */

-- Effect of age group and Geography leading to Female customers churn
CREATE TEMPORARY TABLE age_table AS
(	SELECT *,
CASE 
    WHEN age >= 18 AND age <= 20 THEN '18-20'
	WHEN age >= 21 AND age <= 30 THEN '21-30'
	WHEN age >= 31 AND age <= 40 THEN '31-40'
	WHEN age >= 41 AND age <= 50 THEN '41-50'
	WHEN age >= 51 AND age <= 60 THEN '51-60'
	ELSE '>60'
END AS age_group
FROM bank_churn
 );
 
SELECT age_group
, COALESCE(France, 0) AS France
, COALESCE(Germany, 0) AS Germany
, COALESCE(Spain, 0) AS Spain
FROM CROSSTAB('SELECT age_group 
    			, Geography
    			, COUNT(customerId) as exit_customer_count
    			FROM age_table 
    			INNER JOIN exit_customer
                ON age_table.Exited = exit_customer.Exited
                WHERE exit_customer.exit_category = ''Yes'' AND gender = ''Female''
    			GROUP BY age_group,Geography
				ORDER BY age_group,Geography',
            'VALUES (''France''), (''Germany''), (''Spain'')')
    AS final_result(age_group VARCHAR, France BIGINT, Germany BIGINT, Spain BIGINT);
/* Female customers in the age group of 41-50 who are from Germany are most likely to exit bank. */

-- Effect of Tenure and Geography leading to Female customers churn
SELECT Tenure
, COALESCE(France, 0) AS France
, COALESCE(Germany, 0) AS Germany
, COALESCE(Spain, 0) AS Spain
FROM CROSSTAB('SELECT Tenure 
    			, Geography
    			, COUNT(customerId) as exit_customer_count
    			FROM bank_churn 
    			INNER JOIN exit_customer
                ON bank_churn.Exited = exit_customer.Exited
                WHERE exit_customer.exit_category = ''Yes'' AND gender = ''Female''
    			GROUP BY Tenure,Geography
				ORDER BY Tenure,Geography',
            'VALUES (''France''), (''Germany''), (''Spain'')')
    AS final_result(Tenure VARCHAR, France BIGINT, Germany BIGINT, Spain BIGINT);
/* Female customers with a tenure of 1 year and who are from Germany are most likely to exit bank. */

-- Effect of number of products and Geography leading to Female customers churn
SELECT NumOfProducts,France,Germany,Spain
	FROM CROSSTAB('SELECT NumOfProducts 
    			, Geography
    			, COUNT(customerId) as exit_customer_count
    			FROM bank_churn 
    			INNER JOIN exit_customer
                ON bank_churn.Exited = exit_customer.Exited
                WHERE exit_customer.exit_category = ''Yes'' AND gender = ''Female''
    			GROUP BY NumOfProducts,Geography
				ORDER BY NumOfProducts,Geography',
            'VALUES (''France''), (''Germany''), (''Spain'')')
    AS final_result(NumOfProducts VARCHAR, France BIGINT, Germany BIGINT, Spain BIGINT);
/* Female customers with a number of products as 1 and who are from Germany are most likely to exit bank. */

-- Effect of having credit card and Geography leading to Female customers churn
SELECT Credit_card,France,Germany,Spain
	FROM CROSSTAB('SELECT Credit_card 
    			, Geography
    			, COUNT(customerId) as exit_customer_count
    			FROM bank_churn 
    			INNER JOIN exit_customer ON bank_churn.Exited = exit_customer.Exited
				INNER JOIN credit_card ON bank_churn.HasCrCard = credit_card.HasCrCard
                WHERE exit_customer.exit_category = ''Yes'' AND gender = ''Female''
    			GROUP BY Credit_card,Geography
				ORDER BY Credit_card,Geography',
            'VALUES (''France''), (''Germany''), (''Spain'')')
    AS final_result(Credit_card VARCHAR, France BIGINT, Germany BIGINT, Spain BIGINT);
/* Female customers with credit card and who are from France are most likely to exit bank. */

-- Effect of active customer status and Geography leading to Female customers churn
SELECT Active_Category,France,Germany,Spain
	FROM CROSSTAB('SELECT Active_Category 
    			, Geography
    			, COUNT(customerId) as exit_customer_count
    			FROM bank_churn 
    			INNER JOIN exit_customer ON bank_churn.Exited = exit_customer.Exited
				INNER JOIN active_customer ON bank_churn.IsActiveMember = active_customer.IsActiveMember
                WHERE exit_customer.exit_category = ''Yes'' AND gender = ''Female''
    			GROUP BY Active_Category,Geography
				ORDER BY Active_Category,Geography',
            'VALUES (''France''), (''Germany''), (''Spain'')')
    AS final_result(Active_Category VARCHAR, France BIGINT, Germany BIGINT, Spain BIGINT);
/* Female customers who are not active members and who are from France are most likely to exit bank. */

-- Effect of balance group and Geography leading to Female customers churn
CREATE TEMPORARY TABLE balance_table AS
(	SELECT *,
CASE 
    WHEN balance >= 0 AND balance <= 100000 THEN '0-100000'
	WHEN balance >= 100001 AND balance <= 150000 THEN '100000-150000'
	WHEN balance >= 150001 AND balance <= 200000 THEN '150001-200000'
	WHEN balance >= 200001 AND balance <= 250000 THEN '200001-250000'
	ELSE '>250000'
END AS balance_group
FROM bank_churn
 );
 
SELECT balance_group
, COALESCE(France, 0) AS France
, COALESCE(Germany, 0) AS Germany
, COALESCE(Spain, 0) AS Spain
FROM CROSSTAB('SELECT balance_group 
    			, Geography
    			, COUNT(customerId) as exit_customer_count
    			FROM balance_table 
    			INNER JOIN exit_customer
                ON balance_table.Exited = exit_customer.Exited
                WHERE exit_customer.exit_category = ''Yes'' AND gender = ''Female''
    			GROUP BY balance_group,Geography
				ORDER BY balance_group,Geography',
            'VALUES (''France''), (''Germany''), (''Spain'')')
    AS final_result(balance_group VARCHAR, France BIGINT, Germany BIGINT, Spain BIGINT);
/* Female customers with account balance between 100000 and 150000 and who are from Germany are most likely to exit bank. */
 
 
 
 -- Insights 
/*
1.  The customers who have Fair and poor credit score type are more prone to exit bank and 
    the customer who have credit score type as Excellent are least expected to exit the bank.
2.  The customers who are inactive have higher chance to exit bank than the ones who are active.
3.  Customers who have credit card are more likely to exit bank as compared to who don't have credit card.
4.  Customers from Germany and France are most likely to exit the bank.
5.  Customers who avail only 1 product are most likely to exit the bank.
6.  Customers who have a tenure of 1 year are most likely to exit the bank.
7.  Customers in the age group of 41-50 are most likely to exit the bank.
8.  Customers in the balance group 100000-150000 are most likely to exit the bank.
9.  Female customers are more likely to exit the bank in comparison to male customers.
10. Female Customers who are from France are most likely to exit bank.
11. Female Customers having Fair credit score type and who are from Germany are most likely to exit bank.
12. Female customers in the age group of 41-50 who are from Germany are most likely to exit bank.
13. Female customers with a tenure of 1 year and who are from Germany are most likely to exit bank.
14. Female customers with a number of products as 1 and who are from Germany are most likely to exit bank.
15. Female customers with credit card and who are from France are most likely to exit bank.
16. Female customers who are not active members and who are from France are most likely to exit bank.
17. Female customers with account balance between 100000 and 150000 and who are from Germany are most likely to exit bank.
*/
 
-- Recommendations
/*
1. Target customers with Fair or Poor credit scores. These customers are more likely to churn, 
so it is important to focus on keeping them satisfied. This could involve offering them special incentives, 
such as discounts on interest rates or fees.

2. Offer incentives to inactive customers. Inactive customers are more likely to churn, 
so it is important to try to get them engaged again. 
This could involve sending them personalized emails or phone calls, or offering them special promotions.

3. Provide additional benefits to customers with credit cards. Customers with credit cards are more likely to churn, 
so it is important to provide them with additional benefits, such as rewards programs or extended warranties.

4. Focus on marketing to customers in Germany and France. These countries have the highest churn rates, 
so it is important to focus on marketing to customers in these areas. 
This could involve creating marketing materials that are specific to these countries, 
or running targeted advertising campaigns.

5. Offer more products and services to customers who only use one product. 
Customers who only use one product are more likely to churn, so it is important to offer them more options.
This could involve offering them additional products, such as loans or investments, 
or providing them with access to more services, such as online banking or mobile banking.

6. Reach out to customers who have been with the bank for 1 year. 
Customers who have been with the bank for a certain number of years are more likely to churn, 
so it is important to reach out to them and see if there is anything the bank can do to keep them as customers. 
This could involve sending them a personalized email or phone call, or offering them a special promotion.

7. Target customers in the age group of 41-50 and with a balance of 100,000-150,000. 
These customers are more likely to churn, so it is important to target them specifically. 
This could involve offering them special products or services, or reaching out to them personally.

8. Churn rate is higher for female customers in comparison to male customers. so, Understand the needs of female customers,
Women often have busy lives and need banks that offer flexible banking options, such as online banking,
mobile banking, and ATMs. Women are often on a budget, so it is important to offer competitive rates 
and fees on products and services.
*/

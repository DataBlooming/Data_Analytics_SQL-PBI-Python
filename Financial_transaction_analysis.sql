CREATE DATABASE "Financial_Transaction";

-- The dataset is aviliable on Kaggel:
-- https://www.kaggle.com/datasets/computingvictor/transactions-fraud-datasets?resource=download&select=users_data.csv

-- There are three datasets: cards dataset, users dataset, and transaction dataset.
-- To run smoothier, we only sample 10000 data points from the original dataset.

USE Financial_Transaction;

-- I. basic exploration on card dataset
-- How many card brands are involved?
SELECT card_brand, 
		COUNT(*) AS card_brand_count 
FROM dbo.cards_data
GROUP BY card_brand;

-- How many card types are involved?
SELECT card_type,
		COUNT(*) AS card_type_count
FROM dbo.cards_data
GROUP BY card_type;

-- How many cards have chip?
SELECT has_chip,
		COUNT(*) AS chip_count
FROM dbo.cards_data
GROUP BY has_chip;

-- How many clients do we have?
SELECT COUNT(DISTINCT client_id) AS number_clients FROM dbo.cards_data;

-- How many cards have been issued?
SELECT COUNT(id) AS cards_count FROM dbo.cards_data;

-- How many cards are related to dark web?
SELECT card_on_dark_web,
		COUNT(*) AS dark_web_count 
		FROM dbo.cards_data
		GROUP BY card_on_dark_web;



-- II. basic exploration on user dataset
-- What are the differences between female and male clients?
SELECT 
    gender,
    SUM(yearly_income) AS total_income,
    SUM(total_debt) AS total_debt,
    SUM(credit_score) AS total_credit_score,
    AVG(yearly_income) AS avg_income,
    AVG(total_debt) AS avg_debt,
    AVG(credit_score) AS avg_credit_score
FROM dbo.users_data
GROUP BY gender;

-- Does the number of credit cards affect the credit scores?
SELECT 
    num_credit_cards,
    SUM (credit_score) AS total_credit_score,
    SUM(yearly_income) AS total_income,
    SUM(total_debt) AS total_debt
FROM dbo.users_data
GROUP BY num_credit_cards;

-- III. basic exploration on transaction dataset
-- What kinds of transaction are involved?
SELECT use_chip,
        COUNT(amount) AS total_amount
FROM dbo.Transaction_data10000
GROUP BY use_chip;

-- Which states have the highest number of transactions?
SELECT merchant_state,
        COUNT(amount) AS total_amount
FROM dbo.Transaction_data10000
GROUP BY merchant_state
ORDER BY total_amount DESC;

-- Who are the top 10 clients?
SELECT TOP 10 client_id,
        SUM(amount) AS total_amount
FROM dbo.Transaction_data10000
GROUP BY client_id
ORDER BY total_amount DESC;

-- IV. Cross-table analysis
-- Total transaction amount by card type
SELECT c.card_type, c.card_brand, SUM(t.amount ) as total_amount
FROM dbo.cards_data c
JOIN dbo.Transaction_data10000 t ON c.client_id = t.client_id
GROUP BY c.card_type, c.card_brand
ORDER BY total_amount DESC;

-- What characteristics do the top 10 clients have?
SELECT TOP 10 
    t.client_id,
    t.amount,
    t.merchant_state,
    u.gender,
    u.yearly_income,
    u.total_debt,
    u.credit_score,
    c.card_brand,
    c.card_type,
    c.num_cards_issued
FROM dbo.Transaction_data10000 t
JOIN dbo.users_data u ON t.client_id = u.id
JOIN dbo.cards_data c ON t.card_id = c.id
ORDER BY t.amount DESC;

-- Which states have the highest total transaction amount?
SELECT t.merchant_state,
       SUM(t.amount) AS total_amount,
       COUNT(t.id) AS num_transactions
FROM dbo.Transaction_data10000 t
GROUP BY t.merchant_state
ORDER BY total_amount DESC;

-- How many transactions involve cards that appeared on the dark web?
SELECT c.card_on_dark_web,
       COUNT(t.id) AS num_transactions,
       SUM(t.amount) AS total_amount
FROM dbo.Transaction_data10000 t
JOIN dbo.cards_data c ON t.card_id = c.id
GROUP BY c.card_on_dark_web;

-- How do male and female clients differ in transaction behavior?
SELECT u.gender,
       COUNT(t.id) AS num_transactions,
       SUM(t.amount) AS total_amount,
       AVG(t.amount) AS avg_amount
FROM dbo.Transaction_data10000 t
JOIN dbo.users_data u ON t.client_id = u.id
GROUP BY u.gender;

-- Who are the risky clients based on their debt-to-income ratio?
SELECT 
    CASE 
        WHEN CAST(total_debt AS FLOAT) / NULLIF(yearly_income, 0) < 0.3 THEN 'Low'
        WHEN CAST(total_debt AS FLOAT) / NULLIF(yearly_income, 0) < 0.6 THEN 'Medium'
        ELSE 'High'
    END AS debt_income_ratio,
    COUNT(*) AS client_count,
    AVG(credit_score) AS avg_credit_score
FROM dbo.users_data
GROUP BY 
    CASE 
        WHEN CAST(total_debt AS FLOAT) / NULLIF(yearly_income, 0) < 0.3 THEN 'Low'
        WHEN CAST(total_debt AS FLOAT) / NULLIF(yearly_income, 0) < 0.6 THEN 'Medium'
        ELSE 'High'
    END;

-- What is the credit utilization of each client? 
SELECT c.client_id,
       c.id AS card_id,
       c.credit_limit,
       ISNULL(SUM(t.amount), 0) AS total_used,
       ISNULL(SUM(t.amount), 0) / NULLIF(c.credit_limit, 0) AS utilization_ratio,
       CASE 
           WHEN ISNULL(SUM(t.amount), 0) / NULLIF(c.credit_limit, 0) > 0.8 
           THEN 'HIGH RISK' 
           ELSE 'NORMAL' 
       END AS utilization_flag
FROM dbo.cards_data c
LEFT JOIN dbo.Transaction_data10000 t 
       ON c.id = t.card_id
GROUP BY c.client_id, c.id, c.credit_limit
ORDER BY utilization_ratio DESC;



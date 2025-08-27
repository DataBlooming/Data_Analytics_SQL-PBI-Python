# Project Overview: 
## Credit Card User Profiling & Transaction Analysis Dashboard

This project builds an interactive Power BI dashboard on top of three core datasets: User Data, Card Data, and Transaction Data. Using SQL modeling and Power BI visualization, it provides insights into user profiles, card usage, transaction patterns, and credit risk evaluation.

## Data Sources
User Data: demographic and financial information (age, gender, income, debt, credit score)
Card Data: card attributes (brand, type, credit limit, expiration)
Transaction Data: transaction records (amount, merchant, timestamp, chip usage)

## Data Modeling
User ↔ Card: linked by client_id (one-to-many)
Card ↔ Transaction: linked by card_id (one-to-many)
Removed direct User ↔ Transaction link to maintain a star schema structure

## Key Metrics
Debt-to-Income Ratio (DTI) = total debt / yearly income
Credit Utilization = transaction amount / credit limit

Risk Segmentation by DTI:
Low: DTI ≤ 0.3
Medium: 0.3 < DTI ≤ 0.6
High: DTI > 0.6

Risk Segmentation by Credit Utilization:
Safe: Credit Utilization ≤ 0.8
Risky: Credit Utilization > 0.8

## Data_Analytics_SQL-PBI-Python/
'''
├── README.md # Project documentation (this file)
├── {Financial_transaction_analysis.sql} # SQL queries for data extraction & transformation
└── dashboards/ # Directory for visualization exports
    ├── Overview.png # Overview Dashboard
    ├── Clients Analysis.png # Customer Analysis Dashboard
    └── Risk Analysis.png # Transaction Trends Dashboard
'''
'''

## Tech Stack & Tools
- **SQL**: Data extraction, transformation, and loading (ETL)
- **Power BI**: Data modeling, DAX, and interactive visualization
- **GitHub**: Version control and project hosting

### 1. Overview Dashboard
![Overview Dashboard](https://github.com/DataBlooming/Data_Analytics_SQL-PBI-Python/blob/main/dashboards/Overview.png)

### 2. Customer Analysis
![Customer Analysis Dashboard](https://github.com/DataBlooming/Data_Analytics_SQL-PBI-Python/blob/main/dashboards/Clients%20Analysis.png)

### 3. Risk Analysis
![Risk Analysis Dashboard](https://github.com/DataBlooming/Data_Analytics_SQL-PBI-Python/blob/main/dashboards/Risk%20Analysis.png)

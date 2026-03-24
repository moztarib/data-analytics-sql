# Project: Sales & Profitability Analysis with SQL and Python 

### A SQL Analytics Project using SuperStore Global Sales Data

![SQL](https://img.shields.io/badge/SQL-SQLite-blue)
![Python](https://img.shields.io/badge/Python-pandas-yellow)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)


## Project Overview

This project analyses 51,290 sales transactions from a global retail business spanning 4 years (2011-2014) across 13 regions worldwide.

The central business question driving this analysis:

> **Which products, regions and customer segments are driving profit —
> and which are quietly losing money despite high sales?**

## Dataset

- **Source:** [Sample SuperStore Dataset — Kaggle](https://www.kaggle.com/datasets/thuandao/superstore-sales-analytics)
- **Records:** 51,290 order line items
- **Period:** January 2011 — December 2014
- **Regions:** 13 global regions
- **Products:** 10,292 unique products across 3 categories
- **Customers:** 795 unique customers

## Database Schema

The raw CSV was normalized into a star schema with 1 fact table
and 3 dimension tables:
```
dim_customers ──┐
                ├──▶ fact_orders ◀── dim_products
dim_location  ──┘
```

| Table | Description | Key Columns |
|---|---|---|
| `fact_orders` | One row per order line item | sales, profit, discount, quantity |
| `dim_customers` | 795 unique customers | customer_name, segment |
| `dim_products` | 10,292 unique products | product_name, category, sub_category |
| `dim_locations` | 1,126 unique locations | region, market, country, state |

## Key Findings

### Profitability Overview
- Total revenue of **$7,835,128** generated across 4 years with a **18.75% profit margin**
- **2013 came out as the strongest growth year** with 32.89% Year-on-Year profit growth

### Regional Performance
- **Central region leads** in both total revenue geenrated and the total profit made
- **Southeast Asia** has the weakest profit margin despite $532,172 in revenue

### Product Performance
- **Tables is the only sub-category under loss** — losing ~$64,000 in profit despite generating $289,686 in sales revenue
- **674 products actively lose money** which is 7% of the entire product catalogue

### Customer Insights
- **373 VIP customers** (revenue > $10,000) and **399 Loyal customers** form the entire base
- Zero occasional customers which suggests a **B2B focused business model**

## Technical Skills Demonstrated

- Database design: star schema normalization with fact and dimension tables
- Customer and product segmentation: CASE WHEN classification logic
- Advanced SQL: CTEs, subqueries, LAG(), RANK(), DENSE_RANK()
- Data pipeline development: CSV ingestion, cleaning and database connection/load with pandas
- Exploratory data analysis (EDA): profiling scale, range and quality of data

## Tools & Technologies

SQL (SQLite), Python, Jupyter Notebook, pandas, SQLAlchemy, ipython-sql, VS Code, Git & GitHub

## Repository Structure
```
data-analytics-sql/
│
├── datasets/
│   └── superstore.csv          ← source data (download from Kaggle link above)
│
├── notebooks/
│   └── 01_load_data.ipynb      ← data pipeline: CSV → star schema database
│
├── scripts/
│   ├── schema_documentation.txt    ← auto-generated database schema
│   ├── 02_exploratory_analysis.sql
│   ├── 03_time_series_analysis.sql
│   ├── 04_cumulative_analysis.sql
│   ├── 05_segmentation.sql
│   ├── 06_advanced_analytics.sql
│   └── 07_reports.sql
│
└── README.md
```
## How to Run

1. Clone this repository
2. Download the dataset from the Kaggle link above and place it in `datasets/`
3. Install required libraries:
```
   pip install pandas sqlalchemy ipython-sql prettytable jupyter
```
4. Open and run `notebooks/01_load_data.ipynb` — this establishes the connection and builds the database 
5. Open any `.sql` file in `scripts/` and copy queries into the notebook 
   using `%%sql` to see results

## Author
**Faris Beg**, 2026

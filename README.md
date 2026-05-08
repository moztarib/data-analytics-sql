# Sales & Profitability Analysis — SQL and Python

### A SQL Analytics Project using SuperStore Global Sales Data

![SQL](https://img.shields.io/badge/SQL-SQLite-blue)
![Python](https://img.shields.io/badge/Python-pandas-yellow)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)

---

## Business Questions

Four questions drive this analysis: Which products and regions generate the most profit, and which lose money despite strong sales? How has profitability grown year over year? Which customers represent the highest value? And do discount patterns explain the gap between high revenue and low profit in certain areas?

---

## Project Overview

51,290 sales transactions from a global retail business across 13 regions and four years (January 2011 to September 2014). The raw CSV is ingested via a Python pipeline, normalised into a star schema using pandas and SQLite, then interrogated with SQL from basic aggregations through to window functions and CTEs. The goal is to extract findings, using propoer syntax, that a business can act on.

---

## Tools and Technologies

SQL (SQLite), Python, Jupyter Notebook, pandas, Matplotlib, SQLAlchemy, ipython-sql, VS Code, Git and GitHub.

---

## Technical Skills Demonstrated

| Skill | Detail |
|---|---|
| Database Design | Star schema: one fact table joined to three dimension tables |
| Data Pipeline | CSV ingestion, cleaning and loading via pandas and SQLite API |
| Exploratory Analysis | Profiling scale, date range and profit at the business level |
| Time Series | Monthly and yearly revenue trends using SQLite date functions |
| Cumulative Analysis | Running totals and year-reset revenue using window functions |
| Segmentation | Customer and product classification using CASE WHEN |
| Advanced SQL | CTEs, LAG() for YoY growth, RANK() and DENSE_RANK() |
| Reporting | Consolidated CREATE VIEW reports for customers and products |

---

## Database Schema

The flat CSV is normalised into a star schema. A central fact table holds all measurable values; three dimension tables hold descriptive attributes.

```
dim_customers ──┐
                ├──> fact_orders <── dim_products
dim_locations ──┘
```

| Table | Key Columns |
|---|---|
| `dim_customers` | customer_id (PK), customer_name, segment |
| `dim_products` | product_id (PK), product_name, category, sub_category |
| `dim_locations` | location_id (PK), region, market, country, state |
| `fact_orders` | order_id, dates, sales, profit, discount + customer_id (FK), product_id (FK), location_id (FK) |

---

## Key Findings

The business generated $7.84M in revenue and $1.47M in profit over four years, at an 18.75% overall margin.

Technology leads on margin at 25.16%. Furniture makes the second highest revenue ($2.41M) but holds only an 11.92% margin which may indicate a discounting problem instead of a demand problem. Tables is the only loss-making sub-category: $289,686 in sales yet a $64,083 loss in profit.

Regionally, Central leads with $311,403 in profit. Southeast Asia generates $532,000 in revenue but retains only $17,852 in profit, a 3.3% margin that is barely break-even. EMEA has a similar pattern at 7.6%.

Profit grew every year, with 2013 the strongest at 32.89% year-over-year growth. 2014 shows 23.41% growth across nine months only.

Of 795 customers, 373 are VIP and 399 are Loyal. There are zero occasional customers, which strongly suggests a B2B business model where losing a single VIP has an outsized revenue impact.

November and December consistently dominate monthly revenue across all four years.

---

## Conclusions

Tables needs a pricing intervention. A $64,083 loss on $290,000 in sales indicates a margin problem. Southeast Asia and EMEA both need a discount policy review. Customer retention matters more than acquisition here since the base is already high value. While the core business model is healthy, our analysis reveals that the problems are specific and addressable.

---

## How to Run

Clone the repository and download the dataset from the Kaggle link below, placing it in `datasets/`. Install dependencies with `pip install pandas sqlalchemy ipython-sql prettytable jupyter`, then run `notebooks/00_load_data.ipynb` from top to bottom to build the database. Copy any query from `scripts/` into a notebook cell using `%%sql` to see results.

**Dataset:** [Sample SuperStore — Kaggle](https://www.kaggle.com/datasets/thuandao/superstore-sales-analytics)

---

## Repository Structure

```
data-analytics-sql/
├── datasets/superstore.csv
├── notebooks/00_load_data.ipynb
└── scripts/
    ├── 01_database_schema.sql
    ├── 02_exploratory_analysis.sql
    ├── 03_time_series_analysis.sql
    ├── 04_cumulative_analysis.sql
    ├── 05_segmentation.sql
    ├── 06_advanced_analytics.sql
    └── 07_reports.sql
```

---

## Author

Faris Beg, 2026

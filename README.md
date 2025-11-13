# 🏪 Superstore Data Analysis Project

# 📋 Overview

This project focuses on analyzing Superstore sales data to uncover insights related to orders, customers, products, shipping, and financial performance.

l started with a flat dataset containing over 30 columns and normalized it into multiple relational tables up to Third Normal Form (3NF).
The goal was to ensure data consistency, eliminate redundancy, and make it easier to run analytical queries.

The data visualizations were created to showcase key insights derived from the Superstore dataset. These visuals were built from SQL query outputs and then presented using slides to communicate trends and business performance.

# 🎯 Objectives

Normalize data from a flat dataset into 3NF.

Load the normalized tables into a PostgreSQL database.

Use SQL queries to analyze key business metrics.

Identify top-performing products, customers, and regions.

Present findings in a simple data report or dashboard.


1️⃣ Sales & Revenue Analysis

Highest Sales Month: November — peak likely due to holiday season and year-end promotions.

Top Products by Revenue: Technology and Office Supplies (e.g., Phones, Chairs).

Top Region: The West region leads in total sales due to strong customer base and high population density.

2️⃣ Profitability Analysis

Most Profitable Subcategories: Copiers and Phones.

Loss-Making Products: Machines, Binders, and Tables (mainly from high discounting).

Discount vs Profit: A negative relationship — higher discounts reduce profit margins.

Most Profitable Customer Segment: Consumer segment contributes the most profit.


3️⃣ Customer Behavior

Top 20 Customers: Concentrated in the Consumer and Corporate segments.

Repeat Buyers: High customer loyalty indicated by multiple repeat purchases.

High-Value Customers: Some (like Mitch) make fewer but higher-value orders, critical for profitability.

Discount Impact: Corporate customers receive higher discounts, lowering margins slightly.


4️⃣ Shipping & Delivery Analysis

Most Used Shipping Mode: Standard Class — preferred for its balance between cost and delivery time.

Shipping Time by Region: Varies, but most orders are fulfilled earlier in the month.

Shipping Mode Profit: Standard Class also leads in profitability.

5️⃣ Product & Order Trends

Seasonality: Sales peak from October to December, with another rise in March (start-of-year restocking).

Bulk Orders: Machines and Bookcases often ordered in bulk by business clients.

Common Product Pairs: Tables & Chairs, Papers & Binders, Copiers & Machines.

Regional Preferences:

East & South: Tech products dominate.

West: Balanced between Technology and Furniture.

Office Supplies: Highest volume but lowest revenue due to low prices.


# 🗂 Database Design

The database was designed with normalization in mind to ensure efficiency, accuracy, and integrity of data.


# ⚙️ Setup Instructions
superstore-data-analysis

1. **Clone the Repository**
   ```bash
   git clone https://github.com/mthimkulu23/Superstore-Data-Cleaning.git
   cd superstore-data-analysis

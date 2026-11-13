# Duka Smart Electronics: Retail Sales and Customer Analysis

Duka Smart Electronics is a growing Kenyan retailer selling phones, laptops, accessories, TVs, and home appliances across Nairobi, Mombasa, Kisumu, Nakuru, Eldoret, Thika, Nyeri, Meru, Machakos, and Kiambu. The business has traded since January 2025 and records its orders in a database, but had not yet analyzed its sales.

This project uses PostgreSQL to turn customer and order records into practical findings for management: who the best customers are, which product categories generate revenue and profit, how sales vary over time, and which customers may have stopped buying.

## Project goals

- Identify high-spending customers and compare spending across customer segments.
- Analyze revenue, cost, profit, and profit margin by product category.
- Find top-performing months, products, and customer cities.
- Measure order activity, including cancelled orders and customers with no orders.
- Identify potentially inactive customers for follow-up.

## Database and metrics

The schema defines two related tables:

- `customers`: customer ID, name, gender, city, registration date, and segment (`Retail`, `Corporate`, or `VIP`).
- `orders`: order and customer IDs, date, product and category, quantity, unit and cost prices, discount, payment method, and order status.

Orders reference customers by `customer_id`. The schema also adds indexes on order date and customer ID.

Revenue calculations in the analysis use completed orders and apply the order discount as a percentage:

```text
net revenue = quantity × unit price × (1 − discount / 100)
total cost   = quantity × cost price
profit       = net revenue − total cost
profit margin = profit / net revenue × 100
```

Other queries intentionally use all order statuses when measuring total order counts, cancellation rates, or price ranges. Check each query's status filter when interpreting its results.

## Analysis and findings

[`queries.sql`](./queries.sql) contains 37 complete analysis queries covering SQL fundamentals, aggregation, customer joins, subqueries and CTEs, and window functions. 

The current findings, documented in [`insights.md`](./insights.md), include:

- Nairobi accounts for 48 of 150 customers (32%), making it the largest customer market in the analyzed dataset.
- Average VIP customer spending is approximately KSh 89,676.67 higher than average Retail customer spending.
- August 2026 was the strongest revenue month at approximately KSh 2.24 million, followed by September and June.
- Accessories generated approximately KSh 1.08 million in revenue with a 42.39% profit margin, suggesting an opportunity to grow sales while protecting margins.
- The inactivity query flags customers whose latest completed order was more than 90 days before the latest order date in the dataset.

These are dataset-specific results, not guaranteed ongoing trends. Management should validate them against refreshed data before making decisions.

## Run the SQL

Requirements: PostgreSQL and a populated database with the expected customer and order records.

1. Create a database, for example:

   ```sh
   createdb retail_analytics
   ```

2. Create the tables and indexes:

   ```sh
   psql -d retail_analytics -f schema.sql
   ```

3. Load the source data into `customers` and `orders`. This repository does not include a data-import script or source dataset.

4. Run the analysis queries:

   ```sh
   psql -d retail_analytics -f queries.sql
   ```

The scripts use PostgreSQL features including `DATE_TRUNC`, CTEs, `LIMIT`, window functions.

## Repository files

- [`schema.sql`](./schema.sql) — table definitions, constraints, relationships, and indexes.
- [`queries.sql`](./queries.sql) — business analysis queries.
- [`insights.md`](./insights.md) — summarized findings and recommendations.
- [`screenshots/`](./screenshots/) — selected query-result screenshots.

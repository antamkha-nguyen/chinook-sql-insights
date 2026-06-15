# Chinook: SQL Business Insights

## Overview

This project contains SQL queries written against the **Chinook** database, a sample database that simulates a digital music store. The queries answer real business questions around sales performance, customer behavior and catalog insights.

All queries are written in **SQLite** and executed using **DBeaver**.

---

## About the Chinook Database

The Chinook database was created by **Luis Rocha** as a modern, open-source alternative to Microsoft's Northwind sample database. It models a fictional digital music store, similar to an early version of iTunes where customers from over 20 countries purchase tracks and albums across a wide range of genres.

> The database schema diagram is included in the `/schema` folder.

## Business Questions & Queries

### Store Performance & Sales Insights
*File: `store_performance.sql`*

- What are the top 10 best-selling tracks by units sold?
- Which countries generate the most revenue?
- Which sales rep has generated the most revenue?
- What is the most popular genre by number of tracks sold?
- What does the monthly revenue trend look like across all time?

### Customer & Catalog Intelligence
*File: `customer_catalog_intelligence.sql`*

- Which customers have spent above the average customer spend?
- How are artists ranked by total revenue generated?
- Which employee manages the most people?
- Which customers have never purchased a Rock track?
- What is the lifetime value of each customer?
- How many tracks does each album have, and who is the artist?

## Reproducing the Results

The Chinook database is an open-source project originally created by **Luis Rocha** and is freely available on GitHub. It comes pre-loaded with sample data so no setup or data import required.

To reproduce the results from this project:

1. Download the Chinook SQLite database from [https://github.com/lerocha/chinook-database](https://github.com/lerocha/chinook-database)
2. Open DBeaver and create a new SQLite connection pointing to the `.db` file
3. Open either `.sql` file and run the queries

## Project Structure

```
chinook-sql-practice/
│
├── README.md
├── schema/
│   └── chinook_schema.png
└── queries/
    ├── store_performance.sql
    └── customer_catalog_intelligence.sql
```

# SQL Project: Bookstore Data Analysis

## Overview

This project involves analyzing data from a bookstore using SQL Server (MSSQL). The analysis covers various aspects, such as customer order behavior, order statuses, author popularity, and delivery times. The goal is to answer specific business-related questions using SQL queries on the provided datasets.

## Project Questions & Solutions

1. **How many books have been ordered by each customer?**
   - Categorizes customers' order volumes as 'Low', 'Medium', or 'High' based on the number of books ordered.

2. **What is the latest status of each order?**
   - Ranks orders by status date to determine the most recent status and stores this in a view.

3. **Rank the customers based on the total price of their orders.**
   - Only includes orders that were not 'Cancelled' or 'Returned'.

4. **Rank the authors by their popularity and categorize them.**
   - Popularity is based on the number of orders, with categories 'Bestseller', 'Popular', and 'Others'.

5. **For each shipping method, rank the countries by the number of orders.**
   - Categorizes the demand as 'High', 'Medium', or 'Low' based on their rank.

6. **Create a temporary table showing the number of books sold by each publisher for each month.**
   - Followed by a pivot table to display monthly sales per publisher.

7. **How many orders have been placed by new vs. returning customers each year?**
   - Differentiates between new and returning customers based on their first order year.

8. **What is the average delivery time for each shipping method?**
   - Calculates the average delivery time based on order and delivery dates.

## SQL Queries

You can find the detailed SQL queries used to answer the above questions in the provided script files.

## Data Files

The project relies on several CSV files containing the bookstore's data. These files include:

- **address.csv**: Contains address details.
- **address_status.csv**: Status information related to addresses.
- **author.csv**: Information about authors.
- **book.csv**: Details of books available.
- **book_author.csv**: Mapping between books and their respective authors.
- **book_language.csv**: Information about the languages of the books.
- **country.csv**: Details of countries associated with addresses.
- **cust_order.csv**: Customer orders.
- **customer.csv**: Information about customers.
- **customer_address.csv**: Mapping between customers and their addresses.
- **order_history.csv**: Historical status changes of orders.
- **order_line.csv**: Line items associated with each order.
- **order_status.csv**: Status codes and descriptions for orders.
- **publisher.csv**: Information about book publishers.
- **shipping_method.csv**: Details of available shipping methods.

## How to Run

1. **Set up the database**: Load the provided CSV files into your MSSQL environment.
2. **Execute Queries**: Run the SQL scripts to generate the views, temporary tables, and perform the analysis.
3. **Analyze Results**: Review the outputs to gain insights into customer behavior, order statuses, author popularity, etc.

## Contact

For any questions or feedback, feel free to contact me.

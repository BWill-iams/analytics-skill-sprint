Queries to Write
  
-- Access the view of all customers
Select *
FROM customers;

-- Pull data from customer_id, gender and tenure columns from customers table
Select customer_id, gender, tenure,
FROM customers;

-- Filtering customers whose tenure is 12 months or longer
SELECT customer_id, tenure
FROM customers
WHERE tenure > 12;

--Filter customers that are on month-to-month contracts
SELECT customer_id, contract_type
FROM customers
WHERE contract_type = 'Month-to-month';

-- Sort customers by tenure (highest to lowest)
SELECT customers_id, tenure
FROM customers
ORDER BY tenure DESC;

-- View list of Top 10 Longest Tenured Customers
SELECT customer_id, tenure
FROM customers
ORDER BY tenure DESC
LIMIT 10;

-- Select UNIQUE contract types
SELECT DISTINCT contract_type
FROM customers;

-- List of customers who are senior citizens
SELECT customer_id, senior_citizen
FROM customers
WHERE senior_citizen = 1;



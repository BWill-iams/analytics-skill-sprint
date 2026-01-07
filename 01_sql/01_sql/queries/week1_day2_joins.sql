
-- Combine customer demographics with billing information
SELECT
  c.customer_id,
  c.gender,
  c.tenure,
  b.monthly_charges,
  b.payment_method
FROM customers c
INNER JOIN billing b
  ON c.customer_id = b.customer_id;

-- Identifying customers who have churned
SELECT
  c.customer_id,
  c.tenure,
  b.churn
FROM customers c
INNER JOIN billing b
  ON c.customer_id = b.customer_id
WHERE b.churn = 'Yes';

-- List services used by customers who have churned
SELECT 
  c.customer_id.
  s.internet_service,
  s.streaming,
  s.tech_support,
  b.churn
FROM customers c
INNER JOIN services s
  ON c.customer_id = s.customer_id
INNER JOIN billing b
  ON c.customer_id = b.customer_id
WHERE b.churn = 'Yes';

-- Identify customers without services
-- may indicate inactive accounts or gaps in data
SELECT
  c.sutomer_id,
  s.internet_service
FROM customers c
LEFT JOIN services s
  ON c.customer_id = s.customer_id
WHERE s.customer_id IS NULL;

-- Compare charges by contract type
SELECT
  c.contract_type,
  AVG(b.monthly_charges) AS avg_monthly_charges
FROM customers c
INNER JOIN billing b
  ON c.customer_id = b.customer_id
GROUP BY c.contract_type;


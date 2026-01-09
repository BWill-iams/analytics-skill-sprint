-- Provides a baseline customer count used to contextualize churn,
-- revenue metrics, and overall customer segmentation analyses
SELECT COUNT(*) AS total_customers
FROM customers;

-- Compares average customer tenure across contract types to identify
-- which contract structures are associated with longer cusotmer retention
SELECT 
  contract_type,
  AVG(tenure) AS avg_tenure
FROM custoemrs
GROUP BY contract_type;

-- Evaluates average monthly charges by contract type to understand 
-- pricing differences and their potential impact on customer value
SELECT
  c.contract_type,
  AVG(b.monthly_charges) AS avg_monthly_charges
FROM customers c
INNER JOIN billing b
  ON c.customer_id = b.customer_id
GROUP BY c.contract_type;

-- Identifies the number of churned customers by contract type to highlight
-- which contract structures experience the highest customer turnover
SELECT
  c.contract_type,
  COUNT(*) AS churned_customers
FROM customers c
INNER JOIN billing b
  ON c.customer_id = b.customer_id
WHERE b.churn = 'Yes'
GROUP BY c.contract_type;

-- Calculates churn rate by contract type to normalize churn counts
-- and enable fair comparison across customer segments
SELECT
  c.contract_type,
  COUNT(CASE WHEN b.churn = 'Yes' THEN 1 END) * 1.0 / COUNT(*) AS churn_rate
FROM customers c
INNER JOIN billing b
  ON c.customer_id = b.customer_id
GROUP BY c.contract_type;

-- Flags contract types with churn rates above 25% to identify
-- high-risk segments that may require targeted retention strategies
SELECT
  c.contract_type,
  COUNT(CASE WHEN b.churn = 'Yes'  THEN 1 END) * 1.0 / COUNT(*) AS churn_rate
FROM customers c
INNER JOIN billing b
  ON c.customer_id = b.customer_id
GROUP BY c.contract_type
HAVING COUNT(CASE WHEN b.churn = 'Yes' THEN 1 END) * 1.0 / COUNT(*) > 0.25;

-- Segmenting customers into buckets based on tenure
-- which allows specific retention targeting based on duration
SELECT
  customer_id,
  tenure,
  CASE
    WHEN tenure < 12 THEN 'New'
    WHEN tenure BETWEEN 12 AND 36 THEN 'Mid-Term'
    ELSE 'Long-Term'
  END AS tenure_segment
FROM customers;

-- Flag high-value customers based on monthly charges
-- which allows analysis of retention strategies
SELECT 
  customer_id,
  monthly_charges,
  CASE
    WHEN monthly_charges >= 80 THEN 'High Value'
    ELSE 'Standard Value'
END AS customer_value_segment
FROM billing;

-- Convert churn status into numeric format for analysis and modeling
-- binary numeric format allows for input into ML
SELECT
  customer_id,
  CASE
    WHEN churn = 'Yes' THEN 1
    ELSE  0
  END AS churn_flag
FROM billing;

-- Calculating churn rate across tenrue and value segments

SELECT
  tenure_segment,
  customer_value_segment,
  COUNT(CASE WHEN churn = 'Yes' THEN 1 END) * 1.0 / COUNT(*) AS churn_rate
FROM (
    SELECT
      c.customer_id,
      CASE
          WHEN c.tenure < 12 THEN 'New'
          WHEN c.tenure BETWEEN 12 AND 36 THEN 'Mid-Term'
          ELSE 'Long-Term'
      END AS tenure_segment,
      CASE
          WHEN b.monthly_charges >= 80 THEN 'High Value'
          ELSE 'Standard Value'
      END AS customer_value_segment,
      b.churn
  FROM customers c
  INNER JOIN billing b
      ON c.customer_id = b.customer_id
  ) sub
GROUP BY tenure_segment, customer_value_segment;




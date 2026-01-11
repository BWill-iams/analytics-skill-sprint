-- Establish overall churn rate baseline for comparison across segments
SELECT
  COUNT(CASE WHEN churn = 'Yes' THEN 1 END) * 1.0 / COUNT(*) AS overall_churn_rate
FROM billing;

-- Compare churn rates across contract types to identify structural risk factors
SELECT
  c.contract_type,
  COUNT(CASE WHEN b.churn = 'Yes' THEN 1 END) *  1.0 / COUNT(*) AS churn_rate
FROM customers c
INNER JOIN billing b
  ON c.customer_id = b.customer_id
GROUP BY c.contract_type;

-- Analyze churn behavior across customer lifecycle stages
SELECT
  tenure_segment,
  COUNT(CASE WHEN churn = 'Yes' THEN 1 END) * 1.0 / COUNT(*) AS churn_rate
FROM (
    SELECT
      c.customer_id,
      CASE 
        WHEN c.tenure < 12 THEN 'New'
        WHEN c.tenure BETWEEN 12 AND 36 THEN 'Mid-Term'
        ELSE 'Long-Term'
      END AS tenure_segment,
      b.churn
    FROM customers c
    INNER JOIN billing b
      ON c.customer_id = b.customer_id
) sub
GROUP BY tenure_segment;

-- Identify high-risk customer segments by combining tenure and value dimensions
SELECT
  tenure_segment,
  customer_value_segment,
  COUNT(CASE WHEN churn = 'Yes' THEN 1 END)  * 1.0 / COUNT(*) AS churn_rate
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
GROUP BY tenure_segment, customer_value_segment
ORDER BY churn_rate DESC;

-- Flag customer segments with churn rates exceeding 30% for targeted intervention
SELECT 
  tenure_segment,
  customer_value_segment,
  churn_rate,
  CASE
      WHEN churn_rate > 0.30 THEN 'High Risk'
      ELSE 'Lower Risk'
  END AS risk_flag
FROM (
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
  ) base
  GROUP BY tenure_segment, customer_value_segment
) final;

/*
INSIGHTS SUMMARY:
- Month-to-month and short-tenure customers exhibit the highest churn rates
- High-value customers with short tenure are particularly high risk
- Longer-term contracts are associated with lower churn, suggesting retention benefits

RECOMMENDATIONS:
- Target new, high-value customers with onboarding and retention incentives
- Encourage migration from month-to-month to longer-term contracts
*/


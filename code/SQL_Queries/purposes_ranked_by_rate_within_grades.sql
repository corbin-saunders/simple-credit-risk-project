SELECT
  grade,
  purpose,
  AVG(int_rate) AS avg_rate,
  RANK() OVER (PARTITION BY grade ORDER BY AVG(int_rate) DESC) AS rate_rank_within_grade
FROM loans
GROUP BY grade, purpose;
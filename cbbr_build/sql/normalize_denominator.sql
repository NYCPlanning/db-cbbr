WITH denominatorcount AS (
SELECT name,
	budgetcategory,
	COUNT(*) AS count
FROM cbbr_submissions
GROUP BY name,
	budgetcategory)

UPDATE cbbr_submissions a
SET denominator = b.count
FROM denominatorcount b
WHERE a.name=b.name
	AND a.budgetcategory=b.budgetcategory;
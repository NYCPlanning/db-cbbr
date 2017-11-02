-- creating the cbbr_submissions table

DROP TABLE IF EXISTS cbbr_submissions;

CREATE TABLE cbbr_submissions AS (
WITH unioned AS (
SELECT * FROM cbbr_requests_main
UNION ALL 
SELECT * FROM cbbr_requests_other)

SELECT b.name, b.borough, b.commdist, a.*
FROM unioned a
LEFT JOIN 
cbbr_commboard_regid b
ON b.regid = a.parentregid
);
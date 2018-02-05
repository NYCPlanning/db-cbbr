CREATE EXTENSION tablefunc;

SELECT *
FROM   crosstab(
   'SELECT agency, commdist, COUNT(*)
    FROM   cbbr_submissions
    GROUP BY agency, commdist
    ORDER  BY 1,2'  -- needs to be "ORDER BY 1,2" here
   ) AS ct (agency text, commdist int);


SELECT *
FROM crosstab(
  'SELECT agency, commdist, COUNT(*)
   FROM cbbr_submissions
   GROUP BY agency, commdist')
AS ct(row_name text, category_1 text, category_2 text, category_3 text);
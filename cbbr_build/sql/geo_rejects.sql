DROP TABLE IF EXISTS qc_operator;
CREATE TABLE geo_rejects AS (
SELECT address,street_name,between_cross_street_1,and_cross_street_2,borough,geo_message FROM cbbr_submissions
WHERE (address != ' '
OR street_name != ' ')
AND geom IS NULL
);

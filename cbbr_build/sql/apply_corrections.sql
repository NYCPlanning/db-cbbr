-- Create multi geometry if the records has the same unique_id into a CTE table 
-- and rename the geometry column from wkt to _multipoint_geom to highlight the change in geometry type

-- Create update points corrections table

WITH _corrections_multigeom AS (
   SELECT unique_id, ST_Multi(ST_Collect(geom)) AS _geom
   FROM _corrections_geom
   GROUP BY unique_id 
)

-- update _cbbr_submissions table with update geoms from manually mapped corrections table 
UPDATE _cbbr_submissions a
SET geom = b._geom
FROM  _corrections_multigeom b
WHERE a.unique_id = b.unique_id;

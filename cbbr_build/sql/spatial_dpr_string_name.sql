-- Add geometries to cbbr based on fuzzy string matching

-- Join Park geoms to records via park name
-- round 1: like statements with compliations like 'bridge park' removed

WITH master AS(
SELECT a.unique_id, a.facility_or_park_name, b.signname, b.geom
FROM cbbr_submissions a,
     dpr_parksproperties b
WHERE a.geom IS NULL AND
      upper(b.signname) <> 'PARK' AND
      upper(b.signname) <> 'LOT' AND
      upper(b.signname) <> 'GARDEN' AND 
      upper(b.signname) <> 'TRIANGLE' AND
      upper(b.signname) <> 'SITTING AREA' AND
      upper(b.signname) <> 'BRIDGE PARK' AND
      upper(a.facility_or_park_name) LIKE upper('%' || b.signname || '%')
      AND a.borough = (CASE 
        WHEN b.borough = 'M' THEN 'Manhattan'
        WHEN b.borough = 'X' THEN 'Bronx'
        WHEN b.borough = 'B' THEN 'Brooklyn'
        WHEN b.borough = 'Q' THEN 'Queens'
        WHEN b.borough = 'R' THEN 'Staten Island'
        ELSE NULL
        END)
) 
UPDATE cbbr_submissions
SET geo_function='dpr_parksproperties',
    geom=master.geom
FROM master
WHERE cbbr_submissions.unique_id=master.unique_id AND
      cbbr_submissions.geom IS NULL;

-- round 2: now that some geoms have been filled, add back Bridge Park
WITH master AS(
SELECT a.unique_id, a.facility_or_park_name, b.signname, b.geom
FROM cbbr_submissions a,
     dpr_parksproperties b
WHERE a.geom IS NULL AND
      upper(b.signname) <> 'PARK' AND
      upper(b.signname) <> 'LOT' AND
      upper(b.signname) <> 'GARDEN' AND
      upper(b.signname) <> 'TRIANGLE' AND
      upper(b.signname) <> 'SITTING AREA' AND
      upper(a.facility_or_park_name) LIKE upper('%' ||b.signname || '%')
      AND a.borough = (CASE 
        WHEN b.borough = 'M' THEN 'Manhattan'
        WHEN b.borough = 'X' THEN 'Bronx'
        WHEN b.borough = 'B' THEN 'Brooklyn'
        WHEN b.borough = 'Q' THEN 'Queens'
        WHEN b.borough = 'R' THEN 'Staten Island'
        ELSE NULL
        END)
)
UPDATE cbbr_submissions
SET geo_function='dpr_parksproperties',
    geom=master.geom
FROM master
WHERE cbbr_submissions.unique_id=master.unique_id AND
      cbbr_submissions.geom IS NULL;

--Join Park geoms to records via fuzzy park name  - fuzzy like statements 
WITH master AS(
SELECT a.unique_id, a.facility_or_park_name, b.signname, b.geom
FROM cbbr_submissions a,
     dpr_parksproperties b
WHERE a.geom IS NULL AND
      upper(b.signname) <> 'PARK' AND
      upper(b.signname) <> 'LOT' AND
      upper(b.signname) <> 'GARDEN' AND
      upper(b.signname) <> 'TRIANGLE' AND
      upper(b.signname) <> 'SITTING AREA' AND
      upper(b.signname) <> 'BRIDGE PARK' AND
      levenshtein(upper('%' ||a.facility_or_park_name || '%'), upper('%' ||b.signname || '%')) <=3
      AND a.borough = (CASE 
        WHEN b.borough = 'M' THEN 'Manhattan'
        WHEN b.borough = 'X' THEN 'Bronx'
        WHEN b.borough = 'B' THEN 'Brooklyn'
        WHEN b.borough = 'Q' THEN 'Queens'
        WHEN b.borough = 'R' THEN 'Staten Island'
        ELSE NULL
        END)
)
UPDATE cbbr_submissions
SET geo_function='dpr_parksproperties',
    geom=master.geom
FROM master
WHERE cbbr_submissions.unique_id=master.unique_id AND
      cbbr_submissions.geom IS NULL;
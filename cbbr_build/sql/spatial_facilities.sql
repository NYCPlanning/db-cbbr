
-- update geoms where names are the exact same
WITH master AS (
WITH singlename AS (
WITH filtered AS (
SELECT facname,
       COUNT(facname) AS namecount
FROM facilities
GROUP BY facname)
SELECT facname
FROM filtered
WHERE namecount = 1
)
SELECT a.unique_id, a.facility_or_park_name, b.facname, b.geom
FROM cbbr_submissions a, facilities b
WHERE a.geom IS NULL AND
	  a.facility_or_park_name IS NOT NULL AND
      b.facname LIKE '%'||' '||'%'||' '||'%' AND
	  '%'||upper(a.facility_or_park_name)||'%' = '%'||upper(b.facname)||'%' AND
      b.facname IN (SELECT facname FROM singlename)
)

UPDATE cbbr_submissions
SET geo_function='facilities',
    geom=master.geom
FROM master
WHERE cbbr_submissions.unique_id=master.unique_id AND
      cbbr_submissions.geom IS NULL;


-- update lib geoms using facdb
WITH master AS(
SELECT a.unique_id, a.facility_or_park_name, b.facname, b.geom
FROM cbbr_submissions a,
     (SELECT * FROM facilities WHERE facgroup = 'Libraries') b
WHERE upper(a.facility_or_park_name) LIKE '%LIBRARY%'
AND upper(a.facility_or_park_name) NOT LIKE '%AND%'
AND '%'||upper(a.facility_or_park_name)||'%' LIKE '%'||upper(b.facname)||'%')

UPDATE cbbr_submissions
SET geo_function='facilities',
    geom=master.geom
FROM master
WHERE cbbr_submissions.unique_id=master.unique_id AND
      cbbr_submissions.geom IS NULL;


-- update precinct geoms using facdb
WITH master AS(
SELECT a.unique_id, a.facility_or_park_name, b.facname, b.geom
FROM cbbr_submissions a,
     (SELECT * FROM facilities WHERE facsubgrp = 'Police Services') b
WHERE upper(a.facility_or_park_name) LIKE '%PRECINCT%'
AND upper(a.facility_or_park_name) NOT LIKE '%AND%'
AND regexp_replace(a.facility_or_park_name,'\D', '', 'g') = regexp_replace(b.facname,'\D', '', 'g')
AND regexp_replace(a.facility_or_park_name,'\D', '', 'g') IS NOT NULL
)

UPDATE cbbr_submissions
SET geo_function='facilities',
    geom=master.geom
FROM master
WHERE cbbr_submissions.unique_id=master.unique_id AND
      cbbr_submissions.geom IS NULL;

-- update school geoms using facdb
WITH master AS(
SELECT a.unique_id, a.facility_or_park_name, b.facname, b.geom
FROM cbbr_submissions a,
     (SELECT * FROM facilities WHERE facsubgrp = 'Public K-12 Schools') b
WHERE (upper(a.facility_or_park_name) LIKE '%SCHOOL%' OR upper(a.facility_or_park_name) LIKE '%P.S.%')
AND upper(a.facility_or_park_name) NOT LIKE '%AND%'
AND regexp_replace(a.facility_or_park_name,'\D', '', 'g') = regexp_replace(b.facname,'\D', '', 'g')
AND regexp_replace(a.facility_or_park_name,'\D', '', 'g') <> ''
AND a.borough = b.boro
)

UPDATE cbbr_submissions
SET geo_function='facilities',
    geom=master.geom
FROM master
WHERE cbbr_submissions.unique_id=master.unique_id AND
      cbbr_submissions.geom IS NULL;

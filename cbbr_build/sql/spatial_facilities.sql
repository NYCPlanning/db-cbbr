
-- update geoms where names are the exact same
WITH master AS (
WITH singlename AS (
WITH filtered AS (
SELECT facname,
       COUNT(facname) AS namecount
FROM facdb_facilities
GROUP BY facname)
SELECT facname
FROM filtered
WHERE namecount = 1
)
SELECT a.regid, a.sitename, b.facname, b.geom
FROM cbbr_submissions a, facdb_facilities b
WHERE a.geom IS NULL AND
	  a.sitename IS NOT NULL AND
      b.facname LIKE '%'||' '||'%'||' '||'%' AND
	  '%'||upper(a.sitename)||'%' = '%'||upper(b.facname)||'%' AND
      b.facname IN (SELECT facname FROM singlename)
)

UPDATE cbbr_submissions
SET geomsource = 'algorithm',
    dataname='facdb_facilities',
    datasource='DCP',
    geom=master.geom
FROM master
WHERE cbbr_submissions.regid=master.regid AND
      cbbr_submissions.geom IS NULL;


-- update lib geoms using facdb
WITH master AS(
SELECT a.regid, a.sitename, b.facname, b.geom
FROM cbbr_submissions a,
     (SELECT * FROM facdb_facilities WHERE facgroup = 'Libraries') b
WHERE upper(a.sitename) LIKE '%LIBRARY%'
AND upper(a.sitename) NOT LIKE '%AND%'
AND '%'||upper(a.sitename)||'%' LIKE '%'||upper(b.facname)||'%')

UPDATE cbbr_submissions
SET geomsource = 'algorithm',
    dataname='facdb_facilities',
    datasource='DCP',
    geom=master.geom
FROM master
WHERE cbbr_submissions.regid=master.regid AND
      cbbr_submissions.geom IS NULL;


-- update precinct geoms using facdb
WITH master AS(
SELECT a.regid, a.sitename, b.facname, b.geom
FROM cbbr_submissions a,
     (SELECT * FROM facdb_facilities WHERE facsubgrp = 'Police Services') b
WHERE upper(a.sitename) LIKE '%PRECINCT%'
AND upper(a.sitename) NOT LIKE '%AND%'
AND regexp_replace(a.sitename,'\D', '', 'g') = regexp_replace(b.facname,'\D', '', 'g')
AND regexp_replace(a.sitename,'\D', '', 'g') IS NOT NULL
)

UPDATE cbbr_submissions
SET geomsource = 'algorithm',
    dataname='facdb_facilities',
    datasource='DCP',
    geom=master.geom
FROM master
WHERE cbbr_submissions.regid=master.regid AND
      cbbr_submissions.geom IS NULL;

-- update school geoms using facdb
WITH master AS(
SELECT a.regid, a.sitename, b.facname, b.geom
FROM cbbr_submissions a,
     (SELECT * FROM facdb_facilities WHERE facsubgrp = 'Public K-12 Schools') b
WHERE (upper(a.sitename) LIKE '%SCHOOL%' OR upper(a.sitename) LIKE '%P.S.%')
AND upper(a.sitename) NOT LIKE '%AND%'
AND regexp_replace(a.sitename,'\D', '', 'g') = regexp_replace(b.facname,'\D', '', 'g')
AND regexp_replace(a.sitename,'\D', '', 'g') <> ''
AND a.borough = b.boro
)

UPDATE cbbr_submissions
SET geomsource = 'algorithm',
    dataname='facdb_facilities',
    datasource='DCP',
    geom=master.geom
FROM master
WHERE cbbr_submissions.regid=master.regid AND
      cbbr_submissions.geom IS NULL;

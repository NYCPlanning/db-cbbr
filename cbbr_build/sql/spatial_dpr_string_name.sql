-- Add geometries to cbbr based on fuzzy string matching

-- Join Park geoms to records via park name
-- round 1: like statements with compliations like 'bridge park' removed

WITH master AS(
SELECT a.regid, a.sitename, b.signname, b.geom
FROM cbbr_submissions a,
     dpr_parksproperties b
WHERE a.geom IS NULL AND
      upper(b.signname) <> 'PARK' AND
      upper(b.signname) <> 'LOT' AND
      upper(b.signname) <> 'GARDEN' AND 
      upper(b.signname) <> 'TRIANGLE' AND
      upper(b.signname) <> 'SITTING AREA' AND
      upper(b.signname) <> 'BRIDGE PARK' AND
      upper(a.sitename) LIKE upper('%' || b.signname || '%')    
) 
UPDATE cbbr_submissions
SET geomsource = 'algorithm',
    dataname='dpr_parksproperties',
    datasource='DPR',
    geom=master.geom
FROM master
WHERE cbbr_submissions.regid=master.regid AND
      cbbr_submissions.geom IS NULL;

-- round 2: now that some geoms have been filled, add back Bridge Park
WITH master AS(
SELECT a.regid, a.sitename, b.signname, b.geom
FROM cbbr_submissions a,
     dpr_parksproperties b
WHERE a.geom IS NULL AND
      upper(b.signname) <> 'PARK' AND
      upper(b.signname) <> 'LOT' AND
      upper(b.signname) <> 'GARDEN' AND
      upper(b.signname) <> 'TRIANGLE' AND
      upper(b.signname) <> 'SITTING AREA' AND
      upper(a.sitename) LIKE upper('%' ||b.signname || '%')
)
UPDATE cbbr_submissions
SET geomsource = 'algorithm',
    dataname='dpr_parksproperties',
    datasource='DPR',
    geom=master.geom
FROM master
WHERE cbbr_submissions.regid=master.regid AND
      cbbr_submissions.geom IS NULL;

--Join Park geoms to records via fuzzy park name  - fuzzy like statements 
WITH master AS(
SELECT a.regid, a.sitename, b.signname, b.geom
FROM cbbr_submissions a,
     dpr_parksproperties b
WHERE a.geom IS NULL AND
      upper(b.signname) <> 'PARK' AND
      upper(b.signname) <> 'LOT' AND
      upper(b.signname) <> 'GARDEN' AND
      upper(b.signname) <> 'TRIANGLE' AND
      upper(b.signname) <> 'SITTING AREA' AND
      upper(b.signname) <> 'BRIDGE PARK' AND
      levenshtein(upper(a.sitename), upper('%' ||b.signname || '%')) <=3
)
UPDATE cbbr_submissions
SET geomsource = 'algorithm',
    dataname='dpr_parksproperties',
    datasource='DPR',
    geom=master.geom
FROM master
WHERE cbbr_submissions.regid=master.regid AND
      cbbr_submissions.geom IS NULL;


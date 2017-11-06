WITH proj AS(
SELECT  ST_Multi(ST_Union(geom)) as geom,
       regid
FROM cbbr_geomsfy18
GROUP BY regid
)
UPDATE cbbr_submissions SET geom = proj.geom,
       dataname = 'cbbr_geomsfy18',
       datasource = 'dcp',
       geomsource = 'dcp'
FROM proj
WHERE cbbr_submissions.regid = proj.regid;
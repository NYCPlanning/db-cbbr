WITH proj AS(
SELECT  ST_Multi(ST_Union(geom)) as geom,
       newtrackin
FROM cbbr_geomsfy18
GROUP BY newtrackin
)
UPDATE cbbr_submissions SET geom = proj.geom,
       dataname = 'cbbr_geomsfy18',
       datasource = 'dcp',
       geomsource = 'dcp'
FROM proj
WHERE cbbr_submissions.trackingnum = proj.newtrackin;
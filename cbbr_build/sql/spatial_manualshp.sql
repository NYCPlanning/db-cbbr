WITH proj AS(
SELECT  ST_Multi(ST_Union(geom)) as geom,
       newtrackin,
       sitename,
       addressnum,
       streetname,
       sitestreet,
       sitecrosss
FROM cbbr_geomsfy18
GROUP BY newtrackin,
       sitename,
       addressnum,
       streetname,
       sitestreet,
       sitecrosss
)
UPDATE cbbr_submissions SET geom = proj.geom,
       dataname = 'cbbr_geomsfy18',
       datasource = 'dcp',
       geomsource = 'dcp'
FROM proj
WHERE cbbr_submissions.trackingnum = proj.newtrackin
AND (cbbr_submissions.sitename = proj.sitename 
	OR (cbbr_submissions.addressnum::text = proj.addressnum::text 
		AND cbbr_submissions.streetname = proj.streetname)
	OR (cbbr_submissions.streetsegment = proj.sitestreet 
		AND cbbr_submissions.streetcross1 = proj.sitecrosss))
AND cbbr_submissions.geom IS NULL AND proj.geom IS NOT NULL;
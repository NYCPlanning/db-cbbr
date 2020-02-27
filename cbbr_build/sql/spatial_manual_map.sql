-- Overwrite geoms with manual mapping input
UPDATE cbbr_submissions a
SET geom = b.geom,
	geo_function = 'Manual_Mapping'
FROM manual_geoms."FY21" b
WHERE a.unique_id = b.unique_id;
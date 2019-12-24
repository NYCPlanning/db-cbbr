-- Assign geoms based on geocoding returned values
ALTER TABLE cbbr_submissions
DROP COLUMN IF EXISTS geo_from_geom,
DROP COLUMN IF EXISTS geo_to_geom,
DROP COLUMN IF EXISTS geom;
ALTER TABLE cbbr_submissions
ADD geo_from_geom GEOMETRY,
ADD geo_to_geom GEOMETRY,
ADD geom GEOMETRY;

--clean up empty values
UPDATE cbbr_submissions
SET geo_bbl = (CASE WHEN geo_bbl = '' THEN NULL ELSE geo_bbl END),
    geo_bin = (CASE WHEN geo_bin = '' THEN NULL ELSE geo_bin END),
    geo_longitude = (CASE WHEN geo_longitude = '' THEN NULL ELSE geo_longitude END),
	geo_latitude = (CASE WHEN geo_latitude = '' THEN NULL ELSE geo_latitude END),
	geo_x_coord = (CASE WHEN geo_x_coord = '' THEN NULL ELSE geo_x_coord END),
	geo_y_coord = (CASE WHEN geo_y_coord = '' THEN NULL ELSE geo_y_coord END)
;

-- Assign geoms based on the centroid of the bin
UPDATE cbbr_submissions a
SET geom = (CASE WHEN a.geo_bbl||a.geo_bin IS NOT NULL THEN ST_Centroid(b.geom) ELSE a.geom END)
FROM doitt_buildingfootprints b
WHERE a.geo_bbl||a.geo_bin = b.base_bbl||b.bin
;

-- Convert from_x_coord, from_y_coord to from_geom
-- Convert to_x_coord, to_y_coord to to_geom
UPDATE cbbr_submissions
SET geo_from_geom = ST_TRANSFORM(ST_SetSRID(ST_MakePoint(geo_from_x_coord::NUMERIC,geo_from_y_coord::NUMERIC),2263),4326),
    geo_to_geom = ST_TRANSFORM(ST_SetSRID(ST_MakePoint(geo_to_x_coord::NUMERIC,geo_to_y_coord::NUMERIC),2263),4326);

-- Assign geoms based on the centroid of the bin
-- based on geo_longitude, geo_latitude, geo_x_coord and geo_y_coord
UPDATE cbbr_submissions
SET geom = (CASE WHEN geo_longitude IS NOT NULL AND geom IS NULL
					THEN ST_SetSRID(ST_MakePoint(geo_longitude::DOUBLE PRECISION, geo_latitude::DOUBLE PRECISION), 4326)
                 WHEN geo_x_coord IS NOT NULL AND geom IS NULL
                        THEN ST_TRANSFORM(ST_SetSRID(ST_MakePoint(geo_x_coord::NUMERIC,geo_y_coord::NUMERIC),2263),4326)
                 WHEN geo_from_geom IS NOT NULL AND geom IS NULL
                        THEN ST_MakeLine(geo_from_geom, geo_to_geom)
                 ELSE geom
		END);
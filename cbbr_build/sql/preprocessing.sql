UPDATE cbbr_geoms
SET geom = ST_SetSRID(ST_GeomFromGeoJSON(geom),4326);

ALTER TABLE cbbr_geoms
ALTER COLUMN geom TYPE geometry;
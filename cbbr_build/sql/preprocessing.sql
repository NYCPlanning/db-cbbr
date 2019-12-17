ALTER TABLE facdb_facilities
ALTER COLUMN geom TYPE geometry(POINT, 4326) USING ST_GeomFromText(ST_AsText(geom),4326);

UPDATE cbbr_geoms
SET geom = ST_SetSRID(ST_GeomFromGeoJSON(geom),4326);

ALTER TABLE cbbr_geoms
ALTER COLUMN geom TYPE geometry;
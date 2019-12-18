-- extract geometries from manually researched json files
UPDATE cbbr_geoms
SET geom = ST_SetSRID(ST_GeomFromGeoJSON(geom),4326);

ALTER TABLE cbbr_geoms
ALTER COLUMN geom TYPE GEOMETRY;

ALTER TABLE doitt_buildingfootprints
RENAME COLUMN wkb_geometry TO geom;
ALTER TABLE dpr_parksproperties
RENAME COLUMN wkb_geometry TO geom;
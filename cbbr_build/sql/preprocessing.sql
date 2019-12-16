ALTER TABLE facdb_facilities
ALTER COLUMN geom TYPE geometry(POINT, 4326) USING ST_GeomFromText(ST_AsText(geom),4326);

UPDATE cbbr_geoms
SET geom = (CASE
				WHEN type = 'Point' THEN ST_GeomFromText('POINT '||REPLACE(REPLACE(REPLACE(geom,'{','('),'}',')'),',',' '), 4326)
				WHEN type = 'LineString' THEN ST_GeomFromText('LINESTRING '||REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
												geom,'{{{','('),'}}}',')'),'{{','('),'}}',')'),'},{','|'),',',' '),'|',', '),4326)
				WHEN type = 'Polygon' THEN ST_GeomFromText('POLYGON '||REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
												geom,'{{{','(('),'}}}','))'),'},{','|'),',',' '),'|',', '),4326)

			END);

ALTER TABLE cbbr_geoms
ALTER COLUMN geom TYPE geometry;
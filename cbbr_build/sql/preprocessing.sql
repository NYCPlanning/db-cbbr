-- create versions of relvant import date to modify
DROP TABLE IF EXISTS _cbbr_submissions;

CREATE TABLE _cbbr_submissions AS TABLE cbbr_submissions;

DROP TABLE IF EXISTS _doitt_buildingfootprints;

CREATE TABLE _doitt_buildingfootprints AS TABLE doitt_buildingfootprints;

DROP TABLE IF EXISTS _dpr_parksproperties;

CREATE TABLE _dpr_parksproperties AS TABLE dpr_parksproperties;

DROP TABLE IF EXISTS _dcp_facilities;

CREATE TABLE _dcp_facilities AS TABLE dcp_facilities;

-- -- extract geometries from manually researched json files
-- UPDATE
--     cbbr_geoms
-- SET
--     geom = ST_SetSRID (ST_GeomFromGeoJSON (geom), 4326);
-- ALTER TABLE cbbr_geoms
--     ALTER COLUMN geom TYPE GEOMETRY;
--
-- create unique_id column
ALTER TABLE _cbbr_submissions
    ADD unique_id text;

UPDATE
    _cbbr_submissions
SET
    unique_id = ogc_fid;

-- create columns expected in export
ALTER TABLE _cbbr_submissions
    ADD parent_tracking_code text;

-- rename columns
ALTER TABLE _cbbr_submissions RENAME COLUMN trkno TO tracking_code;

ALTER TABLE _cbbr_submissions RENAME COLUMN boro TO borough;

ALTER TABLE _cbbr_submissions RENAME COLUMN board TO cd;

ALTER TABLE _cbbr_submissions RENAME COLUMN agency_name TO agency_acronym;

ALTER TABLE _cbbr_submissions RENAME COLUMN "type" TO type_br;

ALTER TABLE _cbbr_submissions RENAME COLUMN loc_type TO "type";

ALTER TABLE _cbbr_submissions RENAME COLUMN reason TO explanation;

ALTER TABLE _cbbr_submissions RENAME COLUMN supported_by_1 TO supporters_1;

ALTER TABLE _cbbr_submissions RENAME COLUMN supported_by_2 TO supporters_2;

ALTER TABLE _cbbr_submissions RENAME COLUMN agy_response_category TO agency_category_response;

ALTER TABLE _cbbr_submissions RENAME COLUMN agy_response TO agency_response;

ALTER TABLE _doitt_buildingfootprints RENAME COLUMN wkb_geometry TO geom;

ALTER TABLE _dpr_parksproperties RENAME COLUMN wkb_geometry TO geom;

ALTER TABLE _dcp_facilities RENAME COLUMN wkb_geometry TO geom;


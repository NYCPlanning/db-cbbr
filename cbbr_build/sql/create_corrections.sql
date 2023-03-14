/* Read in points geometry from the csv table */
DROP TABLE IF EXISTS corrections_geom;
CREATE TABLE corrections_geom (
    WKT GEOMETRY(PointZ, 4326), --I think we can just turn this into text and then convert once we have all the geometries that were manually mapped
    OBJECTID text, --these can be deleted in preprocessing of the tables 
    unique_id text,
    editor text, -- delete in preprocessing
    layer text, -- delete in preprocessing
    "path" text -- delete in preprocessing

);
\COPY corrections_geom FROM 'cbbr_geom_corrections/cbbr_locations_point_all.csv' DELIMITER ',' CSV HEADER;

/*
DROP TABLE IF EXISTS corrections_lines_geom;
CREATE TABLE corrections_lines_geom (
    WKT GEOMETRY(MultiCurveZ, 4326),
    OBJECTID text,
    Shape_Length numeric,
    unique_id text,
    cartodb_id text,
    editor text, 
    layer text,
    "path" text

);
\COPY corrections_lines_geom FROM 'cbbr_geom_corrections/cbbr_locations_line_all.csv' DELIMITER ',' CSV HEADER;
*/
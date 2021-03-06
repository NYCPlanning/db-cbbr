#!/bin/bash
source config.sh

echo "Transforming to final schema"
psql $BUILD_ENGINE -f sql/export.sql

echo "Exporting output tables"
psql $BUILD_ENGINE -c "\COPY (SELECT trackingnum,
    borough,
    cd,
    commdist,
    type_br,
    priority,
    agencyacro,
    agency,
    need,
    request,
    explanation,
    sitename,
    address,
    streetsegment,
    streetcross1,
    streetcross2,
    supporters1,
    supporters2,
    parent_tracking_code,
    agyresponsecat,
    agyresponse,
    unique_id
 FROM cbbr_export WHERE borough IS NOT NULL) TO 'output/cbbr_submissions.csv' DELIMITER ',' CSV HEADER;"

(
    cd output
    psql $BUILD_ENGINE -c "
        DROP TABLE IF EXISTS cbbr_export_poly;
        SELECT * INTO cbbr_export_poly FROM cbbr_export
        WHERE ST_GeometryType(geom)='ST_MultiPolygon';

        DROP TABLE IF EXISTS cbbr_export_pts;
        SELECT * INTO cbbr_export_pts FROM cbbr_export
        WHERE ST_GeometryType(geom)='ST_MultiPoint';

        DROP TABLE IF EXISTS cbbr_submissions_needgeoms;
        SELECT * INTO cbbr_submissions_needgeoms FROM cbbr_submissions 
        WHERE geom IS NULL AND type = 'site';
    "
    CSV_export $BUILD_ENGINE cbbr_submissions_needgeoms cbbr_submissions_needgeoms
    CSV_export $BUILD_ENGINE cbbr_export_poly cbbr_submissions_poly
    CSV_export $BUILD_ENGINE cbbr_export_pts cbbr_submissions_pts
    SHP_export $BUILD_ENGINE cbbr_export_poly MULTIPOLYGON cbbr_submissions_poly
    SHP_export $BUILD_ENGINE cbbr_export_pts  MULTIPOINT cbbr_submissions_pts
)
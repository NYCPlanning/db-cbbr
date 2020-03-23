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

# # points
# ogr2ogr -f "GeoJSON" cbbr_build/output/cbbr_submissions_pts.geojson PG:"host=localhost dbname=$DBNAME user=$DBUSER" \
# -sql "SELECT * FROM cbbr_submissions WHERE ST_GeometryType(geom)='ST_MultiPoint' AND borough IS NOT NULL"

# # polygons
# ogr2ogr -f "GeoJSON" cbbr_build/output/cbbr_submissions_poly.geojson PG:"host=localhost dbname=$DBNAME user=$DBUSER" \
# -sql "SELECT * FROM cbbr_submissions WHERE ST_GeometryType(geom)='ST_MultiPolygon' AND borough IS NOT NULL"

# # for manual geom creation
# psql -U $DBUSER -d $DBNAME -c "COPY (SELECT * FROM cbbr_submissions WHERE geom IS NULL AND borough IS NOT NULL AND budgetcategory = 'Capital' AND site1 LIKE 'Yes%') TO '$REPOLOC/cbbr_build/output/cbbr_submissions_needgeoms.csv' DELIMITER ',' CSV HEADER;"


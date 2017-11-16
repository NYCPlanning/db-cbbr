#!/bin/bash

# make sure we are at the top of the git directory
REPOLOC="$(git rev-parse --show-toplevel)"
cd $REPOLOC

# load config
DBNAME=$(cat $REPOLOC/cbbr.config.json | jq -r '.DBNAME')
DBUSER=$(cat $REPOLOC/cbbr.config.json | jq -r '.DBUSER')

# export csv
psql -U $DBUSER -d $DBNAME -c "COPY (SELECT * FROM cbbr_submissions WHERE borough IS NOT NULL) TO '$REPOLOC/cbbr_build/output/cbbr_submissions.csv' DELIMITER ',' CSV HEADER;"

# points
ogr2ogr -f "GeoJSON" cbbr_build/output/cbbr_submissions_pts.geojson PG:"host=localhost dbname=$DBNAME user=$DBUSER" \
-sql "SELECT * FROM cbbr_submissions WHERE ST_GeometryType(geom)='ST_MultiPoint' AND borough IS NOT NULL"

# polygons
ogr2ogr -f "GeoJSON" cbbr_build/output/cbbr_submissions_poly.geojson PG:"host=localhost dbname=$DBNAME user=$DBUSER" \
-sql "SELECT * FROM cbbr_submissions WHERE ST_GeometryType(geom)='ST_MultiPolygon' AND borough IS NOT NULL"

# for manual geom creation
psql -U $DBUSER -d $DBNAME -c "COPY (SELECT * FROM cbbr_submissions WHERE geom IS NULL AND borough IS NOT NULL AND budgetcategory = 'Capital' AND site1 LIKE 'Yes%') TO '$REPOLOC/cbbr_build/output/cbbr_submissions_needgeoms.csv' DELIMITER ',' CSV HEADER;"


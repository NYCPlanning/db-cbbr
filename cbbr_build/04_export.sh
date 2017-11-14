#!/bin/bash

# make sure we are at the top of the git directory
REPOLOC="$(git rev-parse --show-toplevel)"
cd $REPOLOC

# load config
DBNAME=$(cat $REPOLOC/cbbr.config.json | jq -r '.DBNAME')
DBUSER=$(cat $REPOLOC/cbbr.config.json | jq -r '.DBUSER')

# export csv
psql -U $DBUSER -d $DBNAME -c "COPY (SELECT * FROM cbbr_submissions) TO '$REPOLOC/cbbr_build/output/cbbr_submissions.csv' DELIMITER ',' CSV HEADER;"

# points
pgsql2shp -u $DBUSER -f cbbr_build/output/cbbr_submissions_pts $DBNAME "SELECT * FROM cbbr_submissions WHERE ST_GeometryType(geom)='ST_MultiPoint'"

# polygons
pgsql2shp -u $DBUSER -f cbbr_build/output/cbbr_submissions_poly $DBNAME "SELECT * FROM cbbr_submissions WHERE ST_GeometryType(geom)='ST_MultiPolygon'"

# for manual geom creation
psql -U $DBUSER -d $DBNAME -c "COPY (SELECT * FROM cbbr_submissions WHERE geom IS NULL AND borough IS NOT NULL AND budgetcategory = 'Capital' AND site1 LIKE 'Yes%') TO '$REPOLOC/cbbr_build/output/cbbr_submissions_needgeoms.csv' DELIMITER ',' CSV HEADER;"

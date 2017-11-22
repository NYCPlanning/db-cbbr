#!/bin/bash

################################################################################################
### OBTAINING DATA
################################################################################################
### NOTE: This script requires that you setup the DATABASE_URL environment variable.
### Directions are in the README.md.

## Load all datasets from sources using civic data loader
## https://github.com/NYCPlanning/data-loading-scripts

cd '/prod/data-loading-scripts'

echo 'Loading core datasets'
node loader.js install cbbr_submissions
node loader.js install cbbr_geoms
node loader.js install dpr_parksproperties

cd '/prod/db-cbbr'

DBNAME=$(cat $REPOLOC/cbbr.config.json | jq -r '.DBNAME')
DBUSER=$(cat $REPOLOC/cbbr.config.json | jq -r '.DBUSER')

# facilties from carto
wget -O './capitalprojects_build/downloads/facdb_facilities.json' 'https://cartoprod.capitalplanning.nyc/user/cpp/api/v2/sql?format=GeoJSON&q=select * from facdb_facilities'

ogr2ogr -f 'PostgreSQL' PG:'dbname=$DBNAME user=$DBUSER' $REPOLOC/'capitalprojects_build/downloads/facdb_facilities.json' -nln facdb_facilities -overwrite
rm './capitalprojects_build/downloads/facdb_facilities.json'
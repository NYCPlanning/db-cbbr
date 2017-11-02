#!/bin/bash

# make sure we are at the top of the git directory
REPOLOC="$(git rev-parse --show-toplevel)"
cd $REPOLOC

# load config
DBNAME=$(cat $REPOLOC/cpdb.config.json | jq -r '.DBNAME')
DBUSER=$(cat $REPOLOC/cpdb.config.json | jq -r '.DBUSER')

start=$(date +'%T')
echo "Starting Attributes Table work at: $start"

## These manual geometries may overwrite old sprints. That's good.
# more manual geometries 
echo 'Updating manual geometries -- update_geometries script'
./cbbr_build/update_geometries.sh


# String matching should never overwrite a geometry from above

# dpr -- fuzzy string on park name
echo 'Adding DPR geometries based on string matching for park name'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/cbbr_build/sql/spatial_dpr_string_name.sql

# FacDB -- fuzzy string on facility name
echo 'Adding FacDB geometries based on string matching for facility name'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/cbbr_build/sql/spatial_facilities.sql
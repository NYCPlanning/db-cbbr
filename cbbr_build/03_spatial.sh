#!/bin/bash

# make sure we are at the top of the git directory
REPOLOC="$(git rev-parse --show-toplevel)"
cd $REPOLOC

# load config
DBNAME=$(cat $REPOLOC/cbbr.config.json | jq -r '.DBNAME')
DBUSER=$(cat $REPOLOC/cbbr.config.json | jq -r '.DBUSER')

start=$(date +'%T')
echo "Starting Attributes Table work at: $start"

# Geocode
echo 'Geocoding geoms...'
source activate py2
python $REPOLOC/cbbr_build/python/geocode_address.py
python $REPOLOC/cbbr_build/python/geocode_intersection.py
python $REPOLOC/cbbr_build/python/geocode_intersection_pt2.py
source deactivate

# Manual geoms
echo 'Adding existing geoms from previous sprints...'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/cbbr_build/sql/spatial_manualshp.sql

## These manual geometries may overwrite old sprints. That's good.
# more manual geometries 
echo 'Updating manual geometries -- update_geometries script'
./cbbr_build/update_geometries.sh

# String matching
# String matching should never overwrite a geometry from above
# dpr -- fuzzy string on park name
echo 'Adding DPR geometries based on string matching for park name...'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/cbbr_build/sql/spatial_dpr_string_name.sql

# FacDB -- fuzzy string on facility name
echo 'Adding FacDB geometries based on string matching for facility name...'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/cbbr_build/sql/spatial_facilities.sql

#cleaning geometries
psql -U $DBUSER -d $DBNAME -f $REPOLOC/cbbr_build/sql/spatial_geomclean.sql


cd $REPOLOC

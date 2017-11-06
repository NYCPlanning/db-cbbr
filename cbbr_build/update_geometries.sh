#!/bin/bash

# make sure we are at the top of the git directory
REPOLOC="$(git rev-parse --show-toplevel)"
cd $REPOLOC

# load config
DBNAME=$(cat $REPOLOC/cbbr_build/cbbr.config.json | jq -r '.DBNAME')
DBUSER=$(cat $REPOLOC/cbbr_build/cbbr.config.json | jq -r '.DBUSER')

# custom geometries solution
# loop through all files in the geometries directory and update em
echo 'Loading geometries from geojson files'
GEOMS=./cbbr_build/geometries/*
for G in $GEOMS
do
    REGID=${G:24:-5}
    ./cbbr_build/python/json2sql.py $REGID $G > /dev/null
done
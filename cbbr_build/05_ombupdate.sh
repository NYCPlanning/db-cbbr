#!/bin/bash

# make sure we are at the top of the git directory
REPOLOC="$(git rev-parse --show-toplevel)"
cd $REPOLOC

cd '/prod/data-loading-scripts'

echo 'Loading core datasets'
node loader.js install cbbr_submissions
node loader.js install cbbr_geoms
node loader.js install dpr_parksproperties

cd '/prod/db-cbbr'

# load config
DBNAME=$(cat $REPOLOC/cbbr.config.json | jq -r '.DBNAME')
DBUSER=$(cat $REPOLOC/cbbr.config.json | jq -r '.DBUSER')

# load lookup table


# load omb table

# remove lookup table and omb table


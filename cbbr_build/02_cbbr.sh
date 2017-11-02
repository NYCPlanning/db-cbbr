#!/bin/bash

# make sure we are at the top of the git directory
REPOLOC="$(git rev-parse --show-toplevel)"
cd $REPOLOC

# load config
DBNAME=$(cat $REPOLOC/cbbr_build/cbbr.config.json | jq -r '.DBNAME')
DBUSER=$(cat $REPOLOC/cbbr_build/cbbr.config.json | jq -r '.DBUSER')

# create cbbr table from community board budget request submissions
echo 'Creating cbbr table...'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/sql/cbbr_submissions.sql


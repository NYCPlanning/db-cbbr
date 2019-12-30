#!/bin/bash

# make sure we are at the top of the git directory
REPOLOC="$(git rev-parse --show-toplevel)"
cd $REPOLOC

# load config
DBNAME=$(cat $REPOLOC/cbbr.config.json | jq -r '.DBNAME')
DBUSER=$(cat $REPOLOC/cbbr.config.json | jq -r '.DBUSER')

# create cbbr table from community board budget request submissions
echo 'Creating cbbr table...'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/cbbr_build/sql/cbbr_submissions.sql

echo 'Normalizing data...'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/cbbr_build/sql/normalize_agency.sql
# psql -U $DBUSER -d $DBNAME -f $REPOLOC/cbbr_build/sql/normalize_agencyacro.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/cbbr_build/sql/normalize_commdist.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/cbbr_build/sql/normalize_denominator.sql
# psql -U $DBUSER -d $DBNAME -f $REPOLOC/cbbr_build/sql/normalize_sitetype.sql
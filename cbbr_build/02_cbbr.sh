#!/bin/bash
source config.sh

echo "Create _cbbr_submissions table ..."
run_sql sql/_cbbr_submissions.sql

## Skipping for dev of initial FY2024 build
# psql $BUILD_ENGINE -f sql/apply_agency_updates.sql

echo "Normalizing agency values ..."
run_sql sql/normalize_agency.sql
echo "Normalizing commdist values ..."
run_sql sql/normalize_commdist.sql
echo "Normalizing denominator values ..."
run_sql sql/normalize_denominator.sql

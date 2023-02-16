#!/bin/bash
source config.sh

echo "CBBR Version FY2024 : 02 CBBR"
echo "Create tables to modify ..."
run_sql sql/preprocessing.sql

## Skipping for dev of initial FY2024 build
# psql $BUILD_ENGINE -f sql/apply_agency_updates.sql

echo "Normalize agency values ..."
run_sql sql/normalize_agency.sql
echo "Normalize commdist values ..."
run_sql sql/normalize_commdist.sql
echo "Normalize denominator values ..."
run_sql sql/normalize_denominator.sql

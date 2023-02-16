#!/bin/bash
source config.sh

# psql $BUILD_ENGINE -f sql/cbbr_submissions.sql
# psql $BUILD_ENGINE -f sql/apply_agency_updates.sql
echo "Normalizing agency values ..."
# psql $BUILD_ENGINE -f sql/normalize_agency.sql
run_sql sql/normalize_agency.sql
echo "Normalizing commdist values ..."
# psql $BUILD_ENGINE -f sql/normalize_commdist.sql
run_sql sql/normalize_commdist.sql
echo "Normalizing denominator values ..."
# psql $BUILD_ENGINE -f sql/normalize_denominator.sql

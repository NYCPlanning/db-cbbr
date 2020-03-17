#!/bin/bash
source config.sh

# psql $BUILD_ENGINE -f sql/cbbr_submissions.sql
psql $BUILD_ENGINE -f sql/normalize_agency.sql
psql $BUILD_ENGINE -f sql/normalize_commdist.sql
psql $BUILD_ENGINE -f sql/normalize_denominator.sql
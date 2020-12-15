#!/bin/bash
# Create a postgres database container
source config.sh

echo "load data into the container"
docker run --rm\
            -v `pwd`:/home/cbbr_build\
            -w /home/cbbr_build\
            --env-file .env\
            nycplanning/cook:latest bash -c "python3 python/dataloading.py; python3 python/aggregate_geoms.py; pip3 install -r python/requirements.txt; python3 python/manual_geoms.py"

psql $BUILD_ENGINE -f sql/preprocessing.sql

cat data/cbbr_fy22_to_fy21_uniqueids.csv | 
psql $BUILD_ENGINE -c "
    DROP TABLE IF EXISTS fy21_fy22_lookup;
    CREATE TABLE fy21_fy22_lookup (
        fy22_unique_id text,
        fy21_unique_id text
    ); 
    COPY fy21_fy22_lookup FROM STDIN DELIMITER ',' CSV HEADER;
"

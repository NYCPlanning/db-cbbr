#!/bin/bash
# Create a postgres database container
# source config.sh
BASEDIR=$(dirname $0)
NAME=$(basename $BASEDIR)
WORKDIR="$(pwd)/$NAME"
CONTAINER_WORKDIR="/cook_container_home/$NAME"
VERSION=$DATE

source $WORKDIR/config.sh

echo "Load data into the container ..."
docker run --rm \
    --volume $WORKDIR:$CONTAINER_WORKDIR \
    --workdir $CONTAINER_WORKDIR \
    --env-file .env \
    nycplanning/cook:latest bash -c "
    set -e
    python3 python/dataloading.py;
    python3 python/aggregate_geoms.py;
    pip3 install -r python/requirements.txt;
    python3 python/manual_geoms.py
    "
psql $BUILD_ENGINE -f sql/preprocessing.sql

cat data/cbbr_fy22_to_fy21_uniqueids.csv |
    psql $BUILD_ENGINE -c "
    DROP TABLE IF EXISTS fy21_fy22_lookup;
    CREATE TABLE fy21_fy22_lookup (
        fy22_unique_id text,
        fy21_unique_id text
    );
    COPY fy21_fy22_lookup FROM STDIN DELIMITER ',' CSV HEADER;
# "

echo "Done!"

#!/bin/bash
# Create a postgres database container
# Exit when any command fails
set -e
# Keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# Echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

BASEDIR=$(dirname $0)
NAME=$(basename $BASEDIR)
WORKDIR="$(pwd)/$NAME"
CONTAINER_NAME="cbbr_cook_container"
CONTAINER_WORKDIR="/cook_container_home/$NAME"
VERSION=$DATE

source $WORKDIR/config.sh
# pip3 install -r $WORKDIR/python/requirements.txt

echo "Load data into the container ..."

# ## REPLACES python3 python/dataloading.py
# import_public cbbr_submissions
# import_public dpr_parksproperties
# import_public doitt_buildingfootprints 20230122 # last version with a valid sql archive in in edm-recipes
# # import_public cbbr_agency_updates # DEPRICATED THIS INPUT DATA

## REPLACES python3 python/aggregate_geoms.py
python3 python/aggregate_geoms.py

## REPLACES python3 python/manual_geoms.py
## TODO

## DEPRICATED AND REPLACED USE OF COOK DOCKER IMAGE
# docker run --rm \
#     --name $CONTAINER_NAME \
#     --volume $WORKDIR:$CONTAINER_WORKDIR \
#     --workdir $CONTAINER_WORKDIR \
#     --env-file .env \
#     nycplanning/cook:latest python3 python/dataloading.py
# nycplanning/cook:latest bash -c "
# set -e
# python3 python/dataloading.py;
# # python3 python/aggregate_geoms.py;
# # pip3 install -r python/requirements.txt;
# # python3 python/manual_geoms.py
# "
# psql $BUILD_ENGINE -f sql/preprocessing.sql

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

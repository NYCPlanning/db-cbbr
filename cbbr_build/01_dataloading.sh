#!/bin/bash
# Create a postgres database container
source config.sh

echo "load data into the container"
docker run --rm\
            -v `pwd`:/home/cbbr_build\
            -w /home/cbbr_build\
            --env-file .env\
            sptkl/cook:latest bash -c "python3 python/dataloading.py; python3 python/aggregate_geoms.py; pip3 install -r python/requirements.txt; python3 python/manual_geoms.py"

psql $BUILD_ENGINE -f sql/preprocessing.sql
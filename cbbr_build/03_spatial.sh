#!/bin/bash
source config.sh

docker run -it --rm\
            -v `pwd`:/home/db-cbbr\
            -w /home/db-cbbr\
            --env-file .env\
            sptkl/docker-geosupport:19d bash -c "python3 python/geocoding.py"

psql $BUILD_ENGINE -f sql/assign_geoms.sql
psql $BUILD_ENGINE -f sql/spatial_manualshp.sql
psql $BUILD_ENGINE -f sql/spatial_dpr_string_name.sql
psql $BUILD_ENGINE -f sql/spatial_facilities.sql

echo "Overwriting geometries with manual mapping..."
psql $BUILD_ENGINE -f sql/spatial_manual_map.sql
echo "Done."

psql $BUILD_ENGINE -f sql/spatial_geomclean.sql
psql $BUILD_ENGINE -f sql/geo_rejects.sql
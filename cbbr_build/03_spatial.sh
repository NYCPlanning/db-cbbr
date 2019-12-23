#!/bin/bash
source config.sh

docker run -it --rm\
            -v `pwd`:/home/db-cbbr\
            -w /home/db-cbbr\
            --env-file .env\
            sptkl/docker-geosupport:19d bash -c "python3 python/geocoding.py"

docker exec $DB_CONTAINER_NAME psql -U postgres -h localhost -f sql/assign_geoms.sql
docker exec $DB_CONTAINER_NAME psql -U postgres -h localhost -f sql/spatial_manualshp.sql
docker exec $DB_CONTAINER_NAME psql -U postgres -h localhost -f sql/spatial_dpr_string_name.sql
docker exec $DB_CONTAINER_NAME psql -U postgres -h localhost -f sql/spatial_facilities.sql
docker exec $DB_CONTAINER_NAME psql -U postgres -h localhost -f sql/spatial_geomclean.sql
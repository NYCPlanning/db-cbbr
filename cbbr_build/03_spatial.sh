#!/bin/bash
source config.sh

echo "CBBR Version FY2024 : 03 Spatial"
echo "Geocode with geosupport image  ..."
docker run -it --rm \
    -v $(pwd):/home/db-cbbr \
    -w /home/db-cbbr \
    --env-file .env \
    --network="host" \
    nycplanning/docker-geosupport:latest bash -c "python3 python/geocoding.py"

echo "Assign geometries from geocoding ..."
run_sql sql/assign_geoms.sql

# run_sql sql/spatial_manualshp.sql
echo "Assign geometries from parks data ..."
run_sql sql/spatial_dpr_string_name.sql

echo "Assign geometries from facilities data ..."
run_sql sql/spatial_facilities.sql

# echo "Overwriting geometries with manual mapping..."
# run_sql sql/spatial_manual_map.sql
# echo "Done."

# run_sql sql/spatial_geomclean.sql
# run_sql sql/geo_rejects.sql

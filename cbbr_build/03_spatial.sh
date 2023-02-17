#!/bin/bash
source config.sh

echo "CBBR Version $VERSION : 03 Spatial"
echo "Geocode with geosupport image  ..."
docker run -it --rm \
    -v $(pwd):/home/db-cbbr \
    -w /home/db-cbbr \
    --env-file .env \
    --network="host" \
    nycplanning/docker-geosupport:latest bash -c "python3 python/geocoding.py"

echo "Assign geometries from geocoding ..."
run_sql sql/assign_geoms.sql

## Skipping for dev of initial FY2024 build
# echo "Assign geometries from manual shapefiles ..."
# run_sql sql/spatial_manualshp.sql

## Skipping for dev of initial FY2024 build
echo "Assign geometries from parks data ..."
run_sql sql/spatial_dpr_string_name.sql

## Skipping for dev of initial FY2024 build
echo "Assign geometries from facilities data ..."
run_sql sql/spatial_facilities.sql

## Skipping for dev of initial FY2024 build
# echo "Overwriting geometries with manual mapping..."
# run_sql sql/spatial_manual_map.sql

echo "Running spatial_geomclean ..."
run_sql sql/spatial_geomclean.sql

echo "Running geo_rejects ..."
run_sql sql/geo_rejects.sql

echo "Done!"

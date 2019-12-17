#!/bin/bash
# Create a postgres database container
source config.sh

[ ! "$(docker ps -a | grep $DB_CONTAINER_NAME)" ]\
     && docker run -itd --name=$DB_CONTAINER_NAME\
            -v `pwd`:/home/cbbr_build\
            -w /home/cbbr_build\
            --env-file .env\
            --shm-size=4g\
            -p $CONTAINER_PORT:5432\
            mdillon/postgis

## Wait for database to get ready, this might take 5 seconds of trys
docker start $DB_CONTAINER_NAME
until docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres; do
    echo "Waiting for postgres container..."
    sleep 0.5
done

docker inspect -f '{{.State.Running}}' $DB_CONTAINER_NAME
docker exec $DB_CONTAINER_NAME psql -U postgres -h localhost -c "SELECT 'DATABSE IS UP';"

echo "load data into the container"
docker run --rm\
            --network=host\
            -v `pwd`/python:/home/python\
            -w /home/python\
            --env-file .env\
            sptkl/cook:latest python3 dataloading.py

docker run --rm\
            --network=host\
            -v `pwd`:/home/cbbr_build\
            -w /home/cbbr_build\
            --env-file .env\
            sptkl/cook:latest bash -c "pip3 install -r python/requirements.txt; python3 python/facdb_dataloading.py; python3 python/aggregate_geoms.py"

docker exec $DB_CONTAINER_NAME psql -U postgres -h localhost -f sql/preprocessing.sql
#!/bin/bash
source config.sh

docker kill $DB_CONTAINER_NAME
docker container prune -f;
docker volume prune -f
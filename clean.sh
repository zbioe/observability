#!/usr/bin/env sh

docker-compose rm -f
docker volume rm $(docker volume ls --filter "NAME=observability" -q)

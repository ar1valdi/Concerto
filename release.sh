#!/usr/bin/bash

docker-compose -f compose/docker-compose.release.yml build && \
docker-compose -f compose/docker-compose.release.yml push
#!/usr/bin/bash

set -a
VERSION=$1
docker-compose -f DockerCompose/docker-compose.release.yml build && \
docker-compose -f DockerCompose/docker-compose.release.yml push
#!/usr/bin/bash

set -a
VERSION=$1

COMPOSE_DOCKER_CLI_BUILD=1
DOCKER_BUILDKIT=1

docker buildx build \
	--platform linux/amd64,linux/arm64 \
	--progress=plain \
	--pull --push \
	--tag etav/concerto_server:${VERSION} \
	--file ./Server/Dockerfile .
	
docker buildx build \
	--platform linux/amd64,linux/arm64 \
	--progress=plain \
	--pull --push \
	--tag etav/concerto_proxy:${VERSION} \
	--file ./DockerCompose/nginx/Dockerfile ./DockerCompose/nginx
	
docker buildx build \
	--platform linux/amd64,linux/arm64 \
	--progress=plain \
	--pull --push \
	--tag etav/kask:${VERSION} \
	--file ./DockerCompose/nginx_kask_sim/Dockerfile ./DockerCompose/nginx_kask_sim

#docker-compose -f DockerCompose/docker-compose.release.yml build && \
#docker-compose -f DockerCompose/docker-compose.release.yml push
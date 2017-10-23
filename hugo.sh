#!/usr/bin/env bash

NAME=hugo
REGISTRY=hassiumlabs
IMAGE="${REGISTRY}/${NAME}"

# The base command to run the hugo container
docker run --rm \
    -v $(pwd):/srv \
    --workdir=/srv \
    $IMAGE $1

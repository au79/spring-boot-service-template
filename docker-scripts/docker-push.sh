#!/usr/bin/env bash


# Check for all 3 required args: a repository, an image name, and a tag
if [[ $# -lt 3 ]]
then
    echo Required arguments are absent.  Aborting.
    echo "Usage: $0 {repository} {image-name} {tag}"
    exit 1
fi

REPOSITORY=$1
IMAGE_NAME=$2
TAG=$3

docker push "${REPOSITORY}/${IMAGE_NAME}:latest"
docker push "${REPOSITORY}/${IMAGE_NAME}:${TAG}"


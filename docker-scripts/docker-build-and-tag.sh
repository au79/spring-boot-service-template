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

docker build -t "${IMAGE_NAME}:latest" -t "${IMAGE_NAME}:${TAG}" \
  -t "${REPOSITORY}/${IMAGE_NAME}:latest" -t "${REPOSITORY}/${IMAGE_NAME}:${TAG}" .

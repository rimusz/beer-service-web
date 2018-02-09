#!/bin/bash

# set docker repository
DOCKER_REPO=quay.io/rimusz

# image name
IMAGE=beer-service-web

# use buildkite commit hash as a TAG
TAG=${BUILDKITE_COMMIT::8}

# checkout branch
git checkout ${BUILDKITE_BRANCH}

# build docker image
echo -e "\n--- Building :docker: image ${IMAGE}:${TAG}"
docker build -t ${IMAGE}:${TAG} .

# tag docker image
docker tag ${IMAGE}:${TAG} ${DOCKER_REPO}/${IMAGE}:${TAG}

# push to repository
echo "--- Pushing :docker: image ${DOCKER_REPO}/${IMAGE}:${TAG} to registry"
docker push ${DOCKER_REPO}/${IMAGE}:${TAG}

# local clean up
echo "--- Cleaning up :docker: image ${DOCKER_REPO}/${IMAGE}:${TAG}"
docker rmi -f ${DOCKER_REPO}/${IMAGE}:${TAG}

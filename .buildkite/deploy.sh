#!/bin/bash

# setup helm
echo "Installing helm"
./get_helm.sh
echo "--- Configuring Helm cli :rocket:"
export HELM_HOME="${PWD}/.buildkite/.helm"
helm init -c
helm repo add dlc https://dcos-labs.github.io/charts
helm repo update

# use buildkite commit hash as a TAG
TAG=${BUILDKITE_COMMIT::8}

# app name
APP=beer

# deploy/upgrade app with helm
echo "--- Deploying $APP :rocket:"
helm upgrade --install ${APP} --namespace=${APP} dlc/beer-service-web \
  --set ingress.enabled="true",ingress.host="beer.rimusz.xyz" \
  --set beerWeb.image.repository="quay.io/rimusz/beer-service-web" \
  --set beerWeb.image.tag="${GIT_TAG}"

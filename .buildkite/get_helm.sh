#!/bin/bash

# download helm cli

HELM_VERSION=$1
cd /tmp

if [[ ${HELM_VERSION} == "" ]]
then
    echo "Checking for latest Helm version..."
    LATEST_HELM=$(curl -s https://api.github.com/repos/kubernetes/helm/releases/latest | grep "tag_name" | awk '{print $2}' | sed -e 's/"\(.*\)"./\1/')
else
    LATEST_HELM=${HELM_VERSION}
fi

# check if the binary exists
if [ ! -f /usr/local/bin/helm ]; then
    INSTALLED_HELM=v0.0.0
else
    INSTALLED_HELM=$(/usr/local/bin/helm version -c)
fi
#
MATCH=$(echo "${INSTALLED_HELM}" | grep -c "${LATEST_HELM}")
if [ $MATCH -ne 0 ]; then
    echo " "
    echo "Helm is up to date !!!"
    echo " "
else
    echo " "
    echo "Downloading ${LATEST_HELM} of 'helm' cli"
    curl -k -L http://storage.googleapis.com/kubernetes-helm/helm-${LATEST_HELM}-linux-amd64.tar.gz > /tmp/helm.tar.gz
    tar xvf /tmp/helm.tar.gz -C /tmp linux-amd64/helm > /dev/null 2>&1
    chmod +x /tmp/linux-amd64/helm
    mv -f /tmp/linux-amd64/helm /usr/local/bin/helm
    rm -f /tmp/helm.tar.gz
    echo " "
    echo "Installed ${LATEST_HELM} of 'helm' cli to /usr/local/bin ..."
    echo " "
fi

#!/bin/bash

set -Eeuxo pipefail
rm -rf working
mkdir working
cd working

GCI_URL="ghcr.io/golden-containers"

# Checkout upstream

git clone --depth 1 --branch master https://github.com/docker-library/openjdk
cd openjdk

# Transform

GCI_REGEX_URL=$(echo ${GCI_URL} | sed 's/\//\\\//g')

# This sed syntax is GNU sed specific
[ -z $(command -v gsed) ] && GNU_SED=sed || GNU_SED=gsed

${GNU_SED} -i \
    -e "1 s/FROM.*/FROM ${GCI_REGEX_URL}\/buildpack-deps\:bullseye-scm/; t" \
    -e "1,// s//FROM ${GCI_REGEX_URL}\/buildpack-deps\:bullseye-scm/" \
    18/jdk/bullseye/Dockerfile

# Build

[ -z "${1:-}" ] && BUILD_LABEL_ARG="" || BUILD_LABEL_ARG=" --label \"${1}\" "

BUILD_PLATFORM=" --platform linux/amd64 "
BUILD_ARGS=" ${BUILD_LABEL_ARG} ${BUILD_PLATFORM} "

docker build 18/jdk/bullseye/ ${BUILD_ARGS} \
    --tag ${GCI_URL}/openjdk:18-bullseye

# Push

docker push ${GCI_URL}/openjdk -a

#!/bin/bash

set -Eeuxo pipefail
rm -rf working
mkdir working
cd working

# Checkout upstream

git clone --depth 1 --branch master https://github.com/docker-library/openjdk
cd openjdk

# Transform

# This sed syntax is GNU sed specific
# [ -z $(command -v gsed) ] && GNU_SED=sed || GNU_SED=gsed

sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/buildpack-deps\:bullseye-scm/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/buildpack-deps\:bullseye-scm/" 18/jdk/bullseye/Dockerfile

# Build

docker build 18/jdk/bullseye/ --platform linux/amd64 --tag ghcr.io/golden-containers/openjdk:18-bullseye --label ${1:-DEBUG=TRUE}

# Push

docker push ghcr.io/golden-containers/openjdk -a

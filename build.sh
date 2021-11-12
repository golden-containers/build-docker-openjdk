#!/bin/sh

set -xe
rm -rf working
mkdir working
cd working

# Checkout upstream

git clone --depth 1 --branch master https://github.com/docker-library/openjdk
cd openjdk

# Transform

sed -i -e "1 s/FROM.*/FROM ghcr.io\/golden-containers\/buildpack-deps\:bullseye-scm/; t" -e "1,// s//FROM ghcr.io\/golden-containers\/buildpack-deps\:bullseye-scm/" 18/jdk/bullseye/Dockerfile
echo "LABEL ${1:-DEBUG=TRUE}" >> 18/jdk/bullseye/Dockerfile

# Build

docker build --tag ghcr.io/golden-containers/openjdk:18-bullseye 18/jdk/bullseye

# Push

docker push ghcr.io/golden-containers/openjdk -a

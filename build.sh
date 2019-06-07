#!/bin/bash
REPO="jackgruber/phpmyadmin"

ARCH=$(dpkg --print-architecture)
SW_VERSION=$(cat Dockerfile | grep "ENV VERSION" | cut -d ' ' -f 3)

if [ "$1" = "manifest" ]; then
  DIR="${REPO/\//_}"

  # latest
  rm -rf ~/.docker/manifests/docker.io_${DIR}-latest/
  docker manifest create \
    $REPO:latest \
    $REPO:armhf \
    $REPO:amd64

  docker manifest push $REPO:latest
  docker manifest inspect $REPO

  # version
  rm -rf ~/.docker/manifests/docker.io_${DIR}-${SW_VERSION}/
  docker manifest create \
    $REPO:${SW_VERSION} \
    $REPO:${SW_VERSION}-armhf \
    $REPO:${SW_VERSION}-amd64

  docker manifest push $REPO:${SW_VERSION}
  docker manifest inspect $REPO
else
  if [ "$1" = "test" ]; then
    ARCH="test"
  fi

  docker build -t $REPO \
  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
  --build-arg VCS_REF=`git rev-parse --short HEAD` \
  --build-arg BRANCH=`git rev-parse --abbrev-ref HEAD` .

  docker tag $REPO $REPO:$ARCH
  docker tag $REPO $REPO:${SW_VERSION}-$ARCH

  if [ "$1" = "push" ]; then
    docker rmi $REPO:test
    docker rmi $REPO:${SW_VERSION}-test
    docker push $REPO:latest
    docker push $REPO:$ARCH
    docker push $REPO:${SW_VERSION}-$ARCH
  fi
fi

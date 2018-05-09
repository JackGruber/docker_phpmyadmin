#!/bin/sh
REPO="jackgruber/phpmyadmin"

arch=$( uname -m )

if [ "$1" = "test" ]; then
  arch="test"
fi

docker build -t $REPO:$arch .

if [ "$1" != "test" ]; then
  case $arch in
  armv7l)
    docker tag $REPO:$arch $REPO:rpi
    docker tag $REPO:$arch $REPO:rpi3
    docker tag $REPO:$arch $REPO:arm

    # for history
    docker tag $REPO:$arch $REPO'_rpi'
    if [ "$1" = "push" ]; then
      docker push $REPO'_rpi'
    fi
    ;;
  armv6l)
    docker tag $REPO:$arch $REPO:rpi
    docker tag $REPO:$arch $REPO:rpizw
    docker tag $REPO:$arch $REPO:arm
    ;;
  x86_64)
    ;;
  *)
    echo "Unknown arch $( uname -m )"
    exit 1
  ;;
  esac

  if [ "$1" = "push" ]; then
    docker push $REPO
  fi
fi

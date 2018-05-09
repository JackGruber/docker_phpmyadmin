#!/bin/sh
set -e
cd $(dirname $0)

REPO="jackgruber/phpmyadmin"

arch=$( uname -m )

docker build -t $REPO:$arch .

case $arch in
armv7l)
  docker tag $REPO:$arch $REPO:rpi
  docker tag $REPO:$arch $REPO:rpi3
  docker tag $REPO:$arch $REPO:arm
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

docker push $REPO

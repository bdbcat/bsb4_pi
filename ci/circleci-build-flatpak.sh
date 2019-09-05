#!/usr/bin/env bash

#
# Build the travis flatpak artifacts. Uses docker to run Fedora on
# in the Travis ubuntu VM; the actual build is done in the Fedora
# container.
#

# bailout on errors and echo commands.
set -xe
##sudo apt-get -qq update

PLUGIN=bsb4

DOCKER_SOCK="unix:///var/run/docker.sock"
if [-n "$TRAVIS" ]; then
    TOPDIR=/opencpn-ci
fi

if [ -n "$CIRCLECI" ]; then
   TOPDIR=/root/project
fi

echo "DOCKER_OPTS=\"-H tcp://127.0.0.1:2375 -H $DOCKER_SOCK -s devicemapper\"" \
    | sudo tee /etc/default/docker > /dev/null
sudo service docker restart;
sleep 5;
sudo docker pull fedora:28;

docker run --privileged -d -ti -e "container=docker"  \
    -e TOPDIR=$TOPDIR \
    -v /sys/fs/cgroup:/sys/fs/cgroup \
    -v $(pwd):$TOPDIR:rw \
    fedora:28   /usr/sbin/init
DOCKER_CONTAINER_ID=$(docker ps | grep fedora | awk '{print $1}')
docker logs $DOCKER_CONTAINER_ID
docker exec -ti $DOCKER_CONTAINER_ID /bin/bash -xec \
    "bash -xe $TOPDIR/ci/docker-build-flatpak.sh 28;
         echo -ne \"------\nEND OPENCPN-CI BUILD\n\";"
docker ps -a
docker stop $DOCKER_CONTAINER_ID
docker rm -v $DOCKER_CONTAINER_ID

pyenv global 3.7.0
python -m pip install cloudsmith-cli
pyenv rehash

old=$(ls $HOME/project/build/*.tar.gz)
tarball=$(echo $old | sed "s/.tar.gz/-$CIRCLE_BUILD_NUMBER.$commit.tar.gz/")
mv $old $tarball
old=$(ls $HOME/project/build/*.xml)
xml=$(echo $old | sed "s/.xml/-$CIRCLE_BUILD_NUMBER.$commit.xml/")
mv $old $xml
cloudsmith push raw --republish --no-wait-for-sync \
    alec-leamas/opencpn-plugins-unstable $tarball
cloudsmith push raw --republish --no-wait-for-sync \
    alec-leamas/opencpn-plugins-unstable $xml

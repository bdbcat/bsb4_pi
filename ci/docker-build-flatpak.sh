#!/bin/sh  -xe
cd $(dirname $(readlink -fn $0))

#
# Actually build the flatpak artifacts inside the Fedora container
#
set -xe

if [-n "$TRAVIS" ]; then
    cd /opencpn-ci
fi

if [ "$CIRCLECI" ]; then
   cd /root/project
fi

su -c "dnf install -y sudo cmake gcc-c++ flatpak-builder flatpak make tar"
flatpak remote-add --user --if-not-exists flathub \
    https://flathub.org/repo/flathub.flatpakrepo
flatpak install --user  -y \
        http://opencpn.duckdns.org/opencpn/opencpn.flatpakref
flatpak install --user -y  flathub org.freedesktop.Sdk//18.08 
rm -rf build && mkdir build && cd build
cmake -DOCPN_FLATPAK=ON ..
make flatpak-build
make flatpak-pkg

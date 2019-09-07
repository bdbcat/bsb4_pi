#!/bin/sh  -xe

#
# Build the mingw artifacts inside the Fedora container
#
set -xe

if [ -n "$TRAVIS" ]; then
    cd /opencpn-ci
fi

su -c "dnf install -q -y sudo dnf-plugins-core"
sudo dnf -q builddep  -y mingw/fedora/opencpn-deps.spec
rm -rf build; mkdir build; cd build
cmake -DCMAKE_TOOLCHAIN_FILE=../mingw/fedora/toolchain.cmake ..
make -j2
make package

if [ -z "$CLOUDSMITH_API_KEY" ]; then
    exit 0
fi

sudo dnf -q install python3-pip python3-setuptools
sudo python3 -m pip install -q cloudsmith-cli
cloudsmith push raw --republish --no-wait-for-sync \
    alec-leamas/opencpn-plugins-unstable *.tar.gz
cloudsmith push raw --republish --no-wait-for-sync \
    alec-leamas/opencpn-plugins-unstable *plugin-mingw*xml

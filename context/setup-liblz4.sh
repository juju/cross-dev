#!/bin/bash
set -eux

cd /root

ARCH_LIST="x86_64,aarch64,s390x,powerpc64le"

git clone https://git.launchpad.net/ubuntu/+source/lz4 --branch ${LIBLZ4_VERSION}
cd lz4/lib

printf ${ARCH_LIST} | awk '{print $1}' RS=',' | while read arch ; do
  export CC="${arch}-linux-musl-gcc"
  export PKG_CONFIG_PATH="/usr/${arch}-linux-musl/lib/pkgconfig"

  make install PREFIX="/usr/${arch}-linux-musl" BUILD_SHARED=no BUILD_STATIC=yes
  make clean
done

cd /root
rm -rf /root/lz4

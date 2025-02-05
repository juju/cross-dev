#!/bin/bash
set -eux

cd /root

ARCH_LIST="x86_64,aarch64,s390x,powerpc64le"

git clone https://git.launchpad.net/ubuntu/+source/sqlite3 --branch ${LIBSQLITE3_VERSION}
cd sqlite3

printf ${ARCH_LIST} | awk '{print $1}' RS=',' | while read arch ; do
  export BUILD_CC="gcc"
  export CC="gcc"

  ./configure
  make parse.c

  export CC="${arch}-linux-musl-gcc"
  export PKG_CONFIG_PATH="/usr/${arch}-linux-musl/lib/pkgconfig"

  ./configure --disable-shared --host $(uname -m)-linux --prefix "/usr/${arch}-linux-musl"

  make install
  make clean
done

cd /root
rm -rf /root/sqlite

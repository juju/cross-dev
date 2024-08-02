#!/bin/bash
set -eux

cd /root

ARCH_LIST="x86_64,aarch64,s390x,powerpc64le"

git clone https://github.com/thkukuk/libnsl.git
cd libnsl
git checkout v2.0.0

printf ${ARCH_LIST} | awk '{print $1}' RS=',' | while read arch ; do
  export CC="${arch}-linux-musl-gcc"
  export PKG_CONFIG_PATH="/usr/${arch}-linux-musl/lib/pkgconfig"
  
  ./autogen.sh
  autoreconf -i
  autoconf

  ./configure --disable-shared --host $(uname -m)-linux --prefix "/usr/${arch}-linux-musl"
  
  make install
  make clean
done

cd /root
rm -rf /root/libnsl

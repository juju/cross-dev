#!/bin/bash
set -eux

cd /root

ARCH_LIST="x86_64,aarch64,s390x,powerpc64le"

git clone https://git.launchpad.net/ubuntu/+source/libtirpc --branch ${LIBTIRPC_VERSION}
cd libtirpc
chmod +x autogen.sh

printf ${ARCH_LIST} | awk '{print $1}' RS=',' | while read arch ; do
  export CC="${arch}-linux-musl-gcc"
  export PKG_CONFIG_PATH="/usr/${arch}-linux-musl/lib/pkgconfig"

  autoupdate
  ./autogen.sh
  ./configure --disable-shared --disable-gssapi --host $(uname -m)-linux --prefix "/usr/${arch}-linux-musl"

  make install
  make clean
done

cd /root
rm -rf /root/libtirpc

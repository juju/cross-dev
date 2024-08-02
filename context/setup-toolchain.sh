#!/bin/bash
set -eux

arch_pair=$1
gcc_arch=$(printf ${arch_pair} | awk  -F':' '{print $1}')
deb_arch=$(printf ${arch_pair} | awk  -F':' '{print $2}')

apt-get install -y gcc-$(printf ${gcc_arch} | tr '_' '-')-linux-gnu musl-dev:${deb_arch} libc-dev:${deb_arch}

curl -o /usr/include/${gcc_arch}-linux-musl/sys/queue.h https://raw.githubusercontent.com/juju/musl-compat/main/include/sys/queue.h
sha256sum --check <<EOM
3659cd137c320991a78413dd370a92fd18e0a8bc36d017d554f08677a37d7d5a  /usr/include/${gcc_arch}-linux-musl/sys/queue.h
EOM
ln -s /usr/include/${gcc_arch}-linux-gnu/asm /usr/include/${gcc_arch}-linux-musl/asm
ln -s /usr/include/asm-generic /usr/include/${gcc_arch}-linux-musl/asm-generic
ln -s /usr/include/linux /usr/include/${gcc_arch}-linux-musl/linux
ls -lahR /usr/include/${gcc_arch}-linux-musl/

if [ "${gcc_arch}" = "powerpc64le" ]; then
cat <<EOM | tee -a "/usr/lib/powerpc64le-linux-musl/musl-gcc.specs"
%rename cpp_options x_cpp_options

*cpp_options:
-mlong-double-64 %(x_cpp_options)

%rename cc1 x_cc1

*cc1:
-mlong-double-64 %(x_cc1)
EOM
fi

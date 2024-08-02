#!/bin/bash
set -eux

source /etc/os-release

printf 'Types: deb
URIs: http://au.archive.ubuntu.com/ubuntu/
Suites: SERIES SERIES-updates SERIES-backports
Components: main restricted universe multiverse
Architectures: amd64
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: http://security.ubuntu.com/ubuntu/
Suites: SERIES-security
Components: main restricted universe multiverse
Architectures: amd64
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: http://au.ports.ubuntu.com/ubuntu-ports/
Suites: SERIES SERIES-updates SERIES-backports SERIES-security
Components: main restricted universe multiverse
Architectures: arm64 s390x ppc64el
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg' | sed "s/SERIES/${VERSION_CODENAME}/g" | tee /etc/apt/sources.list.d/ubuntu.sources

DEBIAN_FRONTEND=noninteractive apt-get update
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common curl wget

case $(uname -m) in
  x86_64 | amd64)
    CROSS_ARCH=arm64,s390x,ppc64el
    ;;
  aarch64 | arm64)
    CROSS_ARCH=amd64,s390x,ppc64el
    ;;
  *)
    echo "Bad arch $(uname -m)"
    ;;
esac

printf ${CROSS_ARCH} | awk '{print $1}' RS=',' | while read arch ; do
  dpkg --add-architecture "${arch}"
done

DEBIAN_FRONTEND=noninteractive apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential automake libtool git autopoint pkg-config tclsh

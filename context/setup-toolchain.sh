#!/bin/bash
set -eux

apt-get update
apt-get upgrade -y
apt-get install -y software-properties-common curl wget lsb-release

SERIES=$(lsb_release -c -s)

case $(uname -m) in

  x86_64 | amd64)
    NATIVE_ARCH=x86-64:amd64
    CROSS_ARCH=aarch64:arm64,s390x:s390x,powerpc64le:ppc64el
    ;;

  aarch64 | arm64)
    NATIVE_ARCH=aarch64:arm64
    CROSS_ARCH=x86-64:amd64,s390x:s390x,powerpc64le:ppc64el
    ;;

  *)
    echo "Bad arch $(uname -m)"
    ;;
esac

printf 'deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ SERIES main restricted\n
deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ SERIES-updates main restricted\n
deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ SERIES universe\n
deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ SERIES-updates universe\n
deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ SERIES multiverse\n
deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ SERIES-updates multiverse\n
deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ SERIES-backports main restricted universe multiverse\n
deb [arch=amd64] http://security.ubuntu.com/ubuntu/ SERIES-security main restricted\n
deb [arch=amd64] http://security.ubuntu.com/ubuntu/ SERIES-security universe\n
deb [arch=amd64] http://security.ubuntu.com/ubuntu/ SERIES-security multiverse\n
deb [arch=arm64,s390x,ppc64el] http://ports.ubuntu.com/ubuntu-ports/ SERIES main restricted\n
deb [arch=arm64,s390x,ppc64el] http://ports.ubuntu.com/ubuntu-ports/ SERIES-updates main restricted\n
deb [arch=arm64,s390x,ppc64el] http://ports.ubuntu.com/ubuntu-ports/ SERIES universe\n
deb [arch=arm64,s390x,ppc64el] http://ports.ubuntu.com/ubuntu-ports/ SERIES-updates universe\n
deb [arch=arm64,s390x,ppc64el] http://ports.ubuntu.com/ubuntu-ports/ SERIES multiverse\n
deb [arch=arm64,s390x,ppc64el] http://ports.ubuntu.com/ubuntu-ports/ SERIES-updates multiverse\n
deb [arch=arm64,s390x,ppc64el] http://ports.ubuntu.com/ubuntu-ports/ SERIES-backports main restricted universe multiverse\n
deb [arch=arm64,s390x,ppc64el] http://ports.ubuntu.com/ubuntu-ports/ SERIES-security main restricted\n
deb [arch=arm64,s390x,ppc64el] http://ports.ubuntu.com/ubuntu-ports/ SERIES-security universe\n
deb [arch=arm64,s390x,ppc64el] http://ports.ubuntu.com/ubuntu-ports/ SERIES-security multiverse\n' | sed "s/SERIES/${SERIES}/g" | tee /etc/apt/sources.list

printf ${CROSS_ARCH} | awk -F':' '{print $2}' RS=',' | while read arch ; do
    dpkg --add-architecture "${arch}"
done

add-apt-repository ppa:dqlite/dev -y
printf 'deb [arch=amd64,arm64,s390x,ppc64el] https://ppa.launchpadcontent.net/dqlite/dev/ubuntu/ SERIES main\n' | sed "s/SERIES/${SERIES}/g" | tee /etc/apt/sources.list.d/dqlite-ubuntu-dev-${SERIES}.list

apt-get update
apt-get install -y build-essential
apt-get install -y libdqlite-dev libraft-canonical-dev libdqlite0

printf ${CROSS_ARCH} | awk '{print $1}' RS=',' | while read arch_pair ; do
    gcc_arch=$(printf ${arch_pair} | awk  -F':' '{print $1}')
    deb_arch=$(printf ${arch_pair} | awk  -F':' '{print $2}')
    apt-get install -y gcc-${gcc_arch}-linux-gnu libdqlite-dev:${deb_arch} libraft-canonical-dev:${deb_arch} libdqlite0:${deb_arch}
done

apt-get clean all

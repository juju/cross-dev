ARG BASE_IMAGE
FROM $BASE_IMAGE

ADD prepare-apt.sh .
RUN chmod +x prepare-apt.sh
RUN --mount=type=cache,target=/var/cache/apt \
--mount=type=cache,target=/var/lib/apt \
chmod +x prepare-apt.sh && ./prepare-apt.sh && rm prepare-apt.sh

ADD setup-toolchain.sh .
RUN chmod +x setup-toolchain.sh

RUN --mount=type=cache,target=/var/cache/apt \
--mount=type=cache,target=/var/lib/apt \
./setup-toolchain.sh x86_64:amd64

RUN --mount=type=cache,target=/var/cache/apt \
--mount=type=cache,target=/var/lib/apt \
./setup-toolchain.sh aarch64:arm64

RUN --mount=type=cache,target=/var/cache/apt \
--mount=type=cache,target=/var/lib/apt \
./setup-toolchain.sh s390x:s390x

RUN --mount=type=cache,target=/var/cache/apt \
--mount=type=cache,target=/var/lib/apt \
./setup-toolchain.sh powerpc64le:ppc64el

RUN rm setup-toolchain.sh

ARG GOVERSION
ADD install-go.sh .
RUN chmod +x install-go.sh && ./install-go.sh && rm install-go.sh

ADD setup-libtirpc.sh .
RUN chmod +x setup-libtirpc.sh && ./setup-libtirpc.sh && rm setup-libtirpc.sh

ADD setup-libnsl.sh .
RUN chmod +x setup-libnsl.sh && ./setup-libnsl.sh && rm setup-libnsl.sh

ADD setup-libuv.sh .
RUN chmod +x setup-libuv.sh && ./setup-libuv.sh && rm setup-libuv.sh

ADD setup-libsqlite3.sh .
RUN chmod +x setup-libsqlite3.sh && ./setup-libsqlite3.sh && rm setup-libsqlite3.sh

ADD setup-liblz4.sh .
RUN chmod +x setup-liblz4.sh && ./setup-liblz4.sh && rm setup-liblz4.sh

ADD setup-libraft.sh .
RUN chmod +x setup-libraft.sh && ./setup-libraft.sh && rm setup-libraft.sh

ADD setup-libdqlite.sh .
RUN chmod +x setup-libdqlite.sh && ./setup-libdqlite.sh && rm setup-libdqlite.sh


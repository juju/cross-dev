```
export GOARCH=amd64
export CC="x86_64-linux-musl-gcc"
export PKG_CONFIG_PATH="/usr/x86_64-linux-musl/lib/pkgconfig"
export PACKAGES="libuv raft dqlite liblz4 sqlite3"
export CGO_ENABLED=1
export CGO_LDFLAGS_ALLOW="(-Wl,-wrap,pthread_create)|(-Wl,-z,now)"
export CGO_CFLAGS="$(pkg-config --cflags ${PACKAGES})"
export CGO_LDFLAGS="$(pkg-config --libs ${PACKAGES})"
export GO_LDFLAGS='-s -w -extldflags "-static" -linkmode "external" -X github.com/juju/juju/version.GitCommit= -X github.com/juju/juju/version.GitTreeState= -X github.com/juju/juju/version.build='
go build -tags libsqlite3,dqlite -ldflags "${GO_LDFLAGS}" github.com/juju/juju/cmd/jujud
```

```
export GOARCH=arm64
export CC="aarch64-linux-musl-gcc"
export PKG_CONFIG_PATH="/usr/aarch64-linux-musl/lib/pkgconfig"
export PACKAGES="libuv raft dqlite liblz4 sqlite3"
export CGO_ENABLED=1
export CGO_LDFLAGS_ALLOW="(-Wl,-wrap,pthread_create)|(-Wl,-z,now)"
export CGO_CFLAGS="$(pkg-config --cflags ${PACKAGES})"
export CGO_LDFLAGS="$(pkg-config --libs ${PACKAGES})"
export GO_LDFLAGS='-s -w -extldflags "-static" -linkmode "external" -X github.com/juju/juju/version.GitCommit= -X github.com/juju/juju/version.GitTreeState= -X github.com/juju/juju/version.build='
go build -tags libsqlite3,dqlite -ldflags "${GO_LDFLAGS}" github.com/juju/juju/cmd/jujud
```

```
export GOARCH=s390x
export CC="s390x-linux-musl-gcc"
export PKG_CONFIG_PATH="/usr/s390x-linux-musl/lib/pkgconfig"
export PACKAGES="libuv raft dqlite liblz4 sqlite3"
export CGO_ENABLED=1
export CGO_LDFLAGS_ALLOW="(-Wl,-wrap,pthread_create)|(-Wl,-z,now)"
export CGO_CFLAGS="$(pkg-config --cflags ${PACKAGES})"
export CGO_LDFLAGS="$(pkg-config --libs ${PACKAGES})"
export GO_LDFLAGS='-s -w -extldflags "-static" -linkmode "external" -X github.com/juju/juju/version.GitCommit= -X github.com/juju/juju/version.GitTreeState= -X github.com/juju/juju/version.build='
go build -tags libsqlite3,dqlite -ldflags "${GO_LDFLAGS}" github.com/juju/juju/cmd/jujud
```

```
export GOARCH=ppc64le
export CC="powerpc64le-linux-musl-gcc"
export PKG_CONFIG_PATH="/usr/powerpc64le-linux-musl/lib/pkgconfig"
export PACKAGES="libuv raft dqlite liblz4 sqlite3"
export CGO_ENABLED=1
export CGO_LDFLAGS_ALLOW="(-Wl,-wrap,pthread_create)|(-Wl,-z,now)"
export CGO_CFLAGS="$(pkg-config --cflags ${PACKAGES})"
export CGO_LDFLAGS="$(pkg-config --libs ${PACKAGES})"
export GO_LDFLAGS='-s -w -extldflags "-static" -linkmode "external" -X github.com/juju/juju/version.GitCommit= -X github.com/juju/juju/version.GitTreeState= -X github.com/juju/juju/version.build='
go build -tags libsqlite3,dqlite -ldflags "${GO_LDFLAGS}" github.com/juju/juju/cmd/jujud
```

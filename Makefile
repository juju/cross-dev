# Copyright 2020 Canonical Ltd.
# Licensed under the AGPLv3, see LICENCE file for details.

BUILD_IMAGE=bash -c '. "./make_functions.sh"; build_image "$$@"' build_image
IMAGES?=$(shell yq -o=t '.images | keys' < images.yaml)

default: build

build: PUSH_IMAGE = "0"
build: $(IMAGES)

check:
	shellcheck ./*.sh

images-json:
	@yq -o=j '.images | keys' < images.yaml | jq -c

push: PUSH_IMAGE = "1"
push: $(IMAGES)

%:
	$(BUILD_IMAGE) "$@" "${IS_LOCAL}" "$(PUSH_IMAGE)"

.PHONY: default
.PHONY: build
.PHONY: check
.PHONY: push
.PHONY: %


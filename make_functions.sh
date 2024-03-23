#!/bin/bash
set -eufx

OCI_BUILDER=${OCI_BUILDER:-$((which podman 2>&1 > /dev/null && echo podman) || echo docker)}
DOCKER_BIN=${DOCKER_BIN:-$(which ${OCI_BUILDER} || true)}

_build_args_builder() {
  build_args=$1

  output=""
  for build_arg in ${build_args}; do
    output="${output} --build-arg ${build_arg}"
  done

  echo "$output"
}

build_image() {
  image=${1-""}
  if [ -z "$image" ]; then
    echo "You must supply the image to build in images.yaml"
    exit 1
  fi
  is_local=${2-0}
  push_image=${3:-0}

  dockerfile=$(yq ".images.[\"${image}\"].dockerfile" < images.yaml)
  context=$(yq ".images.[\"${image}\"].context" < images.yaml)
  reg_paths=$(yq -o=c ".images.[\"${image}\"].registry_paths" < images.yaml)
  tags=$(yq -o=c ".images.[\"${image}\"].tags" < images.yaml)
  platforms=$(yq -o=c ".images.[\"${image}\"].platforms" < images.yaml)
  build_args=$(yq -o=t ".images.[\"${image}\"].build_args" < images.yaml)
  
  if [[ "${is_local}" -eq 1 ]]; then
    cmd_platforms=""
  else
    cmd_platforms=" --platform ${platforms}"
  fi

  cmd_build_args=$(_build_args_builder "$build_args")

  for reg_path in ${reg_paths//,/ }; do
    for tag in ${tags//,/ }; do
      echo "${image}: \"${reg_path}:${tag}\" on \"${platforms}\""
      if [[ "${OCI_BUILDER}" = "docker" ]]; then
        if [[ "${push_image}" -eq 1 ]]; then
          output="-o type=image,push=true"
        elif [[ "${is_local}" -eq 1 ]]; then
          output="-o type=docker"
        fi
        BUILDX_NO_DEFAULT_ATTESTATIONS=true DOCKER_BUILDKIT=1 "$DOCKER_BIN" buildx build \
          -f "${dockerfile}" \
          -t "${reg_path}:${tag}"${cmd_platforms}${cmd_build_args} \
          --provenance=false \
          ${output} \
          "${context}"
      elif [[ "${OCI_BUILDER}" = "podman" ]]; then
        "$DOCKER_BIN" manifest rm "${reg_path}:${tag}" || true
        "$DOCKER_BIN" manifest create "${reg_path}:${tag}"
        "$DOCKER_BIN" build \
          --jobs "4" \
          -f "${dockerfile}" \
          --manifest "${reg_path}:${tag}"${cmd_platforms}${cmd_build_args} \
          "${context}"
        if [[ "${push_image}" -eq 1 ]]; then
          "$DOCKER_BIN" manifest push "${reg_path}:${tag}" "docker://${reg_path}:${tag}"
        fi
      else
        echo "unknown OCI_BUILDER=${OCI_BUILDER} expected docker or podman"
        exit 1
      fi
    done
  done
}



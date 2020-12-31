#!/usr/bin/env bash

set -eux

source common.sh

ctr=$(buildah from ${IMAGE_BASE})

# Meta #
buildah config --author "csullivannet@users.noreply.github.com" "${ctr}"

# Entrypoint #
buildah copy "${ctr}" entrypoint.sh /opt/bridge/entrypoint.sh
buildah config --entrypoint "/opt/bridge/entrypoint.sh" "${ctr}"
buildah config --cmd "" "${ctr}"

buildah commit "${ctr}" ${IMAGE_BRIDGE}:${VERSION}
buildah tag ${IMAGE_BRIDGE}:${VERSION} ${IMAGE_BRIDGE}:latest
buildah push ${IMAGE_BRIDGE}:${VERSION}
buildah push ${IMAGE_BRIDGE}:latest

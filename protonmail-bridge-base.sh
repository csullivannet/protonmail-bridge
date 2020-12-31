#!/usr/bin/env bash

set -eux

source common.sh

ctr=$(buildah from debian:buster-slim)
deb=$(buildah from ${IMAGE_DEB})

# Meta #
buildah config --author "csullivannet@users.noreply.github.com" "${ctr}"

# Base #
export PACKAGE_NAME=${PACKAGE_NAME}
buildah unshare --mount MOUNT=${deb} sh -c 'cp --force ${MOUNT}/pm-bridge.deb ${PACKAGE_NAME}'
buildah copy "${ctr}" ${PACKAGE_NAME} /tmp/pm-bridge.deb
buildah run  "${ctr}" -- apt-get update
buildah run  "${ctr}" -- apt-get install --yes --fix-broken --no-install-recommends --no-install-suggests \
                               /tmp/pm-bridge.deb

buildah run  "${ctr}"  -- mkdir -p /opt/bridge
buildah copy "${ctr}" gpgparams /opt/bridge/gpgparams
buildah run  "${ctr}" -- apt-get install --yes --no-install-recommends --no-install-suggests pass

buildah run  "${ctr}" -- rm -f /tmp/*

buildah config --port 1143 "${ctr}"
buildah config --port 1025 "${ctr}"

buildah commit "${ctr}" ${IMAGE_BASE}:${VERSION}
buildah tag ${IMAGE_BASE}:${VERSION} ${IMAGE_BASE}:latest
buildah push ${IMAGE_BASE}:${VERSION}
buildah push ${IMAGE_BASE}:latest

#!/usr/bin/env bash

set -eux
source common.sh

# Bridge URL: deb grabbed from https://protonmail.com/bridge/install
BASE_URL=https://protonmail.com/download
URL=${BASE_URL}/${PACKAGE_NAME}

ctr=$(buildah from scratch)

# Meta #
buildah config --author "csullivannet@users.noreply.github.com" "${ctr}"

# Copy the package
[ ! -f "./${PACKAGE_NAME}" ] && curl -O ${URL}
buildah copy "${ctr}" ${PACKAGE_NAME} /pm-bridge.deb

# Verify the acquried deb
podman run \
  --volume ./${PACKAGE_NAME}:/pm-bridge.deb \
  ${IMAGE_VERIFY} \
    debsig-verify /pm-bridge.deb

# Push to GHCR
buildah commit "${ctr}" ${IMAGE_DEB}:${VERSION}
buildah tag ${IMAGE_DEB}:${VERSION} ${IMAGE_DEB}:latest
buildah push ${IMAGE_DEB}:${VERSION}
buildah push ${IMAGE_DEB}:latest

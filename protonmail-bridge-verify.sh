#!/usr/bin/env bash

set -eux

source common.sh

ctr=$(buildah from debian:buster-slim)

# Meta #
buildah config --author "csullivannet@users.noreply.github.com" "${ctr}"

# Verification #
# See documentation here:
# https://protonmail.com/support/knowledge-base/installing-bridge-linux-deb-file/
buildah run  "${ctr}"  -- apt update
buildah run  "${ctr}"  -- apt install -y curl debsig-verify

buildah run  "${ctr}"  -- mkdir -p /etc/debsig/policies/E2C75D68E6234B07
buildah copy "${ctr}"  bridge.pol /etc/debsig/policies/E2C75D68E6234B07/bridge.pol

buildah run  "${ctr}"  -- mkdir -p /usr/share/debsig/keyrings/E2C75D68E6234B07
buildah copy "${ctr}"  bridge_pubkey.gpg /tmp/bridge_pubkey.gpg
buildah run  "${ctr}"  -- gpg --dearmor --output /usr/share/debsig/keyrings/E2C75D68E6234B07/debsig.gpg \
                              /tmp/bridge_pubkey.gpg

buildah commit "${ctr}" ${IMAGE_VERIFY}:${VERSION}
buildah tag ${IMAGE_VERIFY}:${VERSION} ${IMAGE_VERIFY}:latest
buildah push ${IMAGE_VERIFY}:${VERSION}
buildah push ${IMAGE_VERIFY}:latest

#!/usr/bin/env bash

# Common variables from buildah scripts

VERSION=1.5.2-1
ARCH=amd64
PACKAGE_NAME=protonmail-bridge_${VERSION}_${ARCH}.deb
IMAGE_REPO=ghcr.io/csullivannet/protonmail-bridge
IMAGE_DEB=${IMAGE_REPO}/deb
IMAGE_VERIFY=${IMAGE_REPO}/verify
IMAGE_BASE=${IMAGE_REPO}/base
IMAGE_BRIDGE=${IMAGE_REPO}/bridge

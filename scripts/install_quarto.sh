#!/bin/bash

## Install quarto cli or symlink quarto cli so they are available system-wide.
##
## In order of preference, first argument of the script, the QUARTO_VERSION variable.
## ex. latest, 0.9.16
##
## 'latest', 'release' means installing the latest release version.
## 'prerelease' means installing the latest prerelease version.

set -e

## build ARGs
NCPUS=${NCPUS:--1}

QUARTO_VERSION=${1:-${QUARTO_VERSION:-"latest"}}
# Only amd64 build can be installed now
ARCH=$(dpkg --print-architecture)


# a function to install apt packages only if they are not installed
function apt_install() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get install -y --no-install-recommends "$@"
    fi
}

apt_install wget ca-certificates

if [ -x "$(command -v quarto)" ]; then
    INSTALLED_QUARTO_VERSION=$(quarto --version)
fi


# Install quarto cli
if [ "$QUARTO_VERSION" != "$INSTALLED_QUARTO_VERSION" ]; then

    if [ "$QUARTO_VERSION" = "latest" ]; then
        QUARTO_DL_URL=$(wget -qO- https://quarto.org/docs/download/_download.json | grep -oP "(?<=\"download_url\":\s\")https.*${ARCH}\.deb")
    elif [ "$QUARTO_VERSION" = "prerelease" ]; then
        QUARTO_DL_URL=$(wget -qO- https://quarto.org/docs/download/_prerelease.json | grep -oP "(?<=\"download_url\":\s\")https.*${ARCH}\.deb")
    else
        QUARTO_DL_URL="https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-${ARCH}.deb"
    fi
    wget "$QUARTO_DL_URL" -O quarto.deb
    dpkg -i quarto.deb
    rm quarto.deb
fi

quarto check install

# Clean up
rm -rf /var/lib/apt/lists/*

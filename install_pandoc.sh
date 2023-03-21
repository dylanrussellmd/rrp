#!/bin/bash

## Install pandoc, pandoc-citeproc so they are available system-wide.
##
## In order of preference, first argument of the script, the PANDOC_VERSION variable.
## ex. latest, version
##
## 'latest' means installing the latest release version.
## 'version' is a specific version of pandoc.

set -e

PANDOC_VERSION=${1:-${PANDOC_VERSION:-"latest"}}
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

if [ -x "$(command -v pandoc)" ]; then
    INSTALLED_PANDOC_VERSION=$(pandoc --version 2>/dev/null | head -n 1 | grep -oP '[\d\.]+$')
fi

if [ "$PANDOC_VERSION" != "$INSTALLED_PANDOC_VERSION" ]; then

    if [ -L "/usr/local/bin/pandoc" ]; then
        unlink /usr/local/bin/pandoc
    fi
    if [ -L "/usr/local/bin/pandoc-citeproc" ]; then
        unlink /usr/local/bin/pandoc-citeproc
    fi

    if [ "$PANDOC_VERSION" = "latest" ]; then
        PANDOC_DL_URL=$(wget -qO- https://api.github.com/repos/jgm/pandoc/releases/latest | grep -oP "(?<=\"browser_download_url\":\s\")https.*${ARCH}\.deb")
    else
        PANDOC_DL_URL="https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-1-${ARCH}.deb"
    fi
    wget "$PANDOC_DL_URL" -O pandoc.deb
    dpkg -i pandoc.deb
    rm pandoc.deb

    ## Symlink pandoc & standard pandoc templates for use system-wide
    PANDOC_TEMPLATES_VERSION=$(pandoc -v | grep -oP "(?<=pandoc\s)[0-9\.]+$")
    wget "https://github.com/jgm/pandoc-templates/archive/${PANDOC_TEMPLATES_VERSION}.tar.gz" -O pandoc-templates.tar.gz
    rm -fr /opt/pandoc/templates
    mkdir -p /opt/pandoc/templates
    tar xvf pandoc-templates.tar.gz
    cp -r pandoc-templates*/* /opt/pandoc/templates && rm -rf pandoc-templates*
    rm -fr /root/.pandoc
    mkdir /root/.pandoc && ln -s /opt/pandoc/templates /root/.pandoc/templates
fi

# Clean up
rm -rf /var/lib/apt/lists/*

# Check the pandoc version
echo -e "Check the pandoc version...\n"
pandoc --version
echo -e "\nInstall pandoc, done!"

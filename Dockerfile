FROM rocker/r-ver:4.2.1

LABEL org.opencontainers.image.source="https://github.com/dylanrussellmd/rrp" \
      org.opencontainers.image.vendor="Dylan Russell, MD" \
      org.opencontainers.image.base.name="rocker/r-ver" \
      org.opencontainers.image.ref.name="r-ver" \
      org.opencontainers.image.authors="Dylan Russell <dyl.russell@gmail.com>"

# These can be changed to specify versions, if desired.
ENV PANDOC_VERSION=3.1.1
ENV QUARTO_VERSION=1.2.335
ENV CTAN_REPO=https://www.texlive.info/tlnet-archive/2022/04/21/tlnet

# Update PATH for TeXLive
ENV PATH=$PATH:/usr/local/texlive/bin/linux

# Use selected rocker scripts
RUN /bin/sh -c rocker_scripts/install_pandoc.sh
RUN /bin/sh -c rocker_scripts/install_quarto.sh
RUN /bin/sh -c rocker_scripts/install_tidyverse.sh
RUN /bin/sh -c rocker_scripts/install_verse.sh
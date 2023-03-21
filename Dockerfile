FROM rocker/r-ver:4.2.1

LABEL org.opencontainers.image.source=https://github.com/dylanrussellmd/rrp
LABEL org.opencontainers.image.description="R environment for reproducible manuscripts."
LABEL org.opencontainers.image.licenses=MIT

# These can be changed to specify a version, if desired.
ENV PANDOC_VERSION=3.1.1
ENV QUARTO_VERSION=1.2.335

RUN /bin/sh -c rocker_scripts/install_pandoc.sh
RUN /bin/sh -c rocker_scripts/install_quarto.sh
RUN /bin/sh -c rocker_scripts/install_tidyverse.sh

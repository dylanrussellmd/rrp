FROM rocker/r-ver:4.2.1

# These can be changed to specify a version, if desired.
# ENV PANDOC_VERSION=latest
# ENV QUARTO_VERSION=latest

RUN /bin/sh -c rocker_scripts/install_pandoc.sh
RUN /bin/sh -c rocker_scripts/install_quarto.sh
RUN /bin/sh -c rocker_scripts/install_tidyverse.sh

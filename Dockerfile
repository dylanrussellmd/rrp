FROM rocker/r-ver:4.2.1

COPY scripts /build_scripts

ENV PANDOC_VERSION=latest
ENV QUARTO_VERSION=latest

RUN /bin/sh -c build_scripts/install_pandoc.sh
RUN /bin/sh -c build_scripts/install_quarto.sh

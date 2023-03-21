FROM rocker/r-ver:4.2.1

ENV PANDOC_VERSION=latest
ENV QUARTO_VERSION=latest

RUN /bin/sh -c install_pandoc.sh
RUN /bin/sh -c install_quarto.sh

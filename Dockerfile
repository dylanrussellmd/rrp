FROM rocker/r-ver:4.2.1

LABEL org.opencontainers.image.source="https://github.com/dylanrussellmd/rrp" \
      org.opencontainers.image.vendor="Dylan Russell, MD" \
      org.opencontainers.image.base.name="rocker/r-ver" \
      org.opencontainers.image.ref.name="r-ver" \
      org.opencontainers.image.authors="Dylan Russell <dyl.russell@gmail.com>"

# These can be changed to specify versions, if desired.
ENV PANDOC_VERSION=3.1.1
ENV QUARTO_VERSION=1.2.335
ENV TINYTEX_VERSION=2023.03

# Use selected rocker scripts
RUN /bin/sh -c rocker_scripts/install_pandoc.sh
RUN /bin/sh -c rocker_scripts/install_quarto.sh
RUN /bin/sh -c rocker_scripts/install_tidyverse.sh

# Install TinyTeX and add location of root/bin to PATH
RUN wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh
ENV PATH=$PATH:root/bin

# Set tlmgr repository to end of 2022
# TODO This needs to be scripted so that the repository can be set to one that is active (i.e. can initialize)
# and to the latest remote repository that is before the selected TexLive version.
RUN tlmgr option repository https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/2022/tlnet-final

# Update all TexLive packages
#RUN tlmgr update --all

# Install additional packages needed by Quarto
# TODO check if these libraries are installed prior to installing
RUN apt update && apt install -y \
      libxtst6 \
      libxt6 
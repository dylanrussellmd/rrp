FROM rocker/verse:4.2.0

RUN apt-get update -y && \
    apt-get install -y pip
RUN pip install radian 
RUN R -e "install.packages(c('languageserver','httpgd'))"
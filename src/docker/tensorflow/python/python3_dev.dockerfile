FROM biolee/ubuntu:16.04

MAINTAINER li yanan <liyananfamily@gmail.com>

ADD python3_install.sh /python3_install.sh

RUN /python3_install.sh
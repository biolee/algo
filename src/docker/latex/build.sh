#!/bin/bash

# THIS SCRIPT IS USED TO AUTO-BUILD ON TRAVIS-CI

# install texlive 2016 and dependencies
apt-get update && \
apt-get install -y --no-install-recommends \
    texlive-latex-extra \
    texlive-lang-chinese \
    texlive-formats-extra \
    texlive-fonts-recommended \
    fonts-font-awesome \
    lmodern \
    wget \
    xzdec

cd rs/
# intsall latex packages
wget http://mirrors.ctan.org/macros/latex/contrib/ulem/ulem.sty
#!/bin/bash

apt-get update
apt-get install -y \
      python3 \
      python3-dev \
      python3-pip

apt-get autoremove -y
apt-get clean

cd /usr/local/bin
ln -s /usr/bin/python3 python
pip3 install --upgrade pip

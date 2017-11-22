#!/bin/bash

apt-get update
apt-get -y install build-essential \
	  g++ \
	  gcc \
      git \
      vim \
      wget

apt-get autoremove -y
apt-get clean
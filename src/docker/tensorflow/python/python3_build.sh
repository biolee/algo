#!/usr/bin/env bash

      python3 \
      python3-dev \
      python3-pip \
    && apt-get autoremove -y \
    && apt-get clean
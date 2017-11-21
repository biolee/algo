#!/usr/bin/env bash

docker build -t biolee/ubuntu_dev:16.04 -f ${REPO_PATH_ALGO}/src/docker/ubuntu/ubuntu_16_04_dev.dockerfile \
	${REPO_PATH_ALGO}/src/docker/ubuntu
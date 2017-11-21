#!/usr/bin/env bash

docker build -t biolee/mongo:3.4 \
	-f ${REPO_PATH_ALGO}/src/docker/mongodb/mongo_with_auth.dockerfile \
	${REPO_PATH_ALGO}/src/docker/mongodb
#!/usr/bin/env bash

set -x

docker run -d -it --name some-jenkins \
	-v ${DATA_PATH}/jenkins/data:/var/jenkins_home
    -p 10282:8080 \
	-p 50000:50000 \
	registry.docker-cn.com/library/jenkins:latest
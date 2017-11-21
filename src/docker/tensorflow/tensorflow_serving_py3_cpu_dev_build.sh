#!/usr/bin/env bash

docker build -t biolee/tensorflow_serving_dev_py3_cpu \
    -f ${EAPO_PATH_ALGO}/src/docker/tensorflow/tensorflow_serving_py3_cpu_inception.dockerfile \
	${EAPO_PATH_ALGO}/src/docker/tensorflow
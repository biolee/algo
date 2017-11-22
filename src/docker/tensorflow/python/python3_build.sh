#!/usr/bin/env bash

py_dir = "${REPO_PATH_ALGO}/src/docker/tensorflow/python"

docekr build -t biolee/python3 -f ${py_dir}/python3_dev.dockerfile ${py_dir}
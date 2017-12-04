#!/usr/bin/env bash

docker build --network=host \
    -t ${USER}/bazel-grpc-cache-server:latest \
    $(dirname $0)
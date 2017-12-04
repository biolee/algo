#!/usr/bin/env bash

set -x

/home/install/bazel-master/bazel-bin/src/tools/remote_worker/remote_worker \
    --listen_port=${PORT}
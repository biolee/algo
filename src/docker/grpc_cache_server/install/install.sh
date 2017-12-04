#!/usr/bin/env bash

set -x

echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" \
    | tee /etc/apt/sources.list.d/bazel.list
curl https://bazel.build/bazel-release.pub.gpg | apt-key add -
apt-get update && apt-get install -y bazel


set -x

cd $(dirname $0)
# Build server binary according to
# https://github.com/bazelbuild/bazel/blob/master/src/main/java/com/google/devtools/build/lib/remote/README.md
wget https://github.com/bazelbuild/bazel/archive/master.zip
unzip master.zip

cd bazel-master
bazel build -c opt //src/tools/remote_worker
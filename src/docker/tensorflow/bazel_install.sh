#!/bin/bash

# Set up Bazel.
BAZELRC="/root/.bazelrc"
# Install the most recent bazel release.
BAZEL_VERSION=0.7.0

wget https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh

curl -fSsL -o /bazel/LICENSE.txt https://raw.githubusercontent.com/bazelbuild/bazel/master/LICENSE
chmod +x bazel-*.sh
./bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh
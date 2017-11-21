# build from source
```bash

export PYTHON_BIN_PATH="/usr/bin/python"
export PYTHON_LIB_PATH="/usr/local/lib/python2.7/dist-packages"
export TF_VERSION=1.4.0
export PY_VERSION=3

git clone https://github.com/tensorflow/tensorflow.git
#wget https://github.com/tensorflow/tensorflow/archive/v${TF_VERSION}.tar.gz

git checkout v${TF_VERSION}


# CPU
bazel clean
CC_OPT_FLAGS="-march=native" TF_NEED_JEMALLOC=1 TF_NEED_GCP=0 TF_NEED_HDFS=0 TF_ENABLE_XLA=0  TF_NEED_OPENCL=0 TF_NEED_CUDA=0 ./configure
bazel build -c opt --copt=-march=native  //tensorflow/tools/pip_package:build_pip_package

# GPU
bazel clean
CC_OPT_FLAGS="-march=native" TF_NEED_JEMALLOC=1 TF_NEED_GCP=0 TF_NEED_HDFS=0 TF_ENABLE_XLA=0  TF_NEED_OPENCL=0 TF_NEED_CUDA=1 ./configure
bazel build -c opt --copt=-march=native --config=cuda //tensorflow/tools/pip_package:build_pip_package

# pip build and install


bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
sudo pip install /tmp/tensorflow_pkg/tensorflow-${TF_VERSION}-py{PY_VERSION}-none-any.whl
```

# Best Practices

* Build and install from source
* Utilize queues for reading data
* Preprocessing on the CPU
* Use NCHW image data format
* Place shared parameters on the GPU
* Use fused batch norm

# Architecture


# Source Insight

# TF serving
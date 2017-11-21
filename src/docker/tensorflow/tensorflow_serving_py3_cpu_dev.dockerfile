FROM ubuntu:16.04

MAINTAINER li yanan <liyananfamily@gmail.com>

RUN apt-get update && apt-get install -y \
        build-essential \
        curl \
        git \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        mlocate \
        pkg-config \
        python-dev \
        python-numpy \
        python-pip \
        software-properties-common \
        swig \
        zip \
        zlib1g-dev \
        libcurl3-dev \
        openjdk-8-jdk\
        openjdk-8-jre-headless \
        wget \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ADD bazel_install.sh /bazel_install.sh

RUN /bazel_install.sh

ADD tensorflow_serving_py3_cpu_install.sh /tensorflow_serving_py3_cpu_install.sh

RUN /tensorflow_serving_py3_cpu_install.sh

# Set up grpc python dev env
RUN pip install mock grpcio

CMD ["/bin/bash"]
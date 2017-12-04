FROM ubuntu:16.04
MAINTAINER Aaron Xiao <xiaoxiangquan@gmail.com>

RUN apt-get update && apt-get install -y curl openjdk-8-jdk unzip wget
ADD install /home/install
RUN /home/install/install.sh

ENTRYPOINT ["/home/install/entrypoint.sh"]
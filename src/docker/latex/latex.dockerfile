FROM ubuntu:16.04

ADD build.sh /build.sh

RUN /build.sh

ENTRYPOINT ["/bin/bash"]
CMD ["bash"]
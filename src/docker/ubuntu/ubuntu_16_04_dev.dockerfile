FROM ubuntu:16.04

MAINTAINER li yanan <liyananfamily@gmail.com>

ADD ubuntu_install.sh /ubuntu_install.sh
RUN /ubuntu_install.sh

# zsh
RUN apt-get update \
	&& apt-get -y install zsh \
    && apt-get autoremove -y \
    && apt-get clean \
    && wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh \
    && chsh -s `which zsh`

ENTRYPOINT ["/bin/bash"]
CMD ["python"]
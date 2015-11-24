#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM ubuntu:14.04

# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim wget && \
  apt-get install -y lsb-core && \
  rm -rf /var/lib/apt/lists/*

RUN \ 
  adduser --disabled-password --gecos '' lic-user && \
  adduser lic-user sudo && \
  echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY root/software /root/license
COPY root/license /root/license
COPY start.sh /root/license
  
ENV HOME /root

WORKDIR /root/license
RUN tar --owner=lic-user --group=root -xvf ./BX002-PT-00007-r11p13-01rel0.tgz
RUN chmod 700 ./makelinks.sh
RUN chown -R lic-user:users /root
RUN /bin/sh ./makelinks.sh
WORKDIR /root/license/
CMD su -m lic-user -c /root/license/start.sh


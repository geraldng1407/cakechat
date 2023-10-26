# Dockerfile for CPU-only CakeChat setup

FROM ubuntu:18.04

ENV LANG C.UTF-8

# Install some dependencies
RUN apt-get update && apt-get install -y \
        curl \
        git \
        screen \
        tmux \
        sudo \
        nano \
        pkg-config \
        software-properties-common \
        unzip \
        vim \
        wget \
        python3 \
        python3-dev \
        python3-pip \
        python3-setuptools \
        && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# Link python to python3 (since python 2 is used by default in ubuntu docker image)
RUN ln -s /usr/bin/python3 /usr/bin/python


# NEW
RUN apt-get update && apt-get upgrade
RUN apt-get install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libssl-dev \
    libreadline-dev libffi-dev wget libbz2-dev libsqlite3-dev
RUN mkdir /python && cd /python
RUN wget https://www.python.org/ftp/python/3.11.1/Python-3.11.1.tgz
RUN tar -zxvf Python-3.11.1.tgz
RUN cd Python-3.11.1 && ls -lhR && ./configure --enable-optimizations && make install

# RUN apt-get update && apt-get install -y \
#     python-pip

# Install up-to-date pip
RUN pip3 --no-cache-dir install -U pip

# setup cakechat and install dependencies
# RUN git clone https://github.com/lukalabs/cakechat.git /root/cakechat
COPY requirements.txt ./
COPY requirements-local.txt ./
RUN pip3 --no-cache-dir install -r requirements.txt -r requirements-local.txt
RUN mkdir -p /root/cakechat/data/tensorboard

WORKDIR /root/cakechat
# CMD git pull && \
#     pip3 install -r requirements.txt -r /root/cakechat/requirements-local.txt && \
#     (tensorboard --logdir=data/tensorboard 2>data/tensorboard/err.log &); \
#     /bin/bash

CMD (tensorboard --logdir=data/tensorboard 2>data/tensorboard/err.log &); \
    /bin/bash

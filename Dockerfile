FROM ubuntu:16.04

ENV PYENV_ROOT /root/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
ENV LC_ALL en_US.UTF-8

RUN apt-get update && \
    apt-get install -y git \
    emacs \
    locales \
    mercurial \
    build-essential \
    ca-certificates \
    libssl-dev \
    libbz2-dev \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libreadline-dev \
    libsqlite3-dev \
    libxrender1 \
    bzip2 \
    curl \
    wget \
    g++ \
    gcc \
    unzip \
    mecab \
    cmake \
    libboost-dev \
    libmecab-dev \
    libboost-system-dev \
    libboost-filesystem-dev \
    mecab-ipadic-utf8 \
    mecab-jumandic-utf8

RUN locale-gen en_US.UTF-8

# Add OpenCL ICD files for LightGBM
RUN mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

# CRF++
RUN curl -L -o CRF++-0.58.tar.gz 'https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7QVR6VXJ5dWExSTQ'
RUN tar -zxf CRF++-0.58.tar.gz
RUN cd CRF++-0.58 && \
    ./configure && \
    make && \ 
    make install

# CRFsuite
RUN curl -OL https://github.com/downloads/chokkan/liblbfgs/liblbfgs-1.10.tar.gz
RUN tar xvzf liblbfgs-1.10.tar.gz
RUN cd liblbfgs-1.10 && \
    ./configure && \
    make && \
    make install && \

# Open-mpi
RUN cd /usr/local/src && mkdir openmpi && cd openmpi && \
    wget https://www.open-mpi.org/software/ompi/v2.0/downloads/openmpi-2.0.1.tar.gz && \
    tar -xzf openmpi-2.0.1.tar.gz && cd openmpi-2.0.1 && \
    ./configure --prefix=/usr/local/openmpi && make && make install && \
    export PATH="/usr/local/openmpi/bin:$PATH"

# XGBoost
RUN git clone --recursive https://github.com/dmlc/xgboost && \
    cd xgboost && \
    make -j4

# LightGBM
# Add OpenCL ICD files for LightGBM
RUN mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

RUN cd /usr/local/src && mkdir lightgbm && cd lightgbm && \
    git clone --recursive https://github.com/Microsoft/LightGBM && \
    cd LightGBM && mkdir build && cd build && \
    cmake -DUSE_GPU=1 -DOpenCL_LIBRARY=/usr/local/cuda/lib64/libOpenCL.so -DOpenCL_INCLUDE_DIR=/usr/local/cuda/include/ .. && \
    make OPENCL_HEADERS=/usr/local/cuda-8.0/targets/x86_64-linux/include LIBOPENCL=/usr/local/cuda-8.0/targets/x86_64-linux/lib
ENV PATH /usr/local/src/lightgbm/LightGBM:${PATH}

# python
RUN curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
RUN pyenv install anaconda3-5.0.1
RUN pyenv global anaconda3-5.0.1
RUN pip install --upgrade pip
RUN pip install sklearn-crfsuite mecab-python3 xgboost torch torchvision
RUN pyenv rehash
RUN cd /usr/local/src/lightgbm/LightGBM/python-package && python setup.py install --precompile --gpu

# Download JP font
RUN cd /usr/local/share/fonts && \
    wget https://github.com/byrongibson/fonts/raw/master/backup/truetype.original/takao-gothic/TakaoPGothic.ttf
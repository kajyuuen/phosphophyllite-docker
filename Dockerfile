FROM nvidia/cuda:8.0-cudnn6-runtime-ubuntu16.04
ENV PYENV_ROOT /root/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
RUN apt-get update && \
    apt-get install -y git emacs locales mercurial build-essential libssl-dev libbz2-dev libreadline-dev libsqlite3-dev curl gcc unzip && \
    apt-get install -y mecab libmecab-dev mecab-ipadic-utf8 mecab-jumandic-utf8 && \
    curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
RUN locale-gen en_US.UTF-8
RUN pyenv install anaconda3-5.0.1
RUN pyenv global anaconda3-5.0.1
RUN pyenv rehash
RUN pip install --upgrade pip
RUN pip install sklearn-crfsuite mecab-python3
RUN curl -L -o CRF++-0.58.tar.gz 'https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7QVR6VXJ5dWExSTQ'
RUN tar -zxf CRF++-0.58.tar.gz
WORKDIR CRF++-0.58
RUN ./configure
RUN make
RUN make install

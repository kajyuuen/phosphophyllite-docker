FROM nvidia/cuda:8.0-cudnn6-runtime-ubuntu16.04
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV PYENV_ROOT /root/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
RUN apt-get update && \
    apt-get install -y git emacs locales mercurial build-essential libssl-dev libbz2-dev libreadline-dev libsqlite3-dev curl && \
    curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
RUN locale-gen en_US.UTF-8
RUN pyenv install anaconda3-5.0.1
RUN pyenv global anaconda3-5.0.1
RUN pyenv rehash

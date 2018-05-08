# Based on:
# - https://github.com/pypa/pipenv/blob/master/Dockerfile and
# - https://phoikoi.io/2018/04/03/bootstrap-pipenv-debian.html
FROM ubuntu:18.04

# -- Install Pipenv:
RUN apt-get update \
  && apt-get install git build-essential libssl-dev zlib1g-dev libbz2-dev \
     libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev -y \
  && apt install python3-pip python3-setuptools -y \
  && python3 -m pip install --system pipenv

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

# -- Install Application into container:
RUN set -ex && mkdir /app

WORKDIR /app

# -- Adding Pipfiles
ONBUILD COPY Pipfile Pipfile
ONBUILD COPY Pipfile.lock Pipfile.lock

# -- Install dependencies:
ONBUILD RUN set -ex && pipenv install --deploy --system

# --------------------
# - Using This File: -
# --------------------

# FROM fongshway/pipenv

# COPY . /app

# -- Replace with the correct path to your app's main executable
# CMD python3 main.py

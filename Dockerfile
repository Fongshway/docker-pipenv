# Based on: https://github.com/pypa/pipenv/blob/master/Dockerfile
FROM ubuntu:17.10

# -- Install Pipenv:
RUN apt-get update \
  && apt-get install software-properties-common -y \
  && add-apt-repository ppa:pypa/ppa -y \
  && apt-get update \
  && apt-get install git pipenv -y

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

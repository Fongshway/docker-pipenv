################################################################################
# https://hub.docker.com/_/python
FROM python:3.7-slim-buster
################################################################################
ONBUILD ARG REQUIREMENTS_INSTALL_CMD
ONBUILD ENV REQUIREMENTS_INSTALL_CMD="${REQUIREMENTS_INSTALL_CMD:-NOT_DEFINED}"

ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    TERM=xterm \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHON_PIP_VERSION=19.2.3 \
    PYTHON_PIPENV_VERSION=2018.11.26 \
    PIP_NO_CACHE_DIR=1

# -- Install Pipenv:
RUN apt update && apt -y dist-upgrade && \
    apt install -y \
      git \
      sudo \
      vim && \
    pip install pip==${PYTHON_PIP_VERSION} && \
    pip install pipenv==${PYTHON_PIPENV_VERSION} && \
    apt clean && rm -rf /var/lib/apt/lists/*

# -- Add Pipfiles:
ONBUILD COPY \
    Pipfile \
    Pipfile.lock \
    ./

# -- Install dependencies:
ONBUILD RUN set -ex && $REQUIREMENTS_INSTALL_CMD

################################################################################
# Using this file
################################################################################
# FROM fongshway/pipenv:master

# COPY . /app

# -- Replace with the correct path to your app's main executable
# CMD python3 main.py

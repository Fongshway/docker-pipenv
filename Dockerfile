# https://github.com/pypa/pipenv/blob/master/Dockerfile
################################################################################
FROM python:3.6-slim
################################################################################
ONBUILD ARG PIPENV_INSTALL_OPTS="--deploy --system"
ONBUILD ARG APP_USER="user"

ENV PYTHONUNBUFFERED=1 \
    PROJECT_DIR="/opt/app" \
    PYTHONPATH="$PYTHONPATH:$PROJECT_DIR"

# -- Install Pipenv:
RUN apt update && apt -y dist-upgrade && \
    apt install -y \
      git \
      sudo \
      vim && \
    pip install --upgrade pip && \
    pip install pipenv && \
    apt clean && rm -rf /var/lib/apt/lists/* && rm ~/.cache/pip* -rf

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

# -- Create addepar user:
RUN useradd -ms /bin/bash $APP_USER && \
    mkdir -p "$PROJECT_DIR" && \
    chown -R $APP_USER: "$PROJECT_DIR" /usr/local /home/$APP_USER && \
    usermod -aG sudo $APP_USER && \
    sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers

# -- Create application directory:
RUN set -ex && mkdir -p $PROJECT_DIR
WORKDIR "$PROJECT_DIR"

# -- Adding Pipfiles
ONBUILD COPY Pipfile Pipfile
ONBUILD COPY Pipfile.lock Pipfile.lock

# -- Install dependencies:
ONBUILD RUN set -ex && pipenv install $PIPENV_INSTALL_OPTS

USER $APP_USER

################################################################################
# Using this file
################################################################################
# FROM fongshway/pipenv:master

# COPY . /app

# -- Replace with the correct path to your app's main executable
# CMD python3 main.py

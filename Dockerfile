FROM ubuntu:16.04

MAINTAINER Janusz Skonieczny @wooyek
LABEL version="0.9.9"

# TODO: Install python3.6 python3.6-dev python3.6-pip python3.6-venv

# Install tooling for test debuging and libraries needed by geodjango.
# http://stackoverflow.com/a/27931669/260480
RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y git unzip nano wget sudo curl build-essential \
    python python-dev python-pip python-virtualenv \
    python3 python3-dev python3-pip python3-venv \
    spatialite-bin libsqlite3-mod-spatialite \
    postgresql-client-common libpq-dev \
    postgresql postgresql-contrib postgis \
    libproj-dev libfreexl-dev libgdal-dev gdal-bin && \
    python -m pip install pip -U && \
    python3 -m pip install pip -U && \
    apt-get clean && \
    pip install invoke tox coverage pylint pathlib -U && \
    pip3 install invoke tox coverage pylint -U && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8 \
    LANGUAGE en_US:en \ 
    LC_ALL en_US.UTF-8 \
    PYTHONIOENCODING=utf-8 \
    DATABASE_NAME=application-db \
    DATABASE_PASSWORD=application-db-password \
    DATABASE_USER=application-user-user \
    DATABASE_HOST=127.0.0.1 \
    DATABASE_TEST_NAME=application-test-db \
    DATABASE_URL=postgis://application-user-user:application-db-password@127.0.0.1:5432/application-db

# Pass the above envrioment variables through a file to the docker vm
# https://docs.docker.com/engine/reference/commandline/run/#set-environment-variables--e---env---env-file
# They will be used to create a default database on start

COPY geodjango-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/geodjango-entrypoint.sh
ENTRYPOINT ["geodjango-entrypoint.sh"]

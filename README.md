# Docker for GeoDjango with PostGIS and SpatiaLite

Test environment for GeoDjango projects with PostGIS and SpatiaLite support out of the box.

[![Docker Pulls](https://img.shields.io/docker/pulls/wooyek/geodjango.svg)](https://hub.docker.com/r/wooyek/geodjango/)
[![Docker Stars](https://img.shields.io/docker/stars/wooyek/geodjango.svg)](https://hub.docker.com/r/wooyek/geodjango/)
[![Docker Automated build](https://img.shields.io/docker/automated/wooyek/geodjango.svg)](https://hub.docker.com/r/wooyek/geodjango/)
[![Travis](https://img.shields.io/travis/wooyek/docker-geodjango.svg)](https://travis-ci.org/wooyek/docker-geodjango)

## BitBucket Pipelines support

You can use this as a test image with BitBucket Pipelines, an example:

```yaml
image: wooyek/geodjango

pipelines:
  default:
    - step:
      script:        
        # Pipelines overrides default docker entry point, we need to run it maually
        - docker-entrypoint.sh  
        - tox
```
 
## Tox support

Tox is is the best way to encapsulate your tests, here's an example:

```ini
[tox]
envlist = py35,py27
skipsdist = True

[testenv]
passenv =
    DJANGO_SETTINGS_MODULE
    DATABASE_PASSWORD
    DATABASE_USER
    DATABASE_HOST
    DATABASE_NAME
    DATABASE_TEST_NAME
    

setenv =
    TOX_ENVBINDIR = {envbindir}
    LIBRARY_PATH = /usr/local/lib
    CPATH=/usr/local/include
    PYTHONIOENCODING = utf-8

commands =
    coverage erase
    coverage run setup.py test
    coverage report
    coverage xml

deps =
    -rrequirements.txt
    -rrequirements-dev.txt
```

# Build docker image 

If you don't have [Docker installed](https://docs.docker.com/engine/installation/#supported-platforms), 
you can use [Vagrant](https://www.vagrantup.com/downloads.html) development environment: 

```bash
vagrant up
vagrant ssh
```

Replace `wooyek/geodjango` with your own image name, replace `/vagrant/` with a proper path if you don't use Vagrant:

```bash
docker build -t wooyek/geodjango /vagrant/
docker push wooyek/geodjango
```

# Run and test 

We can always [check docker machine environment variables](https://docs.docker.com/edge/engine/reference/run/#env-environment-variables) 
by this command (you should see default values set in [Dockerfile](Dockerfile)):

```bash
docker run --rm wooyek/geodjango env
```

We can use host environment, but we still need to to pass environment variable names in a command. 

I find the cleaniest easiest way is to create a separate file containing all the environment variables.
Let's prepare our environment file with some variable substitution [from a sample file](sample/environment.env). 
This is a one time operations. 

```bash
ENV_FILE=/vagrant/sample/environment.env
source <(sed -E 's/[^#]+/export &/' ${ENV_FILE})
envsubst < ${ENV_FILE} | tee /vagrant/environment.env
```

Let's check them out:

```bash
docker run --rm --env-file /vagrant/environment.env wooyek/geodjango env
```

Now we can run tests from a sample project. We will map local `vagrant` folder to a docker volume 
to make them accessible from inside a running container. We'll also override `DJANGO_SETTINGS_MODULE` to point to all-in-one settings file, 
instead of more specialized `website.settings.testing` module used when settings are split info multiple modules: 

```bash
docker run --rm -it --name qa \
    --volume=/vagrant:/vagrant \
    --workdir="/vagrant" \
    --memory=4g \
    --memory-swap=4g \
    --entrypoint=/bin/bash \
    --env-file /vagrant/environment.env \
    --hostname ${HOSTNAME} \
    -e DJANGO_SETTINGS_MODULE=website.settings \
    wooyek/geodjango \
    docker-entrypoint.sh tox -c /vagrant/sample/awesome-project
```

There should be a one passed [test filtering on distance](sample/awesome-project/geoapp/tests.py).

## Cleanup
 
Docker images take some space, if you need to clear that out use one of those prune commands:

```bash
docker system prune
docker image prune
docker container prune
```

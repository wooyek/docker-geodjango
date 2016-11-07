# Docker for GeoDjango with PostGIS and SpatiaLite

Test environment for GeoDjango projects with PostGIS and SpatiaLite support out of the box.

[![Docker Pulls](https://img.shields.io/docker/pulls/wooyek/geodjango.svg)](https://hub.docker.com/r/wooyek/geodjango/)
[![Docker Stars](https://img.shields.io/docker/stars/wooyek/geodjango.svg)](https://hub.docker.com/r/wooyek/geodjango/)
[![Docker Automated build](https://img.shields.io/docker/automated/wooyek/geodjango.svg)](https://hub.docker.com/r/wooyek/geodjango/)

## BitBucket Pipelines support

You can use this as a test image with BitBucket Pipelines, an example:

```
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

```
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

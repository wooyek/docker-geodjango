.PHONY: help bump build sync release test
.DEFAULT_GOAL := help

help:
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}'

bump: ## incremenet version number
	bumpversion patch

build: ## build docker container image
	docker build -t wooyek/geodjango .

sync: ## sync master and develop branches in both directions
	git checkout develop
	git pull origin develop --verbose
	git checkout master
	git pull origin master --verbose
	git checkout develop
	git merge master --verbose
	git checkout master
	git merge develop --verbose
	git checkout develop

release: sync bump ## sync, bump and push to repo to trigger autmated build
	git checkout develop
	git merge master --verbose
	git push origin develop --verbose
	git push origin master --verbose

test: ## run sample test inside a container
	echo 'Running tox tests inside the container'
	docker run --rm -it --name qa --volume=$(shell pwd):/vagrant --workdir="/vagrant" --entrypoint=/bin/bash -e DJANGO_SETTINGS_MODULE=website.settings wooyek/geodjango docker-entrypoint.sh tox -c /vagrant/sample/awesome-project
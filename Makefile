.PHONY: help bump build sync release
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

release: sync bump build ## sync, bump and push docker image
	git checkout develop
	git merge master --verbose
	git push origin develop --verbose
	git push origin master --verbose



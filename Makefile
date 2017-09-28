bump:
	bumpversion patch

build:
	docker build -t wooyek/geodjango .

## Sync master and develop branches in both directions
sync:
	git checkout develop
	git pull origin develop --verbose
	git checkout master
	git pull origin master --verbose
	git checkout develop
	git merge master --verbose
	git checkout master
	git merge develop --verbose
	git checkout develop

release: sync bump build
	git checkout develop
	git merge master --verbose
	git push origin develop --verbose
	git push origin master --verbose
	docker push wooyek/geodjango



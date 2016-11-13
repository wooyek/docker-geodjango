# coding=utf-8
# Copyright (C) 2015 Janusz Skonieczny
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
from invoke import task


@task
def bump(ctx, patch=True):
    """
    Make sure that develop and master are in sync then bump version
    """
    ctx.run("git checkout develop")
    ctx.run("git pull origin develop --verbose")
    ctx.run("git push origin develop --verbose")
    ctx.run("git checkout master")
    ctx.run("git merge develop --verbose")
    ctx.run("git pull origin master --verbose")
    if patch:
        ctx.run("bumpversion patch")
    else:
        ctx.run("bumpversion minor")
    ctx.run("git push origin master --verbose")
    ctx.run("git checkout develop")
    ctx.run("git merge master --verbose")
    ctx.run("git push origin develop --verbose")


def push(ctx, branch='develop', remote='origin'):
    ctx.run("git checkout {branch}".format(branch=branch))
    ctx.run("git push {remote} {branch}  --verbose".format(remote=remote, branch=branch))


@task(bump)
def release(ctx, branch='develop', remote='origin'):
    """
    Collect and compile assets, add, commit and push to production remote
    """
    push(ctx, branch=branch, remote=remote)
    ctx.run("git checkout develop")

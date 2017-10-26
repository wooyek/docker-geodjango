#!/usr/bin/env bash
echo "============================================="
echo "Docker image wooyek/geodjango version: 0.9.19"
echo "============================================="
echo "------> Starting and setting up Postgres database"
/etc/init.d/postgresql start
# First you need to enable postgis for all new databases. This will remove superuser requirement during db initialization
# http://stackoverflow.com/a/35209186/260480
sudo -u postgres -E psql -d template1 -c "CREATE EXTENSION IF NOT EXISTS postgis;"

# Create primary and test databases
echo "------> Creating user ${DATABASE_USER}"
sudo -u postgres -E sh -c 'createuser ${DATABASE_USER}'
sudo -u postgres -E psql -c "ALTER USER \"${DATABASE_USER}\" PASSWORD '${DATABASE_PASSWORD}';"

echo "------> Creating databases ${DATABASE_NAME} and ${DATABASE_TEST_NAME}"
sudo -u postgres -E sh -c 'createdb ${DATABASE_NAME}'
sudo -u postgres -E sh -c 'createdb ${DATABASE_TEST_NAME}'

echo "------> Setting up GDAL support "
export CPLUS_INCLUDE_PATH=/usr/include/gdal
export C_INCLUDE_PATH=/usr/include/gdal
echo "------> Please note system GDAL version"
gdal-config --version

echo "------> Please note tooling versions"
python -V
python3 -V
easy_install --version
pip --version
tox --version
git --version
virtualenv --version
python3 -m venv -h

echo "------> Running command passed down to docker..."
exec "$@"


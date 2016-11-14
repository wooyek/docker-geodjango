#!/usr/bin/env bash
# =========================
# Setup Postgres data base
# =========================
/etc/init.d/postgresql start

echo "*** Setting up Postgres database ***"
# First you need to enable postgis for all new databases. This will remove superuser requirement during db initialization
# http://stackoverflow.com/a/35209186/260480
sudo -u postgres -E psql -d template1 -c "CREATE EXTENSION IF NOT EXISTS postgis;"

# Create primary and test databases
echo "Creating user ${DATABASE_USER}"
sudo -u postgres -E sh -c 'createuser ${DATABASE_USER}'
sudo -u postgres -E psql -c "ALTER USER \"${DATABASE_USER}\" PASSWORD '${DATABASE_PASSWORD}';"

echo "Creating databases ${DATABASE_NAME} and ${DATABASE_TEST_NAME}"
sudo -u postgres -E sh -c 'createdb ${DATABASE_NAME}'
sudo -u postgres -E sh -c 'createdb ${DATABASE_TEST_NAME}'

echo "*** Setting up GDAL support ***"
export CPLUS_INCLUDE_PATH=/usr/include/gdal
export C_INCLUDE_PATH=/usr/include/gdal

echo "*** Running command passed down to docker ***"
exec "$@"


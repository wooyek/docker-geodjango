#!/usr/bin/env bash
# =========================
# Setup Postgres data base
# =========================
/etc/init.d/postgresql start

# First you need to enable postgis for all new databases. This will remove superuser requirement during db initialization
# http://stackoverflow.com/a/35209186/260480
sudo -u postgres -E psql -d template1 -c "CREATE EXTENSION IF NOT EXISTS postgis;"

# Create primary and test databases
sudo -u postgres -E sh -c 'createuser ${DATABASE_USER}'
sudo -u postgres -E sh -c 'createdb ${DATABASE_NAME}'
sudo -u postgres -E sh -c 'createdb ${DATABASE_TEST_NAME}'
sudo -u postgres -E psql -c "ALTER USER \"${DATABASE_USER}\" PASSWORD '${DATABASE_PASSWORD}';"

exec "$@"


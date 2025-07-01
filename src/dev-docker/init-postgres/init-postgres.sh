#!/bin/bash
set -e

# Create the databases
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname=postgres <<-EOSQL
  CREATE DATABASE "ConcertoDb";
  CREATE DATABASE "Keycloak";
EOSQL

# Load dumps into respective databases
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname=ConcertoDb < /dumps/init_concerto_dump.sql
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname=Keycloak < /dumps/init_keycloak_dump.sql

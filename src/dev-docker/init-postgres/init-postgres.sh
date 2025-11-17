#!/bin/bash
set -e

# Create the databases
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname=postgres <<-EOSQL
  -- Create Keycloak database if it doesn't exist (PostgreSQL syntax)
    SELECT 'CREATE DATABASE "Keycloak"'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'Keycloak')\gexec
    
    -- Grant privileges
    GRANT ALL PRIVILEGES ON DATABASE "Keycloak" TO "$POSTGRES_USER";
    
    -- Ensure ConcertoDb exists (PostgreSQL syntax)  
    SELECT 'CREATE DATABASE "ConcertoDb"'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'ConcertoDb')\gexec
    
    -- Grant privileges
    GRANT ALL PRIVILEGES ON DATABASE "ConcertoDb" TO "$POSTGRES_USER";
EOSQL

# Update PostgreSQL configuration to accept all connections
echo "listen_addresses = '*'" >> /var/lib/postgresql/data/postgresql.conf
echo "port = 5432" >> /var/lib/postgresql/data/postgresql.conf

# Update pg_hba.conf to allow password authentication from all Docker networks
cat >> /var/lib/postgresql/data/pg_hba.conf << 'PGHBA'

# Docker network connections
host all all 172.16.0.0/12 md5
host all all 172.17.0.0/12 md5
host all all 172.18.0.0/12 md5
host all all 172.19.0.0/12 md5
host all all 172.20.0.0/12 md5
host all all all md5
PGHBA

# Load dumps into respective databases
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname=ConcertoDb < /dumps/init_concerto_dump.sql
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname=Keycloak < /dumps/init_keycloak_dump.sql

echo "host all all all md5" >> /var/lib/postgresql/data/pg_hba.conf

# Reload PostgreSQL configuration
pg_ctl reload
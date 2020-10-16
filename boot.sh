service postgresql restart
psql -c "CREATE USER nominatim WITH PASSWORD 'nominatim';"
psql -c "create database nominatim;"
psql -c "grant all privileges on database nominatim to nominatim;"
psql -c "ALTER USER nominatim SUPERUSER;"
psql -c "CREATE EXTENSION postgis;"
psql -c "CREATE EXTENSION hstore;"
psql -c "drop database nominatim;"

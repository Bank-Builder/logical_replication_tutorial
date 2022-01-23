#!/bin/bash

echo "Creating Databases ..."
# create databases
docker exec -it db1 createdb -U postgres test
docker exec -it db2 createdb -U postgres test
sleep 2

echo "Creating TABLE test in each database ..."
# create the same table in each database
docker exec -it db1 psql -h 127.0.0.1 -U postgres -p 5432 -d test -c "CREATE TABLE edge(id INTEGER PRIMARY KEY, temp INTEGER);"
docker exec -it db2 psql -h 127.0.0.1 -U postgres -p 5432 -d test -c "CREATE TABLE edge(id INTEGER PRIMARY KEY, temp INTEGER);"

echo "Inserting some initial data into database 1 ..."
# insert some initial data into database 1
docker exec -it db1 psql -h localhost -U postgres -p 5432 -d test -c "INSERT INTO edge(id, temp) VALUES (1,12), (2,14), (3,21), (5,11);"

echo "Creating user 'repuser' and granting connect permissions ..."
# setup replication user repuser & connect permissions on db1
docker exec -it db1 psql -h localhost -U postgres -p 5432 -d test -c "CREATE USER repuser WITH REPLICATION PASSWORD 'password';"
docker exec -it db1 psql -h localhost -U postgres -p 5432 -d test -c "GRANT CONNECT ON DATABASE test to repuser;"
docker exec -it db1 psql -h localhost -U postgres -p 5432 -d test -c "GRANT USAGE ON SCHEMA public to repuser;"
docker exec -it db1 psql -h localhost -U postgres -p 5432 -d test -c "GRANT SELECT ON TABLE edge to repuser;"


echo "Modifying pg_hba.conf in db1 to allow subscriber to connect ..."
# add the permissions in db1 pg_hba.conf
echo 'host     all     repuser     0.0.0.0/0     md5' | sudo tee -a db1/pg_hba.conf

echo "Modifying postgresql.conf in both databases to configure wal_level = logical ..."
# add the postgresql.conf settings in the respective databases
echo "wal_level = logical" | sudo tee -a db1/postgresql.conf
echo "wal_level = logical" | sudo tee -a db2/postgresql.conf

echo "Restarting both databases to use the modified configurations ..."
# restart the databases to load configs
docker restart db1
docker restart db2

echo "Confirming the setup is correct as expected ..."
# confirm initial state of databases
echo "Database 1: "
docker exec -it db1 psql -h localhost -U postgres -p 5432 -d test -c "SELECT * FROM edge;"
echo "\n"
docker exec -it db2 psql -h localhost -U postgres -p 5432 -d test -c "SELECT * FROM edge;"
echo "\n"


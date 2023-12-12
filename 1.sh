#!/bin/bash

# make directories for mounted volume
mkdir -p db1
mkdir -p db2
 

#  initilise docker db instances on a shared network
docker network create priv_net
docker run -d  -p 5432:5432 --name db1 -e POSTGRES_PASSWORD=postgres -v $PWD/db1:/var/lib/postgresql/data --network priv_net postgres:16
docker run -d  -p 5433:5432 --name db2 -e POSTGRES_PASSWORD=postgres -v $PWD/db2:/var/lib/postgresql/data --network priv_net postgres:16

# list the IP address of db1 & ensure it ias reachable by docker dns name
DB_1=$(echo "$(docker exec -it db1 hostname -i)" | sed 's/\r//g')
echo "export DB_1=$DB_1" > database_1.ip
RANDOM_PASS=$(echo "$(openssl rand -base64 32 | head -c 16)")
echo "export RANDOM_PASS=$RANDOM_PASS" > random.pass

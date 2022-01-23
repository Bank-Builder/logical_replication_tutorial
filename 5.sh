#!/bin/bash

echo "Cleaning up and removing containers and folders ..."
#  stop and remove our containers and clean up folders
docker stop db1
docker stop db2
docker rm db1
docker rm db2

docker network rm priv_net

sudo rm -rf db1/
sudo rm -rf db2/
rm database_1.ip

echo ".... all removed ... "

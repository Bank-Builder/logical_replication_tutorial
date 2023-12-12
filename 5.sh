#!/bin/bash

echo "Cleaning up and removing containers and folders ..."
#  stop and remove our containers and clean up folders
docker stop db1 > /dev/null 2>&1
docker stop db2 > /dev/null 2>&1
docker rm db1 > /dev/null 2>&1
docker rm db2 > /dev/null 2>&1

docker network rm priv_net > /dev/null 2>&1

sudo rm -rf db1/ > /dev/null 2>&1
sudo rm -rf db2/ > /dev/null 2>&1
rm random.pass > /dev/null 2>&1

echo ".... all removed ... "

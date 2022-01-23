# Postgresql 14 - Logical Replication Tutorial

This tutorial is to show how to get logical replication working between two postgres 14 databases for a given table.  It makes use of docker images so does not require you to have postgres installed locally and is intended for Linux platforms only.

Conceptually it is extremely easy to setup logical replication but there are a few gotcha's wrt to role permissions required.

## Quick Start

Just run the demo scripts 1 to 5 in order to see what is contained in the tutorial:

* [./1.sh](./1.sh) - creates directories to mount your database data, initilises the docker db instances we need and it retreieves the IP address of the `publication` database to which we will later subscribe.

* [./2.sh](./2.sh) - using the `exec` command we create the databases in each container, create the same tables in each, add some data to `db1` , create & grant permission to the `repuser` & modify the configs for connection permissions. We dump the results of the table `edge` from each of `db1` and `db2` and see that they are not the same as replication has not yet occurred.

* [./3.sh](./3.sh) - we create a publication on postgres server `db1`, and then use the previously saved IP of `db1` to setup a `subscription` from postgres server `db2` to connect to the publication of `db1`. We dump the results of the table `edge` from each of `db1` and `db2` and see that they are  now the same as replication has been initiated.

* [./4.sh](./4.sh) - we now convince ourselves it is working by instering some more data into table `edge` in `db1` and then look at table `edge` in `db2` to see the transactions arrive...

* [./5.sh](./5.sh) - stops and removes our database containers, removes the data folders and the temporary file `database_1.ip` we sourced earlier to save the IP of the publication server viz. `db1` so we could subscribe to it. 

> I trust that this tutorial will be useful to someone trying to get started with Postgresql 14 Logical Replication.

## docker commands

The following docker commands came in very helpful with this tutorial.

```
docker pull postgres:latest   # currently version 14

# we run -d ie detached and $PWD provide the current working directory for the local path
# we use a software defined network between the containers so db2 can connect to db1
docker run -d  -p 5432:5432 --name db1 -e POSTGRES_PASSWORD=postgres -v $PWD/db1:/var/lib/postgresql/data --network priv_net postgres:latest

# we can restart an image because we are persisting the database volume /var/lib/postgresql/data after making changes to it.
docker restart db1

docker exec -it db1 psql -h localhost -U postgres -p 5432 -d test -c "<<Any valid SQL query>>;"
```
Note that although we exposed port 5433 to the host machine we never used this port mapping as all commands were executed **within** the image `db2` on localhost within the image and therefore port 5432 was used.


## Useful psql commands

We execute this command on `db1` the publisher:
```
SELECT * FROM pg_publication;

  oid  | pubname  | pubowner | puballtables | pubinsert | pubupdate | pubdelete | pubtruncate | pubviaroot 
-------+----------+----------+--------------+-----------+-----------+-----------+-------------+------------
 16391 | edge_pub |       10 | f            | t         | t         | t         | t           | f
(1 row)

```

We execute this command on `db2` the subscriber:
```
SELECT * FROM pg_subscription;"

  oid  | subdbid | subname  | subowner | subenabled | subbinary | substream |                         subconninfo                          | subslotname | subsynccommit | subpublications 
-------+---------+----------+----------+------------+-----------+-----------+--------------------------------------------------------------+-------------+---------------+-----------------
 16390 |   16384 | edge_sub |       10 | t          | f         | f         | dbname=test host=192.168.16.2 user=repuser password=password | edge_sub    | off           | {edge_pub}

```

## Advanced Configuration

> If anybody wants to add some addition information about wal settings or replication slots or some other advanced settings feel free to submit a Pull Request or log an Issue.

---
(C) Copyright Bank-Builder, 2022 and licensed under the [MIT License](./LICENSE)
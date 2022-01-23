# Postgres 14 - Logical Replication Tutorial

This tutorial is to show how to get logical replication working between two postgres 14 databases for a given table.  It makes use of docker images so does not require you to have postgres installed locally and is intended for Linux platforms only.

Conceptually it is extremely easy to setup logical replication but there are a few gotcha's wrt to role permissions required.

## Quick Start

Just run the demo scripts 1 to 5 in order to see what is contained in the tutorial:

* [./1.sh](./1.sh) - creates directories to mount your database data, initilises the docker db instances we need and it retreieves the IP address of the `publication` database to which we will later subscribe.

* [./2.sh](./2.sh) - using the `exec` command we create the databases in each container, create the same tables in each, add some data to `db1` , create & grant permission to the `repuser` & modify the configs for connection permissions. We dump the results of the table `edge` from each of `db1` and `db2` and see that they are not the same as replication has not yet occurred.

* [./3.sh](./3.sh) - we create a publication on postgres server `db1`, and then use the previously saved IP of `db1` to setup a `subscription` from postgres server `db2` to connect to the publication of `db1`. We dump the results of the table `edge` from each of `db1` and `db2` and see that they are  now the same as replication has been initiated.

* [./4.sh](./4.sh)

* [./4.sh](./4.sh)

> I trust that this tutorial will be useful to someone trying to get started with postgres 14 logical replication.

---
(C) Copyright Bank-Builder, 2022 and licensed under the [MIT License](./LICENSE)
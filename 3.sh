#!/bin/bash
source database_1.ip
echo "Database 1 = $DB_1"

source random.pass

echo "Create publication on database 1 ..."
docker exec -it db1 psql -h 127.0.0.1 -U postgres -p 5432 -d test -c "CREATE PUBLICATION edge_pub FOR TABLE edge;"


# echo "create subscription on database 2 ..."
docker exec -it db2 psql -h 127.0.0.1 -U postgres -p 5432 -d test -c "CREATE SUBSCRIPTION edge_sub CONNECTION 'dbname=test host=$DB_1 user=repuser password=$RANDOM_PASS' PUBLICATION edge_pub WITH (copy_data = true);"

# Data in database 1 after pub sub
docker exec -it db1 psql -h localhost -U postgres -p 5432 -d test -c "SELECT * FROM edge;"

# Data in database 2 after pub sub
docker exec -it db2 psql -h localhost -U postgres -p 5432 -d test -c "SELECT * FROM edge;"
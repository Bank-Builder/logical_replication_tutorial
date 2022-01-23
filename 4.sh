#!/bin/bash
echo "test the pub-sub with INSERT INTO edge(id, temp) VALUES (0,99); into database 1 ..."
docker exec -it db1 psql -h localhost -U postgres -p 5432 -d test -c "INSERT INTO edge(id, temp) VALUES (0,99);"

echo "Now take a peek at database 2 ..."
docker exec -it db2 psql -h localhost -U postgres -p 5432 -d test -c "SELECT * FROM edge;"
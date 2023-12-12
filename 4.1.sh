#!/bin/bash
echo "test the pub-sub with UPDATE edge SET temp=66 WHERE id=0; into database 1 ..."
docker exec -it db1 psql -h localhost -U postgres -p 5432 -d test -c "UPDATE edge SET temp=66 WHERE id=4;"

echo "Now take a peek at database 2 ..."
docker exec -it db2 psql -h localhost -U postgres -p 5432 -d test -c "SELECT * FROM edge;"
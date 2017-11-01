#!/bin/bash
set -e 

ALGOS="Lawer AllD Impl10 Impl50 SAT2 SAT4"
#ALGOS=`echo "SELECT DISTINCT Algorithm FROM MinGvl;" | SQLite/sqlite3 Diagonal.sqlite`

for DATASET in D M N; do 
  SIZE=`echo "SELECT COUNT(*) FROM MinGvlCharts WHERE LockChart LIKE '$DATASET%';" | SQLite/sqlite3 Diagonal.sqlite`

  for ALGO in $ALGOS; do
    SUCC=`echo "SELECT COUNT(*) FROM MinGvl WHERE LockChart LIKE '$DATASET%' AND Algorithm = '$ALGO' AND Enterings > 0;" | SQLite/sqlite3 Diagonal.sqlite`
    
    echo "100*$SUCC/$SIZE" | bc > "MinGvl$DATASET$ALGO.txt"
  done
done
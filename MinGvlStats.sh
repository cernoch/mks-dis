#!/bin/bash
set -e 

ALGO=`echo "$1" | sed 's/^.//g'`
[ -n "$ALGO" ] || ALGO=Lawer

DATASET=`echo "$1" | sed 's/^\(.\).*$/\1/g'`
[ -n "$DATASET" ] || DATASET=D

SIZE=`echo "SELECT COUNT(*) FROM MinGvlCharts WHERE LockChart LIKE '$DATASET%';" | SQLite/sqlite3 Diagonal.sqlite`
SUCC=`echo "SELECT COUNT(*) FROM MinGvl WHERE LockChart LIKE '$DATASET%' AND Algorithm = '$ALGO' AND Enterings > 0;" | SQLite/sqlite3 Diagonal.sqlite`
echo "100*$SUCC/$SIZE" | bc
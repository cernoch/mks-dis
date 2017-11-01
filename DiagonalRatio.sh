#!/bin/bash

echo -n "\\begin{tabular}{l|"
for D in {2..16}; do
    echo -n "r"
done
echo "}"

echo -n "       "
for D in {2..16}; do
    printf '& $d=%2d$ ' $D
done
echo "\\\\\\hline"

export LC_NUMERIC=C
for P in {1..16}; do
    printf "\$p=%2d\$" "$P"
    for D in {2..16}; do
        THEORY=`SQLite/sqlite3 Diagonal.sqlite "SELECT theory FROM Sat WHERE p=$P AND d=$D"`
        RATIO=`echo $D^$P/$THEORY | bc -l`
        printf ' & $%4.2f$' "$RATIO"
    done
    echo "\\\\"
done

echo "\\end{tabular}"

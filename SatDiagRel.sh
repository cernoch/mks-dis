#!/bin/bash

echo -n "\\begin{tabular}{l|"
for D in {2..16}; do
    echo -n "r"
done
echo "}"

echo -n "       "
for D in {2..16}; do
    echo -n "& \$d=$D\$"
done
echo "\\\\\\hline"

for P in {1..16}; do

    printf "\$p=%2d\$" "$P"
    for D in {2..16}; do
        KEYS=`SQLite/sqlite3 Diagonal.sqlite "SELECT keys FROM Sat WHERE p=$P AND d=$D"`
        THEORY=`SQLite/sqlite3 Diagonal.sqlite "SELECT theory FROM Sat WHERE p=$P AND d=$D"`
        if [ "$KEYS" -eq "$THEORY" ]; then
            printf ' & $%7d\%%$' 100 | sed 's/,/./g'
        else
            MULT=`echo "100*$KEYS" | bc -l`
            if [ "$MULT" -lt $THEORY ]; then
                RATIO=`echo "l($KEYS/$THEORY)/l(10)" | bc -l | sed 's/\./,/g'`
                printf ' & $10^{%4.0f}$' "$RATIO" | sed 's/,/./g'
            else
                RATIO=`echo "100*$KEYS/$THEORY" | bc -l | sed 's/\./,/g'`
                printf ' & $%7.0f\%%$' "$RATIO" | sed 's/,/./g'
            fi
        fi
    done
    echo "\\\\"
done

echo "\\end{tabular}"

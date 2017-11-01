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
            printf " & \$%13d\$" "$KEYS"
        else
            printf " & \$\\mathit{%4d}\$" "$KEYS"
        fi
    done
    echo "\\\\"
done

echo "\\end{tabular}"

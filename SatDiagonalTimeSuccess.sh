#!/bin/bash

echo -n "\\begin{tabular}[|l||"
for D in {2..10}; do
    echo -n "r|"
done
echo "]"

echo -n "      "
for D in {2..10}; do
    echo -n "& \$d=$D\$"
done
echo "\\\\"

for P in {1..10}; do
    echo -n "\$p=$P\$"

    for D in {2..10}; do
        VALID=`SQLite/sqlite3 DiagonalBenchmark.sqlite "SELECT COUNT(*) FROM SatDiagonal WHERE p=$P AND d=$D AND timeout='false' AND error='false'"`

        if [ "$VALID" -lt 1 ]; then
            echo -n " & \$?\$     "
        else
            TIME=`SQLite/sqlite3 DiagonalBenchmark.sqlite "SELECT printf(\"%.2f\", CPU) FROM SatDiagonal WHERE p=$P AND d=$D"`
            if [ "$TIME" = "0.00" ]; then
                echo -n " & \$< 0.01\$"
            else
                echo -n " & \$$TIME\$"
            fi
        fi
    done

    echo "\\\\"
done

echo "\\end{tabular}"

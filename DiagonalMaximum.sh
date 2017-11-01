#!/bin/bash

echo -n "\\begin{tabular}{l|"
for D in {2..16}; do
    echo -n "r"
done
echo "}"

echo -n "       "
for D in {2..11}; do
    echo -n "& \$d=$D\$"
done
echo "\\\\\\hline"

for P in {1..16}; do
    printf "\$p=%2d\$" "$P"
    for D in {2..11}; do
        THEORY=`SQLite/sqlite3 Diagonal.sqlite "SELECT theory FROM Sat WHERE p=$P AND d=$D"`
        MANTISSA=`echo -n "$THEORY" | sed 's/\([0-9]*[1-9]\)\(0*\)$/\1/g'`
        EXPONENT=`echo -n "$THEORY" | sed 's/\([0-9]*[1-9]\)\(0*\)$/\2/g' | wc -c`
        if [ "$EXPONENT" -gt 3 ]; then
            printf ' & $%3d \cdot 10^{%2d}$' "$MANTISSA" "$EXPONENT"
        elif [ "$THEORY" -ge 100000000000 ]; then
            printf ' & {\\tiny $%8d$}' "$THEORY"
        elif [ "$THEORY" -ge 10000000 ]; then
            printf ' & {\\scriptsize $%8d$}' "$THEORY"
        else                  
            printf ' & $%16d$' "$THEORY"
        fi
    done
    echo "\\\\"
done

echo "\\end{tabular}"

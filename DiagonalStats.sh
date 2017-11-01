#!/bin/bash

statistics() {
SQLite/sqlite3 Diagonal.sqlite <<-EOF
.load SQLite/extension-functions
SELECT exp(SUM(log($1)-log($2))/COUNT(*)) FROM Renamed
WHERE $1 IS NOT NULL AND $2 IS NOT NULL AND plain == '$3';
EOF
}


ALGORITHMS="Baseline SAG Greedy Exact"

echo -n '\begin{tabular}{cr|'
for F in $ALGORITHMS; do
    echo -n 'l';
done
echo "}"


printf '%53s&%9s' '' ''
for F in $ALGORITHMS; do
    printf ' & %13s' ${F,,}
done
echo '\tabularnewline\hline'

export LC_NUMERIC=C
for D in Plain Skew; do
    for F in $ALGORITHMS; do    

        FMT_STR='\\multirow{4}{*}{\\rotatebox[origin=c]{90}{%9s}} '
    
        if [ "$F" != Baseline ]; then
            printf '%53s' ''
        elif [ "$D" = Plain ]; then
            printf "$FMT_STR" uniform
        elif [ "$D" = Skew ]; then
            printf "$FMT_STR" realistic
        else
            printf "$FMT_STR" '?'
        fi

        printf '& %8s' ${F,,}
        for G in $ALGORITHMS; do
            if [ "$F" = "$G" ]; then
                printf ' &         %4d ' 1
            else
                VALUE=`statistics ${F,} ${G,} ${D,}`
                FORMAT=`printf '%4.2f' $VALUE`
                PERCENT=${FORMAT/./}
                if [ "$PERCENT" -gt 100 ]; then
                    printf " & \\\\textbf{%4.2f}" $VALUE
                else
                    printf " &         %4.2f " $VALUE
                fi          
            fi
        done

        if [ "$F" = Exact -a "$D" = Plain ]; then
            echo '\tabularnewline\hline'
        else
            echo '\tabularnewline'
        fi
    done
done

echo -n '\end{tabular}'

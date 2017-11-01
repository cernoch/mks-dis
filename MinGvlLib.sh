export LC_NUMERIC=C

runQuery() {
    SQLite/sqlite3 Diagonal.sqlite
}

algoRatio() {
  {
    echo ".load SQLite/extension-functions"
    echo "SELECT exp(SUM(log($1)-log($2))/COUNT(*)) FROM MinGvlResults WHERE $1 IS NOT NULL AND $1 > 0 AND $2 IS NOT NULL AND $2 > 0 AND LockChart LIKE '$3';"
  } | SQLite/sqlite3 Diagonal.sqlite
}

printScientific() {
    printf "%.1e" $1 | sed 's/e+*\(-*\)0*\(.*\)$/\\cdot 10^{\1\2}/'
}

printAutoFormat() {
    VALUE=`printf '%.100f' $1`
    if (( $(echo "$VALUE == 0" | bc -l) )); then
        VALUE=0.0
    elif (( $(echo "$VALUE >= 1000" | bc -l) )); then
        VALUE=`printScientific $1`
    elif (( $(echo "$VALUE <= 0.01" | bc -l) )); then
        VALUE=`printScientific $1`
    else
        VALUE=`printf '%.2f' $1`
    fi
    printf " & $%$2s$3$" "$VALUE"
}

printAlgorithm() {
    if ( echo "$1" | grep -q "SAT[0-9]*" ); then
        echo SAT
    elif [ "$1" = "Lawer" ]; then
        echo "Autom."
    elif ( echo "$1" | grep -q "Impl[0-9]*" ); then
        echo "Implicit"
    elif [ "$1" = "AllD" ]; then
        echo "CSP"
    else
        echo "Unknown"
    fi
}

algorithmOrder() {
    if ( echo "$1" | grep -q "SAT[0-9]*" ); then
        echo "4 $1"
    elif [ "$1" = "Lawer" ]; then
        echo "1 $1"
    elif ( echo "$1" | grep -q "Impl[0-9]*" ); then
        echo "3 $1"
    elif [ "$1" = "AllD" ]; then
        echo "2 $1"
    else
        echo "5 $1"
    fi
}

sortAlgorithms() {
    while read F
    do
        algorithmOrder "$F"
    done | sort -n | cut '-d ' -f2
}

allAlgorithms() {
    echo "SELECT DISTINCT Algorithm FROM MinGvl;" | runQuery | sortAlgorithms
}

successfulAlgorithms() {
    echo "SELECT DISTINCT Algorithm FROM MinGvl WHERE LockChart LIKE '$1' AND Enterings > 0;" | runQuery | sortAlgorithms
}

selectedAlgorithms() {
    for F in Lawer AllD Impl50 SAT4
    do
        echo "$F"
    done | sortAlgorithms
}

selectedSuccessfulAlgorithms() {
    comm -12 <(successfulAlgorithms "$1%" | sort) <(selectedAlgorithms | sort) | sortAlgorithms
}

datasetSize() {
    echo "SELECT COUNT(*) FROM MinGvlCharts WHERE LockChart LIKE '$1%';" | runQuery
}

datasetName() {
    if [ "$1" = "M" ]; then
        echo real-world
    elif [ "$1" = "N" ]; then
        echo master-only
    elif [ "$1" = "D" ]; then
        echo synthetic
    else
        echo unknown
    fi
}

algorithmSuccess() {
    echo "SELECT COUNT(*) FROM MinGvl WHERE LockChart LIKE '$1%' AND Algorithm = '$2' AND Enterings > 0;" | runQuery
}

#ALGOS=`algosAll`
ALGOS=`selectedAlgorithms`
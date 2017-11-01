 #!/bin/bash
set -e
. MinGvlLib.sh

CRIT=`echo "$1" | sed 's/\([A-Z][a-z]\+\)\([A-Z]\+\)$/\1/g'`
[ -n "$CRIT" ] || CRIT=First

DATASETS=`echo "$1" | sed 's/\([A-Z][a-z]\+\)\([A-Z]\+\)$/\2/g' | sed 's/\(.\)/\1 /g'`
[ -n "$DATASETS" ] || DATASETS="M N"

echo "% Datasets: $DATASET"
echo "% Criterion: $CRIT"

printf "\\\\begin{tabular}{cc|"
for A in `selectedAlgorithms`; do
    printf 'r'
done
echo "}"

printf '\multicolumn{2}{c|}{%24s}' 'Dataset'
for A in `selectedAlgorithms`; do
    printf ' & %29s' `printAlgorithm $A`
done
echo "\\\\"

for DATASET in $DATASETS; do
  echo "\\hline"

  LOCKCHARTS=`echo "SELECT COUNT(*) FROM MinGvlCharts WHERE LockChart LIKE '$DATASET%';" | runQuery`
  printf "\\\\multirow{$LOCKCHARTS}{*}{\\\\begin{turn}{90}%s\\\\end{turn}}" `datasetName "$DATASET"`
  echo

  echo "SELECT DISTINCT LockChart FROM MinGvlCharts WHERE LockChart LIKE '$DATASET%';" | runQuery |\
  while read LOCKCHART; do
  
    printf ' & \\texttt{\\footnotesize %20s}' "$LOCKCHART"
    
    for ALGO in `selectedAlgorithms`; do
      VALUE=`echo "SELECT ${ALGO}${CRIT} FROM MinGvlResults WHERE LockChart = '$LOCKCHART' AND ${ALGO}${CRIT} IS NOT NULL AND ${ALGO}Enterings > 0;" | runQuery`
      if [ -z "$VALUE" ]; then
        #printf ' & $        \geq 10^5\,\\text{s}$'
        printf ' & %31s' '--'
      elif [ "$CRIT" = Enterings ]; then
        printf ' & %31d' $VALUE
      else
        printAutoFormat "$VALUE" 17 '\,\\text{s}'
      fi
    done
    echo "\\\\"
  done
done
echo "\\end{tabular}"
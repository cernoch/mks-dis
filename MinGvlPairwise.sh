#!/bin/bash
set -e
. MinGvlLib.sh

CRIT=`echo "$1" | sed 's/.$//g'`
[ -n "$CRIT" ] || CRIT=Enterings

DATASET=`echo "$1" | sed 's/.*\(.\)$/\1/g'`
[ -n "$DATASET" ] || DATASET=D

ALG=`selectedSuccessfulAlgorithms $DATASET`

echo "% Dataset: $DATASET"
echo "% Criterion: $CRIT"

printf "\\\\begin{tabular}{r|"
for A in $ALG; do
    echo -n "r"
done
echo "}"

printf "%12s" `datasetName $DATASET`
for A in $ALG; do
    printf ' & %18s' `printAlgorithm $A`
done
echo "\\\\\\hline"

for A in $ALG; do
  printf "%12s" `printAlgorithm $A`
  for B in $ALG; do
    RATIO=`algoRatio "${A}${CRIT}" "${B}${CRIT}" "${DATASET}%"`
    printAutoFormat "$RATIO" 16
  done
  echo "\\\\"
done
echo "\\end{tabular}"
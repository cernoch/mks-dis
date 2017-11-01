#!/bin/bash
set -e
. MinGvlLib.sh

printf "\\\\begin{tabular}{c|"
for A in `selectedAlgorithms`; do
    printf 'c'
done
echo "}"

printf '%48s' 'Dataset'
for A in `selectedAlgorithms`; do
    printf ' & %22s' `printAlgorithm $A`
done
echo "\\\\\\hline"

for DATASET in M N D; do
  SIZE=`datasetSize $DATASET`

  printf "\\multirow{2}{*}{%12s ($%d$ lock-charts)}" `datasetName $DATASET` $SIZE
  #printf "%48s" `datasetName $DATASET`
  for ALGO in `selectedAlgorithms`; do
    VALUE=`algorithmSuccess $DATASET $ALGO`
    printf ' & $%17d$' $VALUE
  done
  echo "\\\\"

  printf "%48s" ''
  #printf '{\\footnotesize ($%16d$ lock-charts)}' $SIZE
  for ALGO in `selectedAlgorithms`; do
    VALUE=`algorithmSuccess $DATASET $ALGO`
    printf ' & {\\footnotesize $%2d\\%%$}' `echo "100*$VALUE/$SIZE" | bc`
  done
  echo "\\\\"
done
echo "\\end{tabular}"
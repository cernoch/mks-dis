#!/bin/bash
set -e
. MinGvlLib.sh

echo "\\begin{tabular}{c|cc|cc}"

printf '%43s & %15s & %15s & %15s & %15s' Lock-chart 'Keys ($m+x$)' Locks 'Pos. $p$' 'Depths $d$'
echo "\\\\\\hline"

PATTERN='^D0*\([0-9]\+\)M0*\([0-9]\+\)I0*\([0-9]\+\)P0*\([0-9]\+\)D0*\([0-9]\+\)R$'
echo "SELECT DISTINCT LockChart FROM MinGvlCharts WHERE LockChart LIKE 'D%';" |\
    runQuery | while read LC; do
  
  M=`echo "$LC" | sed "s/$PATTERN/\1/"`
  I=`echo "$LC" | sed "s/$PATTERN/\2/"`
  P=`echo "$LC" | sed "s/$PATTERN/\3/"`
  D=`echo "$LC" | sed "s/$PATTERN/\4/"`
  R=`echo "$LC" | sed "s/$PATTERN/\5/"`

  printf '\\texttt{\\scriptsize %20s} & %4d + %8d & %15d & %15d & %15d' "$LC" "$M" "$I" "$I" "$P" "$D"
  echo "\\\\"
done

echo "\\end{tabular}"

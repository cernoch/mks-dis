#!/usr/bin/gnuplot

set terminal lua tikz size 24cm,14cm
set output "N102.tex"
set xrange [:10000000.00000]
set yrange [0:600]
set logscale x
set grid ytics xtics
set xlabel 'runtime [s]'
set ylabel 'shear-lines in GVC'
set key top right

plot 'N102.dat' index 3 u 1:2 with lines lt 2 lc rgb '#E7298A' lw 2 title 'Automorphism',\
     "< echo    0.00016       486" with points lt 2 lc rgb "#E7298A" lw 2 notitle,\
     "< echo  280.34016        27" with points lt 4 lc rgb "#E7298A" lw 2 notitle,\
     "< echo  330.60545        27" with points lt 6 lc rgb "#E7298A" lw 2 notitle,\
     'N102.dat' index 5 u 1:2 with lines lt 2 lc rgb '#666666' lw 2 title 'CSP',\
     "< echo    0.01257       486" with points lt 2 lc rgb "#666666" lw 2 notitle,\
     "< echo  548.70707        48" with points lt 4 lc rgb "#666666" lw 2 notitle,\
     "< echo 10000000.00000        48" with points lt 6 lc rgb "#666666" lw 2 notitle,\
     'N102.dat' index 4 u 1:2 with lines lt 2 lc rgb '#66A61E' lw 2 title 'Implicit',\
     "< echo    0.00035       486" with points lt 2 lc rgb "#66A61E" lw 2 notitle,\
     "< echo 1710.25034        27" with points lt 4 lc rgb "#66A61E" lw 2 notitle,\
     "< echo 1968.20096        27" with points lt 6 lc rgb "#66A61E" lw 2 notitle,\
     'N102.dat' index 2 u 1:2 with lines lt 2 lc rgb '#7570B3' lw 2 title 'SAT',\
     "< echo    0.00105       486" with points lt 2 lc rgb "#7570B3" lw 2 notitle,\
     "< echo    0.00447        27" with points lt 4 lc rgb "#7570B3" lw 2 notitle,\
     "< echo    0.54411        27" with points lt 6 lc rgb "#7570B3" lw 2 notitle,\
     [10000001.00000:10000001.00000] 601 with points lt 2 lc rgb 'black' lw 2 title 'decision runtime',\
     [10000001.00000:10000001.00000] 601 with points lt 4 lc rgb 'black' lw 2 title 'optimization runtime',\
     [10000001.00000:10000001.00000] 601 with points lt 6 lc rgb 'black' lw 2 title 'algorithm terminated'

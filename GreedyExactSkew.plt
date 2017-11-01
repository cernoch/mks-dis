#!/usr/bin/gnuplot

set terminal lua tikz size 10cm,10cm
set output "GreedyExactSkew.tex"

set xrange [0:50]
set yrange [0:50]
set grid ytics xtics

set xlabel 'exact'
set ylabel 'greedy'

set style line 1 lt 2 lc rgb "black" lw 1
set style line 2 lt 2 lc rgb "#99000000" lw 1
set style line 3 lt 2 lc rgb "#DD000000" lw 1
set style line 4 lt 2 lc rgb "red" lw 2

set key bottom right

linear(x) = c*x
fit linear(x) 'GreedyExactSkew.dat' u 2:1 via c

affine(x) = a*x + b
fit affine(x) 'GreedyExactSkew.dat' u 2:1 via a,b

power(x) = x**d
fit power(x) 'GreedyExactSkew.dat' u 2:1 via d

set print "GreedyExactSkew.txt"
print sprintf("$%.2f\\%$", 100*(1-c))

plot 'GreedyExactSkew.dat' u ($2+rand(0)/2):($1-rand(0)/2) with points pointtype 1 lc rgb "blue" notitle,\
            x          with lines ls 1 notitle, \
     for [i=1:5] x / i * 5 with lines ls 3 notitle, \
     for [i=1:5] x * i / 5 with lines ls 3 notitle
     
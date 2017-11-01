#!/usr/bin/gnuplot

set terminal lua tikz size 10cm,10cm
set output "SagExactSkew.tex"

set xrange [0:50]
set yrange [0:50]
set grid ytics xtics


set key top left
set xlabel 'exact'
set ylabel 'SAG'

set fit logfile "SagExactSkew.log"

linear(x) = c*x
fit linear(x) 'SagExactSkew.dat' u 2:1 via c

affine(x) = a*x + b
fit affine(x) 'SagExactSkew.dat' u 2:1 via a,b

power(x) = x**d
fit power(x) 'SagExactSkew.dat' u 2:1 via d

set print 'SagExactSkew.txt'
print sprintf("$%.1f\\%$", 100 * (1-c))

set style line 1 lt 2 lc rgb "black" lw 1
set style line 2 lt 2 lc rgb "#99000000" lw 1
set style line 3 lt 2 lc rgb "#DD000000" lw 1
set style line 4 lt 2 lc rgb "red" lw 2

set style circle radius 1.2
plot for [i=1:5] x / i * 5 with lines ls 3 notitle, \
     for [i=1:5] x * i / 5 with lines ls 3 notitle, \
     'SagExactSkew.dat' u ($2+(rand(0)-0.5)/2):($1+(rand(0)-0.5)/2) with points pointtype 1 lc rgb "blue" notitle, \
     x with lines ls 1 notitle

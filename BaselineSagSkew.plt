#!/usr/bin/gnuplot

set terminal lua tikz size 10cm,10cm
set output "BaselineSagSkew.tex"

set logscale xy 10

set xrange [1:10000]
set yrange [1:10000]
set grid ytics xtics
set ytics rotate

set mxtics 10
set mytics 10

set key bottom right
set xlabel 'baseline'
set ylabel 'SAG'

set fit logfile "BaselineSagSkew.log"

linear(x) = c*x
fit linear(x) 'BaselineSagSkew.dat' u 1:2 via c

affine(x) = a*x + b
fit affine(x) 'BaselineSagSkew.dat' u 1:2 via a,b

set print "BaselineSagSkew.txt"
print sprintf("$%.0f\\%$", (c-1)*100)

set style line 1 lt 2 lc rgb "black" lw 1
set style line 2 lt 2 lc rgb "#99000000" lw 1
set style line 3 lt 2 lc rgb "#DD000000" lw 1
set style line 4 lt 2 lc rgb "red" lw 3

set style circle radius 1.2
plot 'BaselineSagSkew.dat' u ($1+(rand(0)-0.5)/2):($2+(rand(0)-0.5)/2) with points pointtype 1 lc rgb "blue" notitle,\
                             x             with lines ls 1 notitle, \
     for [e=0:3] for [i=0:10] x / i / 10**e with lines ls 3 notitle,\
     for [e=0:3] for [i=0:10] x * i * 10**e with lines ls 3 notitle

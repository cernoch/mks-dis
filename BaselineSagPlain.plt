#!/usr/bin/gnuplot

set terminal lua tikz size 8cm,8cm
set output "BaselineSagPlain.tex"

set logscale xy 10

set xrange [2:10000]
set yrange [2:10000]
set grid ytics xtics

set key bottom right
set xlabel 'baseline'
set ylabel 'SAG'

set fit logfile 'BaselineSagPlain.log'

linear(x) = c*x
fit linear(x) 'BaselineSagPlain.dat' u 1:2 via c

affine(x) = a*x + b
fit affine(x) 'BaselineSagPlain.dat' u 1:2 via a,b

set style line 1 lt 2 lc rgb "black" lw 1
set style line 2 lt 2 lc rgb "#99000000" lw 1
set style line 3 lt 2 lc rgb "#DD000000" lw 1
set style line 4 lt 2 lc rgb "#009900" lw 3

plot                         x             with lines ls 1 notitle, \
     for [e=1:2]             x     * 10**e with lines ls 2 notitle, \
     for [e=1:2]             x     / 10**e with lines ls 2 notitle, \
     for [e=0:2] for [i=2:9] x * i * 10**e with lines ls 3 notitle, \
     for [e=0:2] for [i=2:9] x / i / 10**e with lines ls 3 notitle, \
     'BaselineSagPlain.dat' u 1:2 with points pointtype 1 lc rgb "blue" notitle    , \
     linear(x) with lines ls 4 title 'linear least square', \
     1 lc rgb 'white' lw 0 t sprintf("$y = x \\cdot %.2f$", c)

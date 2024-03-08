# pi plotter
set term x11
set output "pi_plot"
set title "Monte Carlo estimation of pi"
set nokey
set grid
set xlabel "number of trials"
set ylabel "pi value"
m = "pi.txt"
plot m using 1:2 with points title "Pi estimations"
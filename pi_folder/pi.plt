# pi plotter
set term png
set output "pi_plot.png"
set title "Monte Carlo estimation of pi"
set nokey
set grid
set xlabel "number of trials"
set ylabel "pi value"
m = "pi.txt"
real_pi = 3.14159265359
plot m using 1:2 with points title "Pi estimations"
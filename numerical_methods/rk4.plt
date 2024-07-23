# rk4.plt
set term png
set output "rk_plot.png"
set title "Coupled ODEs"
set grid
set xlabel "Time"
set ylabel "Count"
plot "data.txt" using 1:2:5 with yerrorbar title "Prey", "data.txt" using 1:3:4 with xerrorbar title "Predator"
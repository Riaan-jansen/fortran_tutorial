# temperature plotter
set terminal png size 1600,900 font "roboto,18"
set output "target_heat.png"
set title "Temperature in target components over time"
set grid
set xlabel "Time (s)"
set ylabel "Temperature ({\260}C)"
set key top left

m = "target.txt"

set multiplot layout 1,2  # two plots

set xrange[0:0.1]
set yrange[19.0:*]

plot m using 1:2 with points title "Target" lt rgb "red", m using 1:3 with points title "Base" lt rgb "orange", m using 1:4 with points title "Coolant" lt rgb "blue"

set xrange restore  # restores xrange from above
set xrange [*:125]  # autoscales the xrange

plot m using 1:2 with points title "Target" lt rgb "red", m using 1:3 with points title "Base" lt rgb "orange", m using 1:4 with points title "Coolant" lt rgb "blue"
unset multiplot

#
set terminal png size 1200,1000 font "roboto,36"
set output "raw_flux.png"
set title "Neutron Flux Over Distance"
set xlabel "Distance from Moderator (m)"
set ylabel "Neutron Flux (n/cm^2/s)"
set ylabel offset 1,0
set xlabel offset 0,0.5
set title offset 0,-0.5
set key center left

# set mxtics 3
# set mytics 10
set grid xtics ytics mxtics mytics
set logscale y 10

m = "raw_flux.txt"

plot m using 1:2 with linespoints ps 3 lw 3 pt 5 lc rgb "black" title "Total Flux", \
    m using 1:3 with linespoints ps 3 lw 3 pt 5 lc rgb "red" title "Thermal", \
    m using 1:4 with linespoints ps 3 lw 3 pt 5 lc rgb "blue" title "Cold"
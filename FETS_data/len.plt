# 
set terminal svg size 1600,1000 font "roboto,36"
set output "fluxlens.svg"
set title "Neutron Flux Compared to Distance Into Beamline"
set xlabel "Beamline Position (Distance from Moderator) [m]"
set ylabel "Neutron Flux [n/cm^2/s]"
set ylabel offset 3.5,0
set xlabel offset 0,0.5
set title offset 0,-0.5
set key top left
set mytics 10
set grid xtics ytics mxtics mytics
set xrange[4.5:9.5]
set logscale y 10

m = "lendata.txt"

plot m using 1:2 with linespoints dashtype 3 pt 5 lc rgb "black" title "Total flux", m using 1:3 with linespoints dashtype 3 pt 7 lc rgb "red" title "Epithermal", m using 1:4 with linespoints dashtype 3 pt 9 lc rgb "medium-blue" title "Thermal", m using 1:5 with linespoints dashtype 3 pt 11 lc rgb "slateblue1" title "Cold"
 
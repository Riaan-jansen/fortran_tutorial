# 
set terminal svg size 1200,1000 font "roboto,36"
set output "precomp.svg"
set title "Neutron Flux With And Without Premoderator"
set xlabel "Distance From Moderator in Beamline (m)"
set ylabel "Neutron Flux (n/cm^2/s)"
set title offset 0,-0.5
set xlabel offset 0,0.5
set ylabel offset 3.5,0
set key top right
set mxtics 3
set mytics 10
set grid xtics ytics mxtics mytics
set xrange[4.5:9.5]
set yrange[40000: 1e7]
set logscale y 10

m = "premod.txt"

# plot m using 1:2:3 with yerrorbar pt 9 title "Total flux (Premod)", m using 1:4:5 with yerrorbar pt 8 title "Thermal & cold (Premod)", m using 1:6:7 with yerrorbar pt 11 title "Total flux (w/o)", m using 1:8:9 with yerrorbar pt 10 title "Thermal & cold (w/o)"
plot m using 1:2 with linespoints dashtype 3 pt 13 lc rgb "red" title "Total flux (Premod)", m using 1:4 with linespoints dashtype 3 pt 13 lc rgb "slateblue1" title "Thermal + cold (Premod)", m using 1:6 with linespoints dashtype 3 pt 5 lc rgb "orange-red" title "Total flux (w/o)", m using 1:8 with linespoints dashtype 3 pt 5 lc rgb "medium-blue" title "Thermal + cold (w/o)"

# 
set terminal svg size 1200,800 font "roboto,36"
set output "rftrcomp.svg"
set title "Neutron Flux Compared to Reflector Thickness"
set xlabel "Lead Reflector Thickness (cm)"
set ylabel "Flux at 5 m (n/cm^2/s)"
set ylabel offset 4,0
set xlabel offset 0,0.5
set title offset 0,-0.5
set key center right
set xtics (0, 10, 20, 30)
set xrange[-1:36]
set yrange[-50000:2100000]
# set mxtics 3
# set mytics 10
set grid xtics ytics mxtics mytics
# set logscale y 10

m = "rftrdata.txt"

plot m using 1:2 with points pointtype 13 lc rgb "red" title "Total flux", m using 1:4 with points pointtype 5 lc rgb "blue" title "Thermal + cold"

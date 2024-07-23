# 
set terminal svg size 1600,1400 font "roboto,36"
set output "rftr_mat.svg"
set title "Neutron Flux Compared to Reflector Material"
set xlabel "Distance from Moderator (m)"
set ylabel "Neutron Flux (n/cm^2/s)"
set ylabel offset 4,0
set xlabel offset 0,0.5
set title offset 0,-0.5
set key bottom left
set yrange[500:1e7]
# set mxtics 3
# set mytics 10
set grid xtics ytics mxtics mytics
set logscale y 10

m = "rftr_mat.txt"

plot m using 1:2:3 with yerrorbar   pt 5 lc rgb "dark-violet" title "Iron - total flux", \
  m using 1:4:5 with yerrorbar   pt 9 lc rgb "dark-magenta" title "Iron - thermal+cold", \
  m using 1:6:7 with yerrorbar   pt 5 lc rgb "dark-green" title "Lead - total flux", \
  m using 1:8:9 with yerrorbar  pt 9  lc rgb "forest-green" title "Lead - thermal+cold", \
  m using 1:10:11 with yerrorbar  pt 5  lc rgb "goldenrod" title "Beryllium - total flux", \
  m using 1:12:13 with yerrorbar  pt 9  lc rgb "gold" title "Beryllium - thermal+cold", \
  m using 1:2 with linespoints  lw 3 pt 5  lc rgb "dark-violet" notitle, \
  m using 1:4 with linespoints  pt 9 lw 3  lc rgb "dark-magenta" notitle, \
  m using 1:6 with linespoints lw 3 pt 5  lc rgb "dark-green" notitle, \
  m using 1:8 with linespoints lw 3 pt 9  lc rgb "forest-green" notitle, \
  m using 1:10 with linespoints lw 3 pt 5  lc rgb "goldenrod" notitle, \
  m using 1:12 with linespoints lw 3 pt 9  lc rgb "gold" notitle
 
 
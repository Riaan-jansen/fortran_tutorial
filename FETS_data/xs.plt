# cross section plotting
set terminal svg standalone size 1600,900 font "roboto,36"
set output "xscomp.svg"
set title "(p, n) Cross Section for Potential Target Materials"
set xlabel "Energy (MeV)"
set ylabel "Cross section (barn)"
set key spacing 2
set mxtics 3
set mytics 3

set pointsize 0.4
set grid
# set grid mxtics mytics xtics ytics

m ='li_data.txt'
n='be_data.txt'

plot m using ($1/1e6):2 with linespoints pointtype 9 lw 3 title "lithium", n using ($1/1e6):2 with linespoints pointtype 13 lw 3 title "beryllium"

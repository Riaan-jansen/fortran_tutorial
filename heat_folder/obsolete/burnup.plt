# plot the difference in decay methods.
# FOR SOME REASON THIS DOESN'T WORK NEED TO USE A .SH FILE?
set terminal png size 2100,1024 font "roboto,20"
set output "burnup.png"
set title "Target Nuclei Over Time"
set grid
set xlabel "Time (s)"
set ylabel "Nuclei"
set key bottom left
d1="exp22.txt"
d2="decay21.txt"

# set multiplot layout 1,2

plot d1 using 1:2 with linespoints title "Exponential" lt rgb "purple"

# plot d2 using 1:2 with linespoints title "Incremental" lt rgb "orange"

# unset multiplot

#!/bin/sh
set -e

gfortran -c target2.f
gfortran -o target target2.o
./target > target.txt
gnuplot -p target.plt
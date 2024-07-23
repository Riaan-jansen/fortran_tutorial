#!/bin/sh
set -e

./rk4 > data.txt
gnuplot -c rk4.plt
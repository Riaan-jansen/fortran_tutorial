#!/bin/sh
set -e

./target > target.txt
gnuplot -c target.plt
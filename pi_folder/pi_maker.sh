#!/bin/sh
set -e

./pimod > pi.txt
gnuplot -c pi.plt
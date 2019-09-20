#!/bin/bash -e

# Graphs for all cases
time=100000
for dir in *Transfer*; do
    ./plotOne.sh $dir $time
done


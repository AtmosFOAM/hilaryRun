#!/bin/bash -e

# Post processing for time t
if [ "$#" -ne 1 ]
then
   echo usage: post.sh time
   exit
fi

case=.
time=$1

# Calculate Nusselt number and KE
../../scripts/NusseltoneTime.sh $case $time
../../scripts/KEoneTime.sh $case $time 'down up'

# Graphs of results
../../scripts/scatter.sh $case $time 'down up'
../../scripts/graphs2.sh $case $time

../../scripts/Nusselt.sh . 0 30


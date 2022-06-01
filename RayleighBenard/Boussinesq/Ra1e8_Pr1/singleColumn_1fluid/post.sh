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
../../scripts/KEoneTime.sh $case $time 'stable up down'

# Graphs of results
../../scripts/graphs.sh $case $time


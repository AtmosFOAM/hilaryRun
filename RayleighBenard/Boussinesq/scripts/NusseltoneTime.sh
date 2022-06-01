#!/bin/bash -e

# Nusselt number for RB convection

if [ "$#" -ne 2 ]
then
   echo usage: Nusselt.sh case time
   exit
fi

case=$1
time=$2

# Calculate vertical heat transport and global mean
multiFluidHeatTransferFoam -case $case -time $time
writeuvw heatTransfer -case $case -time $time


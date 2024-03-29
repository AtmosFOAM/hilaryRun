#!/bin/bash -e
# Set up a initial conditions of a test case

if [ "$#" -ne 1 ]
then
   echo usage: init0.sh case
   exit
fi

case=$1

# Create the initial conditions
mkdir -p $case/0
cp -r dummy/0/* $case/0
cp dummy/system/tracer*Dict dummy/system/velocityFieldDict $case/system
setInitialTracerField -case $case -tracerDict tracer1Dict -name T1
setInitialTracerField -case $case -tracerDict tracer2Dict -name T2
sumFields -case $case 0 T 0 T1 0 T2
rm $case/0/T?
sed -i 's/calculated/zeroGradient/g' $case/0/T
setVelocityField -case $case
gmtFoam -case $case -time 0 UT
gv $case/0/UT.pdf &

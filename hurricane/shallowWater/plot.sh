#!/bin/bash -e

# Post process
case=.
postProcess -func vorticity -case $case
writeuvw vorticity -case $case
for time in [0-9]*; do
    mv $case/$time/vorticityz $case/$time/vorticity
    rm $case/$time/vorticity?
done
gmtFoam vorticity -case $case

# Animattion of vorticity
eps2gif vorticity.gif 0/vorticity.pdf ????/vorticity.pdf \
                                      ?????/vorticity.pdf

gmtFoam h
eps2gif h.gif 0/h.pdf ????/h.pdf ?????/h.pdf

# Make links for animategraphics
mkdir -p animategraphics
for field in vorticity hU mesh; do
    for time in [0-9]*; do
	t=`echo $time | awk {'print $1/100000'}`
	ln -s ../$time/$field.pdf animategraphics/${field}_$t.pdf
    done
done

# Differences from initial conditions
for time in [1-9]*; do
    for var in U h; do
        sumFields $time ${var}Diff $time $var 0 $var -scale1 -1
    done
done

gmtFoam hUDiff
eps2gif hUDiff.gif 0/hUDiff.pdf ???/hUDiff.pdf ????/hUDiff.pdf

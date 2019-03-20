#!/bin/bash -e

# Try to simulate a hurricane with exnerFoamTurbulence

rm -rf [0-9]* core log* *dat postProcessing
blockMesh
rm -rf [0-9]* core log* *dat postProcessing
cp -r init_0 0

# Initial theta
setInitialTracerField -name theta
sed 's/fixedValue/fixedUniformInternalValue/g' -i 0/theta
# reset theta on upper boundary to be cold
gedit -s 0/theta

# Setup hydrostatic pressure
setExnerBalanced

# Setup hydrostatic pressure
#setHydroStaticPressure
# Fix the top boundary conditions
#sed -i 's/fixedValue/hydrostatic_p_rgh;\n        gradient uniform 0/g' 0/p_rgh

# run exnerFoamTurbulence
rm -rf [1-9]*
turbulentExnerFoam_RC >& log & sleep 0.01; tail -f log

# plots
gmtFoam Utheta
eps2gif Utheta.gif 0/Utheta.pdf ???/Utheta.pdf ????/Utheta.pdf ?????/Utheta.pdf

writeuvw U
gmtFoam U
eps2gif U.gif 0/U.pdf ???/U.pdf ????/U.pdf ?????/U.pdf

time=56000
writeuvw U -time $time
for var in Utheta U; do
    gmtFoam -time $time $var
    gv $time/$var.pdf &
done


#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log

# create mesh
blockMesh

# Initial conditions
rm -rf [0-9]* core
mkdir 0
cp -r init_0/* 0

# Initial buoyancy perturbation
setFields -time 0

# Solve Boussinesq equations
multiFluidBoussinesqFoam >& log & sleep 0.01; tail -f log

# Post processing
for time in [0-9]*; do
    ./graphData.sh . $time
done

time=100000

./graphData.sh . $time

gmtFoam -time $time ub
gv $time/ub.pdf &

# Compare wb and alpha db/dz
writeuvw -time $time u
sumFields $time bPlus1 $time b init_0 b.one
#multiplyFields $time wb $time uz $time bPlus1
multiplyFields $time wb $time uz $time b

postProcess -time $time -field b -func grad\(b\)
mv $time/'grad(b)' $time/gradb
writeuvw -time $time gradb
sumFields $time alphadbdz $time gradbz $time gradbz -scale0 100 -scale1 0

gmtFoam -time $time heatTransport
gv $time/heatTransport.pdf &

# Other post prossing
postProcess -func laplacian -time $time
sumFields $time diffusionb $time laplacianb $time laplacianb -scale0 100 -scale1 0
postProcess -func convection -time $time
postProcess -func uCrossGrad -time $time
postProcess -time $time -field uCrossGradb -func mag\(uCrossGradb\)
postProcess -time $time -field convection -func mag\(convection\)
sumFields $time uCrossGradbMinusConvection $time mag\(uCrossGradb\) \
         $time mag\(convection\) -scale1 -1

gmtFoam -time $time ub
gv $time/ub.pdf &

gmtFoam -time $time ubConvection
gv $time/ubConvection.pdf &

gmtFoam -time $time convection
gv $time/convection.pdf &



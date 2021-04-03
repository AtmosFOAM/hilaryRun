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

time=100000

./graphData.sh . $time
./graphs.sh $time

gmtFoam -time $time ubSigma
gv $time/ubSigma.pdf &




# Compare wb and alpha db/dz
writeuvw -time $time u.air
sumFields $time bPlus1 $time b.air init_0 b.one
#multiplyFields $time wb $time u.airz $time bPlus1
multiplyFields $time wb $time u.airz $time b.air

postProcess -time $time -field b.air -func grad\(b.air\)
mv $time/'grad(b.air)' $time/gradb
writeuvw -time $time gradb
sumFields $time alphadbdz $time gradbz $time gradbz -scale0 100 -scale1 0

gmtFoam -time $time heatTransport
gv $time/heatTransport.pdf &

# Other post prossing
postProcess -func laplacian -time $time
sumFields $time diffusionb $time laplacianb $time laplacianb -scale0 100 -scale1 0
postProcess -func convection -time $time

gmtFoam -time $time ub
gv $time/ub.pdf &

gmtFoam -time $time ubConvection
gv $time/ubConvection.pdf &

gmtFoam -time $time convection
gv $time/convection.pdf &



#!/bin/bash -e

rm -rf [0-9]* constant/polyMesh

# mesh generation
blockMesh
terrainFollowingMesh

gmtFoam mesh
ev constant/mesh.pdf
gmtFoam meshZoom
ev constant/meshZoom.pdf

# initial conditions
cp -r init_0 0

# run
boussinesqFoam -isoThermal >& log & sleep 0.01; tail -f log

time=13000
writeuvw -time $time u
gmtFoam -time $time U
gv $time/U.pdf &

time=11000
sumFields $time uDiff $time u init_0 u -scale1 -1
gmtFoam -time $time tracer
gv $time/tracer.pdf &

mv 13000 init_2
rm -r [0-9]*
cp -r init_2 0
cp init_0/tracer 0
boussinesqFoam -isoThermal >& log & sleep 0.01; tail -f log


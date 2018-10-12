rm -rf [0-9]*
blockMesh
cp -r init0 0
rhoPimpleFoam >& log & sleep 0.01; tail -f log

time=1
gmtFoam -time $time rho
gv $time/rho.pdf &

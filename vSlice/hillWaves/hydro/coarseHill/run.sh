#!/bin/bash -e

# mesh generation
rm -rf [0-9]* constant/polyMesh constant/muSponge* processor* dynamicCode
blockMesh
terrainFollowingMesh

# create sponge layer
setTracerField -name muSponge -tracerDict "environmentalProperties"

# Initial conditions
cp -r init_0 0
rm 0/P
setIsothermalBalance

# run
exnerFoam_uvw > log 2>&1 & sleep 0.01; tail -f log

#mkdir 0
#setTracerField -tracerDict expHeightTracerDict -name P
#testGradP

# Testing
Sponge Hydro impGW impU impT iters dt ocCoeff conv       solution
yes    yes    no   no   no   2x2   20  0    excellent  good
no     yes    no   no   no   2x2   20  0    excellent  good
yes    yes    no   no   no   2x2   20  1    excellent  wrong
no     no     no   no   no   2x2   20  1    excellent  good
no     no     no   yes  yes  2x2   20  1    good   good but bigger waves at lid
no     no     no   yes  yes  2x2   20  0    good       good
no     no     yes  no   no   2x2   20  1    excell    good
yes    no     yes  no   no   2x2   20  1    excell    good
yes    yes    no   no   no   2x2   20  1    good      wrong
no     yes    no   no   no   2x2   20  1    crashes
no     yes    no   no   no   2x2   20  0    excell    good
no     yes    no   no   no   2x2   20  0.9  good      wrong
no     yes    no   no   no   2x2   20  0.5  excell    good
no     yes    no   no   no   2x2   20  0.8  excell    good
no     yes    no   no   no   2x2   20  1new excell    good
The problem was due to an instability when GWs were not implicit enough


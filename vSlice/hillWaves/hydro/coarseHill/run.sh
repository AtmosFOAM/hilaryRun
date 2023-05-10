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
exnerFoamA > log 2>&1 & sleep 0.01; tail -f log

#mkdir 0
#setTracerField -tracerDict expHeightTracerDict -name P
#testGradP

# Testing
Sponge Hydro impGW impU impT iters dt ocCoeff conv   solution
yes    yes    no   no   no   2x2   20  1     excell  good
yes    yes    yes  yes  yes  2x2   20  1    good     not same
yes    yes    no   no   yes  2x2   20  1    good     as above
yes    yes    no   yes  no   2x2   20  1    good     good
so implicit theta is a problem. Tighten theta tolerance 1e-10. Better
1e-12. Same
yes    yes    yes  yes  yes  2x2   20  1    good     good
yes    yes    yes  yes  yes  1x1   20  1    lumpy solution
yes    yes    yes  yes  yes  2x1   20  1    good     good
yes    no     yes  yes  yes   2x1   20  1    good     different
yes    no     no   no   no   2x1   20  1    good     as non-hydro
yes    no     no   no   no   2x1   5   0.1  good     less active near lid
no     no     no   no   no   2x1   20  1    good     more active near lid
no     yes    yes  yes  yes  2x1   20  1    good    bit wobbly
no     yes    yes  yes  yes  2x1   5  0.8   good    better

exnerFoamA
no     no    no    no   no   2x1   20   0.8   good   good
no     yes   no    no   no   2x1   20   0.8   good   wrong


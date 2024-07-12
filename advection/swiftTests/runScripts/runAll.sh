#!/bin/bash -e

# REsolutions:
# n=128, dt = 0.2
# n=128, dt = 2

./runScripts/initOne.sh smoothUniform_dt2_nx128_noRho smooth uniform 2 128 false
./runScripts/runOne.sh smoothUniform_dt2_nx128_noRho
./runScripts/postOne.sh smoothUniform_dt2_nx128_noRho

./runScripts/initOne.sh slottedUniform_dt2_nx128_rho slotted uniform 2 128 true

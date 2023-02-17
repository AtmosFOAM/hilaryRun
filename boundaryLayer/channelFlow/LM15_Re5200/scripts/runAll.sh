# 1D simulation of the Channel flow case in LM15
# delta=1, domain  height = 2m
# U_mean = 1
# nu = 8e-6 which gives Re = 250,000, Re_tau = 5185.897

# initial k = 1.5*(0.05*Ubar)^2 = 0.00375
# initial epsilon = Cmu^.75 k^1.5/delta = 0.0000377336
# initial nut = Cmu k^2/epsilon = 0.0335410615
# omega = epsilon/(Cmu k) = 0.1118032593

rm -rf [0-9]* constant/polyMesh postProcessing
blockMesh
cp -r init_0 0
boundaryFoamHS >& log & sleep 0.01; tail -f log



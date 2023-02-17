# 1D simulation of the Leipzig with profile following ZWM20
# domain  height = 3km
# U_mean = 17.5?
# nu =  which gives Re = , Re_tau = 

# initial nut ~ 10, length = 30 so nut = Cmu k^2/eps, ell = sqrt(nut/S)
# initial k = 
# initial epsilon = 

# ustar = 0.65
# Boundary conditions
# k = u*^2/sqrt(Cmu)

rm -rf [0-9]* constant/polyMesh postProcessing
blockMesh
cp -r init_0 0
mv 0/dbdz constant
stratifiedBoundaryFoam >& log & sleep 0.01; tail -f log


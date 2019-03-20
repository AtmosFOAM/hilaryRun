# Set up, run and plot the results from the Cuxart et al boundary layer case
# with exnerFoamTurbulence

blockMesh
rm -rf [0-9]* core log* *dat postProcessing
cp -r ../skeleton/init_0 0

# Initial theta
setTheta
rm 0/thetaf 0/BruntFreq2f

# Initial k
setAnalyticTracerField -name k -tracerDict k_tracerFieldDict

# Setup hydrostatic pressure
setExnerBalanced
#sed -i 's/geostrophicVelocity (0 0 0)/geostrophicVelocity (8 0 0)/g' 0/Exner
#sed -i 's/Omega               (0 0 0)/Omega               (0 0 6.95e-5)/g' 0/Exner

# run exnerFoamTurbulence
rm -rf [1-9]*
turbulentExnerFoam >& log & sleep 0.01; tail -f log

# Plotting for exnerFoamTurbulence
times=`ls -d [0-9]* | sort -n`
for var in theta U k nut epsilon turbulentLength; do
    writeCellDataxyz $var
    for time in [0-9]*; do
        sort -g --key=3 $time/$var.xyz > $time/$var.dat
    done
    export inputFiles=()
    for time in $times; do
        inputFiles=(${inputFiles[*]} $time/$var.dat)
    done
    . gmtPlot ../plots/plotAll$var.gmt
    rm */$var.dat */$var.xyz
done

# Plot the friction velocity as a function of time
gmtPlot ../plots/plotUstar.gmt


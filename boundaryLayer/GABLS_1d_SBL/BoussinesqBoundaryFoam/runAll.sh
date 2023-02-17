# Set up, run and plot the results from the Cuxart et al boundary layer case
# with BoussinesqBoundaryFoam

blockMesh
rm -rf [0-9]* core log* *dat postProcessing dynamicCode
cp -r init_0 0

BoussinesqBoundaryFoam >& log & sleep 0.01; tail -f log

# Plotting for exnerFoamTurbulence
times=`ls -d [0-9]* | sort -n`
for var in U k nut epsilon lm b turbHeatFlux; do
    export inputFiles=()
    for time in $times; do
        inputFiles=(${inputFiles[*]} postProcessing/graphs/$time/$var.xy)
    done
    . gmtPlot ../plots/plotAll$var.gmt
done

# Plot the friction velocity as a function of time
grep uTau log | awk '{print $1, $7}' > postProcessing/graphs/uStar.xy
gmtPlot ../plots/plotUstar.gmt


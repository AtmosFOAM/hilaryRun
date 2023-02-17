# Set up, run and plot the results from the Cuxart et al boundary layer case
# with buoyantPimpleFoam

blockMesh
rm -rf [0-9]* core log* *dat
cp -r ../skeleton/init_0 0

# Initial theta
setTheta
rm 0/thetaf 0/BruntFreq2f

# Initial k
setAnalyticTracerField -name k -tracerDict k_tracerFieldDict

# Setup hydrostatic pressure
setHydroStaticPressure
# Fix the top boundary conditions
sed -i 's/fixedValue/hydrostatic_p_rgh;\n        gradient uniform 0/g' 0/p_rgh

# run buoyantPimpleFoam
rm -rf [1-9]*
buoyantPimpleFoam >& log & sleep 0.01; tail -f log

# Plotting for buoyantPimpleFoam
for var in T p p_rgh U k nut epsilon; do
    writeCellDataxyz $var
    for time in [0-9]*; do
        sort -g --key=3 $time/$var.xyz > $time/$var.dat
    done
    gmtPlot ../plots/plotAll$var.gmt
    rm */$var.dat */$var.xyz
done


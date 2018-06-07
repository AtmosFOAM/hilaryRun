# Set up, run and plot the results from the Cuxart et al boundary layer case with
# buoyantPimpleFoam and exnerFoamTurbulence

# Setup both
blockMesh
rm -rf [0-9]* core log* *dat
cp -r init_0 0

# Initial theta
setTheta
rm 0/thetaf 0/BruntFreq2f

# Setup hydrostatic pressure for both codes
# buoyantPimpleFoam
setHydroStaticPressure
# Fix the top boundary conditions
sed -i 's/fixedValue/hydrostatic_p_rgh;\n        gradient uniform 0/g' 0/p_rgh

# exnerFoamTurbulence
setExnerBalanced
sed -i 's/geostrophicVelocity (0 0 0)/geostrophicVelocity (8 0 0)/g' 0/Exner
sed -i 's/Omega               (0 0 0)/Omega               (0 0 6.95e-5)/g' 0/Exner

# run buoyantPimpleFoam
buoyantPimpleFoam >& log & sleep 0.01; tail -f log

# Plotting for buoyantPimpleFoam
export time=32400
for var in theta T U k nut p p_rgh; do
    writeCellDataxyz $var -time $time
    sort -g --key=3 $time/$var.xyz > $time/$var.dat
    gmtPlot plots/plot$var.gmt
done
gmtPlot plots/plotw.gmt
rm $time/*.dat $time/*.xyz

mv $time saveB_${time}_RAS

# run exnerFoamTurbulence
rm -rf [1-9]*
exnerFoamTurbulence >& logE & sleep 0.01; tail -f logE


# Plotting for exnerFoamTurbulence
export time=32400
for var in  k nut epsilon T theta Uf Exner; do
    writeCellDataxyz $var -time $time
    sort -g --key=3 $time/$var.xyz > $time/$var.dat
    gmtPlot plots/plot$var.gmt
done
gmtPlot plots/plotwf.gmt
rm $time/*.dat $time/*.xyz

mv $time saveE_$time


#!/bin/bash -e

# Reynolds number for RB convection

if [ "$#" -lt 3 ]
then
   echo usage: calcRe.sh '[-r|--replot]' case startTime timeWindow
   exit
fi

while [ True ]; do
if [ "$1" = "--replot" -o "$1" = "-r" ]; then
    REPLOT=1
    shift 1
else
    break
fi
done

ARG=( "${@}" )
case=${ARG[0]}
startTime=${ARG[1]}
timeWindow=${ARG[2]}

# Calculate vertical heat transfer
if [ ! "$REPLOT" ] ; then
    # Calculate w flux
    postProcess -case $case -func wFlux
    # Take global average
    globalSum wFlux -case $case
fi

# Get run parameters
# Find T0, TTop, z0 and zTop to non-dimensionalise
#meshBounds=`checkMesh -case $case -constant \
#    | grep 'Overall domain bounding box'`
#z0=`echo $meshBounds | awk '{print $7}' | awk -F')' '{print $1}'`
#zTop=`echo $meshBounds | awk '{print $10}' | awk -F')' '{print $1}'`
z0=0
zTop=1
mu=`grep mu $case/constant/thermophysicalProperties | head -1 |
    awk -F'mu' '{print $2}' | awk -F';' '{print $1}'`
Tref=`foamDictionary $case/constant/thermophysicalProperties -entry Tref -value`
dt=`foamDictionary $case/system/controlDict -entry deltaT -value`
wI=`foamDictionary $case/system/controlDict -entry writeInterval -value`
pRef=`foamDictionary $case/constant/thermophysicalProperties -entry pRef -value`
molWeight=`grep molWeight $case/constant/thermophysicalProperties | head -1 |
    awk -F'molWeight' '{print $2}' | awk -F';' '{print $1}'`
R=`echo $molWeight | awk '{print 8314/$1}'`
rho0=`echo | awk '{print '$pRef'/('$R'*'$Tref')}'`

wFluxNorm=`echo $mu | awk '{print $1/('$zTop'-'$z0')/sqrt('$rho0')}'`
echo wFluxNorm = $wFluxNorm

# Running means
averageOver=`awk -v w=$timeWindow -v d=$wI 'BEGIN {print w/d}'`
runningMean.sh $averageOver $case/globalSumwFlux.dat \
    > $case/globalSumwFluxTimeMean.dat

# Take square root of all wFlux files
for file in $case/*wFlux*.dat; do
    awk 'function abs(v) {v += 0; return v < 0 ? -v : v}
        {if (NR == 1) print $0;
         else print $1, $2, $3, $4, $5, $6, $7, $8, sqrt(abs($5))}' $file \
         | sponge $file
done

# Plot global average and time mean of global average
mkdir -p $case/plots
gv=0
inputFiles=($case/globalSumwFlux.dat
            $case/globalSumwFluxTimeMean.dat)
outFile=$case/plots/globalSumwFlux.eps
legends=("Global mean" "Global time mean")
pens=("grey" "1.5,black,3_3:0")
col=9
colx=1
xlabel="Time"
ylabel="Reynolds number"
xmin=0
xmax=`tail -1 $case/globalSumwFlux.dat | awk '{print int($1+.999)}'`
dx=`echo $xmax | awk '{print int($1/10+.999)}'`
ymin=0
ymax=250
dy=50
ddy=$dy
dyg=$ymax
xscale=/1
yscale=/$wFluxNorm
nSkip=1
legPos=x9/2
projection=X15c/10c
source gmtPlot

awk '{print $1, $9/'$wFluxNorm'}' $case/globalSumwFluxTimeMean.dat \
    > $case/ReynoldsTimeMean.dat
awk '{print $1, $9/'$wFluxNorm'}' $case/globalSumwFlux.dat \
    > $case/Reynolds.dat
wFlux=`tail -1 $case/globalSumwFluxTimeMean.dat | awk '{print $5}'`
Re=`awk 'BEGIN{print sqrt('$wFlux')/'$wFluxNorm'}'`
echo Time and space averaged w flux  $wFlux
echo Reynolds number = $Re
#ev $outFile


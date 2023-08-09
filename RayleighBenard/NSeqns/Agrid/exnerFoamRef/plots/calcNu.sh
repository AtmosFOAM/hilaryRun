#!/bin/bash -e

# Nusselt number for RB convection

if [ "$#" -lt 3 ]
then
   echo usage: calcNu.sh [-r|--replot] case startTime startAveraging
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

# Calculate vertical heat transfer and global means
if [ ! "$REPLOT" ] ; then
    postProcess -case $case -func heatFlux
    writeuvw -case $case -time $startTime':' heatFlux
    globalSum heatFluxz -case $case
    boundarySum heatFluxz -case $case ground
    boundarySum heatFluxz -case $case top
    rm $case/*/heatFlux $case/*/heatFlux[x-y]
fi

# Running means
runningMean.sh $timeWindow $case/globalSumheatFluxz.dat \
    > $case/globalSumheatFluxzTimeMean.dat
runningMean.sh $timeWindow $case/sum_groundheatFluxz.dat \
    > $case/sum_groundheatFluxzTimeMean.dat
runningMean.sh $timeWindow $case/sum_topheatFluxz.dat \
    > $case/sum_topheatFluxzTimeMean.dat

# Find T0, TTop, z0 and zTop to non-dimensionalise
meshBounds=`checkMesh -case $case -constant \
    | grep 'Overall domain bounding box'`
z0=`echo $meshBounds | awk '{print $7}' | awk -F')' '{print $1}'`
zTop=`echo $meshBounds | awk '{print $10}' | awk -F')' '{print $1}'`
boundarySum thetap -case $case ground -time 0
boundarySum thetap -case $case top -time 0
T0=`tail -1 $case/sum_groundthetap.dat | awk '{print $5}'`
TTop=`tail -1 $case/sum_topthetap.dat | awk '{print $5}'`
dTdZ=`awk BEGIN'{print ('$TTop'-'$T0')/('$zTop'-'$z0')}'`
mu=`grep mu $case/constant/thermophysicalProperties | head -1 |
    awk '{print $2}' | awk -F';' '{print $1}'`
Pr=`grep Pr $case/constant/thermophysicalProperties | tail -1 |
    awk '{print $2}' | awk -F';' '{print $1}'`
alpha=`echo $mu, $Pr | awk '{print $1/$2}'`
g=`foamDictionary $case/constant/environmentalProperties -entry g -value |
    awk '{print $14}'`
Tref=`foamDictionary $case/constant/thermophysicalProperties -entry Tref -value`
#pRef=`foamDictionary $case/constant/thermophysicalProperties -entry pRef -value`
#molWeight=`grep molWeight $case/constant/thermophysicalProperties | head -1 |
#    awk '{print $2}' | awk -F';' '{print $1}'`
#R=`echo $molWeight | awk '{print 8314/$1}'`
#rho0=`echo | awk '{print '$pRef'/('$R'*'$Tref')}'`

heatFluxNorm=`awk 'BEGIN{print -1*'$dTdZ'*'$alpha'}'`
echo T goes from $T0 at $z0 to $TTop at $TTop. dTdZ = $dTdZ. heatFluxNorm = $heatFluxNorm

# Plot global and boundary averages and time mean of global average
mkdir -p $case/plots
gv=0
inputFiles=($case/globalSumheatFluxz.dat
            $case/globalSumheatFluxzTimeMean.dat
            $case/sum_groundheatFluxz.dat
            $case/sum_groundheatFluxzTimeMean.dat
            $case/sum_topheatFluxz.dat
            $case/sum_topheatFluxzTimeMean.dat)
outFile=$case/plots/globalSumheatFluxz.eps
legends=("Global mean" "Global time mean" "Ground mean" "Ground time mean"
         "Top mean" "Top time mean")
pens=("grey" "1.5,black,3_3:0" "red" "1,red,3_3:1.5" "blue" "1,blue,3_3:3")
col=5
colx=1
xlabel="Time"
ylabel="Heat transfer ratio (Nusselt number)"
xmin=0
xmax=`tail -1 $case/globalSumheatFluxz.dat | awk '{print int($1+.999)}'`
dx=`echo $xmax | awk '{print int($1/10+.999)}'`
ymin=0
ymax=100
dy=20
ddy=$dy
dyg=$ymax
xscale=/1
yscale=/$heatFluxNorm
nSkip=1
legPos=x5/6.6
source gmtPlot

awk '{print $1, $5/'$heatFluxNorm'}' $case/globalSumheatFluxzTimeMean.dat \
    > $case/NusseltTimeMean.dat
heatFlux=`tail -1 $case/globalSumheatFluxzTimeMean.dat | awk '{print $5}'`
Nusselt=`awk 'BEGIN{print '$heatFlux'/'$heatFluxNorm'}'`
echo Time and space averaged heat transfer = $heatFlux
echo Nusselt number = $Nusselt
ev $outFile


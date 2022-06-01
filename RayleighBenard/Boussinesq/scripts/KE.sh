#!/bin/bash -e

# Kinetic energy of multi-fluid Boussinesq equations

if [ "$#" -ne 4 ]
then
   echo usage: KE.sh case startTime startAveraging 'partNames'
   exit
fi

case=$1
startTime=$2
startAveraging=$3
parts=($4)
nparts=${#parts[*]}

# Calculate resolved kinetic energy
for part in ${parts[*]}; do
    postProcess -case $case -func "magSqr(u.${part})" -time $startTime:
done
for time in $case/[0-9]*; do
    time=`filename $time`
    if [ $time -ge $startTime ] ; then
        for part in ${parts[*]}; do
            multiplyFields -case $case $time sigmauSqr.${part} \
                $time magSqr\(u.${part}\) $time sigma.${part}
            sumFields -case $case $time KE.$part $time magSqr\(u.${part}\) \
                      $time magSqr\(u.${part}\) -scale0 0.25 -scale1 0.25
        done
        sumFields -case $case $time KE $time sigmauSqr.${parts[0]} \
            $time sigmauSqr.${parts[0]} -scale0 0.25 -scale1 0.25
        for part in ${parts[1]} ${parts[2]} ${parts[3]} ${parts[4]} ${parts[5]}; do
            sumFields -case $case $time KE $time KE $time sigmauSqr.$part -scale1 0.5
        done
        # Sum resolved and TKE
        if [ -f $case/$time/TKE ] ; then
            sumFields -case $case $time totalKE $time KE $time TKE
        else
            ln -sf KE $case/$time/totalKE
        fi
    fi
done

## Alternative total KE
#postProcess -case $case -func "magSqr(u)" -time $startTime:
#for time in $case/[0-9]*; do
#    time=`filename $time`
#    if [ $time -ge $startTime ] ; then
#        sumFields -case $case $time KE $time magSqr\(u\) $time magSqr\(u\) \
#            -scale0 0.25 -scale1 0.25
#    fi
#done

rm $case/*/magSqr*

## Calculate time means
timeMean -case $case -time $startAveraging':' KE
timeMean -case $case -time $startAveraging':' totalKE

# Find nu, b0, bTop, z0 and zTop to non-dimensionalise
nu=`grep nu $case/constant/environmentalProperties | head -1 |
       awk '{print $8}' | awk -F';' '{print $1}'`
alpha=`grep alpha $case/constant/environmentalProperties | head -1 |
       awk '{print $8}' | awk -F';' '{print $1}'`
meshBounds=`checkMesh -case $case -constant \
    | grep 'Overall domain bounding box'`
z0=`echo $meshBounds | awk '{print $7}' | awk -F')' '{print $1}'`
zTop=`echo $meshBounds | awk '{print $10}' | awk -F')' '{print $1}'`
boundarySum b -case $case ground -time 0 1>/dev/null
boundarySum b -case $case top -time 0 1>/dev/null
b0=`tail -1 $case/sum_groundb.dat | awk '{print $5}'`
bTop=`tail -1 $case/sum_topb.dat | awk '{print $5}'`
H=`awk BEGIN'{print '$zTop'-'$z0'}'`
B=`awk BEGIN'{print '$b0'-('$bTop')}'`
Pr=`awk BEGIN'{print '$nu'/'$alpha'}'`
Ra=`awk BEGIN'{print '$B'*'$H'**3/('$alpha'*'$nu')}'`
Uscale=`awk BEGIN'{print sqrt('$B'*'$H')}'`
ReScale=`awk BEGIN'{print sqrt('$Ra'/'$Pr')/'$Uscale'}'`

awk BEGIN'{print "Ra = ",'$Ra',", Pr = ",'$Pr',", Uscale = ",'$Uscale',", ReScale = ",'$ReScale'}'

# Globally average the KE and totalKE and normlise to get Re
globalSum -case $case -time 0':' KE 1>/dev/null
globalSum -case $case -time 0':' totalKE 1>/dev/null
globalSum -case $case -time ${startAveraging}':' totalKETimeMean 1>/dev/null
globalSum -case $case -time ${startAveraging}':' KETimeMean 1>/dev/null
awk '{print $1, sqrt($5)*'$ReScale'}' $case/globalSumKE.dat \
    > $case/globalSumRe.dat
awk '{print $1, sqrt($5)*'$ReScale'}' $case/globalSumtotalKE.dat \
    > $case/globalSumtotalRe.dat
awk '{print $1, sqrt($5)*'$ReScale'}' $case/globalSumKETimeMean.dat \
    > $case/globalSumReTimeMean.dat
awk '{print $1, sqrt($5)*'$ReScale'}' $case/globalSumtotalKETimeMean.dat \
    > $case/globalSumtotalReTimeMean.dat

# Plot global averaged and time mean of global average KE
mkdir -p $case/plots
gv=0
inputFiles=($case/globalSumtotalRe.dat $case/globalSumtotalReTimeMean.dat 
            $case/globalSumRe.dat $case/globalSumReTimeMean.dat)
outFile=$case/plots/globalSumRe.eps
legends=("Global mean total Re" "Time mean" "Global mean resolved Re" "Time mean")
pens=("black" "1.5,black,3_3:0" "grey" "1.5,grey,3_3:0")
col=2
colx=1
xlabel="Time (s)"
ylabel="Reynolds number"
xmin=0
xmax=`tail -1 $case/globalSumRe.dat | awk '{print int($1+.999)}'`
dx=`echo $xmax | awk '{print int($1/10+.999)}'`
ymin=0
ymax=3000
dy=500
ddy=$dy
dyg=$ymax
xscale=/1
yscale=/1
nSkip=1
legPos=x7/2
source gmtPlot
ev $outFile


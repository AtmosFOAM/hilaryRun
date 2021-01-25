##!/bin/bash -e

if [ "$#" -ne 3 ]
then
   echo usage: runOne.sh res c MPDATAtype
   exit
fi

res=$1
c=$2
MPDATAtype=$3

let cValue=$c

if [[ $c == 0* ]]; then cValue=`echo $c | awk '{print (0.1**('${#c}'-1))*$1}'`; fi

dt=`echo $cValue $res | awk '{print 6*$1*40/$2}'`

echo $MPDATAtype, res = $res, c = $c, cValue = $cValue, dt = $dt

# First ensure that mesh and initial conditions are set up for this resolution
resDir=${res}x${res}
# Create the mesh
if [[ ! -f $resDir/constant/polyMesh/points ]]; then
    rm -rf $resDir/constant
    mkdir -p $resDir
    cp -r constant $resDir
    cp -r system $resDir
    sed -i 's/NX/'$res'/g' $resDir/system/blockMeshDict
    sed -i 's/DT/0/g' $resDir/system/controlDict
    blockMesh -case $resDir
fi
# Set up the initial conditions
if [[ ! -f $resDir/0/T ]]; then
    rm -rf $resDir/0
    mkdir $resDir/0
    cp $resDir/constant/Tsave $resDir/constant/T_analytic_init
    setAnalyticTracerField -case $resDir
    setVelocityField -case $resDir
    cp $resDir/0/T_analytic $resDir/0/T
fi

# Set up the analytic solutions
times='120 240 360 480 600'
if [[ ! -f $resDir/analytic/120/T_analytic ]]; then
    mkdir -p $resDir/analytic
    ln -sf ../0 $resDir/analytic/0
    ln -sf ../system $resDir/analytic/system
    ln -sf ../constant $resDir/analytic/constant
    for time in $times; do
        mkdir $resDir/analytic/$time
    done
    setAnalyticTracerField -case $resDir/analytic
    globalSum -case $resDir/analytic T_analytic
fi


# Set up the case
case=$resDir/c${c}_$MPDATAtype
rm -rf $case
mkdir $case
ln -s ../0 $case/0
ln -s ../constant $case/constant
cp -r $resDir/system $case
sed 's/DT/'$dt'/g' system/controlDict > $case/system/controlDict
if [[ $MPDATAtype == exp ]]; then
    sed -i 's/MPDATAtype/0 10 1/g' $case/system/fvSchemes
elif [[ $MPDATAtype == imp ]]; then
    sed -i 's/MPDATAtype/0 0 1/g' $case/system/fvSchemes
elif [[ $MPDATAtype == impExp ]]; then
    sed -i 's/MPDATAtype/0 1 1/g' $case/system/fvSchemes
elif [[ $MPDATAtype == exp_upImp ]]; then
    sed -i 's/MPDATAtype/0 1 0/g' $case/system/fvSchemes
else
    echo MPDATAtype $MPDATAtype not recognised. Should be one of exp imp impExp exp_upImp
    exit
fi

# Run the case
echo -e running $case. Type\\ntail -f $case/log\\nto monitor progress
#implicitAdvectionFoam -case $case >& $case/log &
implicitAdvectionFoam -case $case |& tee $case/log

##!/bin/bash -e

if [ "$#" -ne 4 ]
then
   echo usage: runOne.sh ny meshType c MPDATAtype
   exit
fi

ny=$1
meshType=$2
c=$3
MPDATAtype=$4

let cValue=$c

if [[ $c == 0* ]]; then cValue=`echo $c | awk '{print (0.1**('${#c}'-1))*$1}'`; fi

dt=`echo $cValue $ny | awk '{print $1/$2*120/100.}'`

# First ensure that mesh and initial conditions are set up for this resolution
# Create the mesh
meshDir=`./runAll/initMesh.sh $meshType $ny`
# Set up the initial conditions
./runAll/init0.sh $meshDir > $meshDir/initLog


# Set up the case
case=$meshDir/c${c}_$MPDATAtype
rm -rf $case
mkdir $case
ln -s ../0 $case/0
ln -s ../constant $case/constant
cp -r $meshDir/system $case
sed 's/DELTAT/'$dt'/g' dummy/system/controlDict > $case/system/controlDict
if [[ $MPDATAtype == exp ]]; then
    sed -i 's/MPDATAtype/0 10 1/g' $case/system/fvSchemes
elif [[ $MPDATAtype == expGauge ]]; then
    sed -i 's/MPDATAtype/1 10 1/g' $case/system/fvSchemes
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
#echo -e running $case. Type\\ntail -f $case/log\\nto monitor progress
#implicitAdvectionFoam -case $case >& $case/log &
implicitAdvectionFoam -case $case |& tee $case/log 1>&2

echo $case

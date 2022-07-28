#!/bin/bash -e

if [ "$#" -ne 2 ]
then
   echo usage: graphs.sh case time
   exit
fi

case=$1
time=$2

# Get parameters from reference file and OpenFOAM files
nu=`grep nu $case/constant/transportProperties | awk '{print $NF}' \
    | awk -F ';' '{print $1}'`
delta=1
uTau=`grep uTau $case/log | tail -1 | awk '{print $6}' | awk -F',' '{print $1}'`
RASModel=`grep RASModel $case/constant/turbulenceProperties \
    | awk '{print $2}' | awk -F';' '{print $1}'`
kappa=`grep kappa constant/turbulenceProperties | awk '{print $2}' \
    | awk -F';' '{print $1}'`

# Plot graphs
for var in Uf; do
    sed 's%CASETIME%'$case/$time'%g' $case/plotScripts/$var.gmt \
        | sed 's%DELTA%'$delta'%g' | sed 's%UTAU%'$uTau'%g' \
        | sed 's%NU%'$nu'%g' | sed 's%RASMODEL%'$RASModel'%g'\
        | sed 's%MODEL%'$case/postProcessing/graphs/$time/$var'%g' \
        > $case/plotScripts/tmp.gmt;  gmtPlot $case/plotScripts/tmp.gmt
done

ln -sf ../$case/scripts/results.lyx $case/$time/results.lyx
lyx --export pdf $case/$time/results.lyx 1> /dev/null
pdfCrop $case/$time/results.pdf
ev $case/$time/results.pdf

# Tidy up files
rm $case/plotScripts/tmp.gmt


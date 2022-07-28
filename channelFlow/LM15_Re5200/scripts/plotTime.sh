#!/bin/bash -e

if [ "$#" -ne 2 ]
then
   echo usage: graphs.sh case time
   exit
fi

case=$1
time=$2
ref=/home/hilary/latex/codeNotes/BLturbulence/channelFlow/LM15data

# Get parameters from reference file and OpenFOAM files
nu=`grep nu $case/constant/transportProperties | awk '{print $NF}' \
    | awk -F ';' '{print $1}'`
u_tau=`grep Friction $ref/LM_Channel_5200_mean_prof.dat | awk '{print $6*1}'`
delta=`grep delta $ref/LM_Channel_5200_mean_prof.dat | head -1 | awk '{print $7}'`
uTau=`grep uTau $case/log | tail -1 | awk '{print $6}' | awk -F',' '{print $1}'`
RASModel=`grep RASModel $case/constant/turbulenceProperties \
    | awk '{print $2}' | awk -F';' '{print $1}'`
kappa=`grep kappa constant/turbulenceProperties | awk '{print $2}' \
    | awk -F';' '{print $1}'`
kappa=0.384
z1=2e-3
kappaz1=`echo $kappa $z1 | awk '{print $1*$2}'`

# Plot graphs
echo $z1 $kappaz1 | cat - postProcessing/graphs/$time/lm2.xy  \
    | sponge postProcessing/graphs/$time/lm2.xy
for var in Uf k epsilon nut TKEproduction TKEturbulentTransport \
           gammaDot lm; do
    sed 's%CASETIME%'$case/$time'%g' $case/scripts/$var.gmt \
        | sed 's%REF%'$ref'%g' | sed 's%DELTA%'$delta'%g' \
        | sed 's%U_TAU%'$u_tau'%g' | sed 's%UTAU%'$uTau'%g' \
        | sed 's%NU%'$nu'%g' | sed 's%RASMODEL%'$RASModel'%g'\
        | sed 's%MODEL%'$case/postProcessing/graphs/$time/$var'%g' \
        > $case/scripts/tmp.gmt;  gmtPlot $case/scripts/tmp.gmt
done

ln -sf ../$case/scripts/results.lyx $case/$time/results.lyx
lyx --export pdf $case/$time/results.lyx 1> /dev/null
pdfCrop $case/$time/results.pdf
ev $case/$time/results.pdf

# Tidy up files
rm $case/scripts/tmp.gmt


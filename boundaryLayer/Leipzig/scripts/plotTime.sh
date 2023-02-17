#!/bin/bash -e

if [ "$#" -ne 2 ]
then
   echo usage: graphs.sh case time
   exit
fi

case=$1
time=$2

# Get parameters from reference file and OpenFOAM files
uTau=`grep uTau $case/log | tail -1 | awk '{print $7}'`

# Plot uTau as a function of time
tail -5000000 $case/log | grep uTau | awk '{print $1, $7}' \
    > $case/postProcessing/graphs/uTau.xy

echo -e '0 0\n3000 0' > $case/postProcessing/graphs/zero.xy
echo -e '0 17.5\n3000 17.5'> $case/postProcessing/graphs/Ug.xy
echo -e '1.5e-5 0\n3000 1.5e-5'> $case/postProcessing/graphs/nu.xy

# Plot graphs
for var in U ke nut_lm  uTau Cmu eta Ri dbdz; do
    sed 's%CASE%'$case'%g' $case/plotScripts/$var.gmt \
        | sed 's%GRAPHS%'$case/postProcessing/graphs'%g' \
        | sed 's%TIME%'$time'%g' \
        > $case/plotScripts/tmp.gmt;  gmtPlot $case/plotScripts/tmp.gmt
#    if [[ -a $case/$time/$var.eps ]]; then
#        ev $case/$time/$var.eps &
#    fi
done

ln -sf ../$case/scripts/results.lyx $case/$time/results.lyx
lyx --export pdf $case/$time/results.lyx 1> /dev/null
pdfCrop $case/$time/results.pdf
ln -sf $case/$time/results.pdf $case/results.pdf
ev $case/results.pdf

# Tidy up files
rm $case/plotScripts/tmp.gmt


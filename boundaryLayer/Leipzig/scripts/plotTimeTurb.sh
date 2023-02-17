#!/bin/bash -e

if [ "$#" -ne 2 ]
then
   echo usage: graphs.sh case time
   exit
fi

case=$1
time=$2

echo -e '0 0\n3000 0' > $case/postProcessing/graphs/zero.xy

# Plot graphs
for var in Cmu eta Ri Us; do
    sed 's%CASE%'$case'%g' $case/plotScripts/$var.gmt \
        | sed 's%RASMODEL%'$time\ $var'%g'\
        | sed 's%GRAPHS%'$case/postProcessing/graphs'%g' \
        | sed 's%TIME%'$time'%g' \
        > $case/plotScripts/tmp.gmt;  gmtPlot $case/plotScripts/tmp.gmt
done

ln -sf ../$case/scripts/resultsTurb.lyx $case/$time/resultsTurb.lyx
lyx --export pdf $case/$time/resultsTurb.lyx 1> /dev/null
pdfCrop $case/$time/resultsTurb.pdf
ev $case/$time/resultsTurb.pdf

# Tidy up files
rm $case/plotScripts/tmp.gmt


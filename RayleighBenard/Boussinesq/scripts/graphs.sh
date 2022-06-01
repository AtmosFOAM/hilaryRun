#!/bin/bash -e

if [ "$#" -lt 2 ]
then
   echo usage: graphs.sh case time [timeMean]
   exit
fi

case=$1
time=$2
timeMean=
if [ "$#" -eq 3 ]; then timeMean=TimeMean; fi

alpha=`grep alpha $case/constant/environmentalProperties \
    | awk 'NR==1{print $8}' | awk -F';' '{print $1}'`
nu=`grep nu $case/constant/environmentalProperties \
    | awk 'NR==1{print $8}' | awk -F';' '{print $1}'`

# Sum pressure in each fluid if needed
if [ -f $case/$time/p.stable ]; then
    for part in stable up down; do
        sumFields -case $case $time P.$part $time P $time p.$part  \
            1> /dev/null
    done
fi

for var in sigma b u P KE TKE; do
    for part in stable up down; do
        writeCellDataxyz -case $case -time $time ${var}.${part}${timeMean}
        sort -g -k 3 $case/$time/${var}.${part}${timeMean}.xyz \
            | sponge $case/$time/${var}.${part}.xyz
    done
done
for var in heatTransferz KE; do
    writeCellDataxyz -case $case -time $time ${var}${timeMean}
    sort -g -k 3 $case/$time/${var}${timeMean}.xyz | sponge $case/$time/$var.xyz
done

# Convert heatTransfer and KE to Nu and Re
awk '{if (NR==1) print $0; else print $1, $2, $3, $4/'$alpha'}' \
    $case/$time/heatTransferz.xyz > $case/$time/Nu.xyz
for part in '' .stable .up .down; do
    awk '{if (NR==1) print $0; else print $1, $2, $3, sqrt($4/('$alpha'*'$nu'))}' \
        $case/$time/KE$part.xyz > $case/$time/Re$part.xyz
done

for var in sigma b w P Nusselt Re KE; do
    sed 's%TIME%'$case/$time'%g' $case/gmtFiles/$var.gmt \
        > $case/gmtFiles/tmp.gmt;  gmtPlot $case/gmtFiles/tmp.gmt
done

ln -sf ../gmtFiles/results.lyx $case/$time/results.lyx
lyx --export pdf $case/$time/results.lyx 1> /dev/null
pdfCrop $case/$time/results.pdf
ev $case/$time/results.pdf


#!/bin/bash -e

if [ "$#" -ne 1 ]
then
   echo usage: graphs.sh time
   exit
fi

time=$1
alpha=`grep alpha constant/environmentalProperties | awk 'NR==1{print $8}' |\
    awk -F';' '{print $1}'`
nu=`grep nu constant/environmentalProperties | awk 'NR==1{print $8}' |\
    awk -F';' '{print $1}'`
twonu=`awk BEGIN'{print 2*'$nu'}'`

echo Summing pressure in each fluid
#########################################
for part in stable up down; do
    sumFields $time P.$part $time P $time p.$part  > /dev/null
done

echo Writing out xyz data
for var in b u uSqr P sigma massTransfer.stable massTransfer.up massTransfer.down; do
    for part in '' .stable .up .down; do
        if [ -a $time/${var}${part} ]; then
            writeCellDataxyz -time $time ${var}${part} > /dev/null
            sort -g -k 3 $time/${var}${part}.xyz \
                | sponge $time/${var}${part}.xyz
        fi
    done
done
for var in heatTransferz KE; do
    writeCellDataxyz  -time $time $var
    sort -g -k 3 $time/$var.xyz | sponge $time/$var.xyz
done

# Create plots
sed 's/TIME/'$time'/g' gmtFiles/b.gmt > gmtFiles/tmp.gmt; \
    gmtPlot gmtFiles/tmp.gmt
sed 's/TIME/'$time'/g' gmtFiles/w.gmt > gmtFiles/tmp.gmt; \
    gmtPlot gmtFiles/tmp.gmt
sed 's/TIME/'$time'/g' gmtFiles/P.gmt > gmtFiles/tmp.gmt; \
    gmtPlot gmtFiles/tmp.gmt
sed 's/TIME/'$time'/g' gmtFiles/sigma.gmt > gmtFiles/tmp.gmt; \
    gmtPlot gmtFiles/tmp.gmt
sed 's/TIME/'$time'/g' gmtFiles/massTransfer.gmt > gmtFiles/tmp.gmt; \
    gmtPlot gmtFiles/tmp.gmt
sed 's/TIME/'$time'/g;s/ALPHA/'$alpha'/g' gmtFiles/Nusselt.gmt \
    > gmtFiles/tmp.gmt; gmtPlot gmtFiles/tmp.gmt
sed 's/TIME/'$time'/g;s/TWONU/'$twonu'/g;s/NU/'$nu'/g' gmtFiles/KE.gmt \
    > gmtFiles/tmp.gmt; gmtPlot gmtFiles/tmp.gmt
rm gmtFiles/tmp.gmt

#montage -scale 100% -mode concatenate -tile 5x1 \
#    $time/sigma.eps $time/b.eps $time/w.eps $time/P.eps  $time/massTransfer.eps\
#    $time/results.png
#display $time/results.png &
ln -sf ../gmtFiles/results.lyx $time/results.lyx
lyx --export pdf $time/results.lyx 1> /dev/null
pdfCrop $time/results.pdf
ev $time/results.pdf


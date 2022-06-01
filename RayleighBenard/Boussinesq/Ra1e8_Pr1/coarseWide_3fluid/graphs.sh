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

# Write out ascii data to plot
for var in b uz P KE totalKE heatTransferz; do
    writeCellDataxyz -case $case -time $time ${var}
    sort -g -k 3 $case/$time/${var}.xyz | sponge $case/$time/${var}.xyz
done

sed 's/TIME/'$time'/g' gmtFiles/b.gmt > gmtFiles/tmp.gmt; \
    gmtPlot gmtFiles/tmp.gmt
sed 's/TIME/'$time'/g' gmtFiles/w.gmt > gmtFiles/tmp.gmt; \
    gmtPlot gmtFiles/tmp.gmt
sed 's/TIME/'$time'/g' gmtFiles/P.gmt > gmtFiles/tmp.gmt; \
    gmtPlot gmtFiles/tmp.gmt
sed 's/TIME/'$time'/g;s/ALPHA/'$alpha'/g' gmtFiles/Nusselt.gmt \
    > gmtFiles/tmp.gmt; gmtPlot gmtFiles/tmp.gmt
sed 's/TIME/'$time'/g;s/TWONU/'$twonu'/g;s/NU/'$nu'/g' gmtFiles/KE.gmt \
    > gmtFiles/tmp.gmt; gmtPlot gmtFiles/tmp.gmt
rm gmtFiles/tmp.gmt

#montage -scale 100% -mode concatenate -tile 4x1 \
#     $time/sigma.eps $time/b.eps  $time/w.eps $time/P.eps  \
#    $time/results.png
#display $time/results.png &
ln -sf ../gmtFiles/results.lyx $time/results.lyx
lyx --export pdf $time/results.lyx 1> /dev/null
pdfCrop $time/results.pdf
ev $time/results.pdf


#!/bin/bash -e

if [ "$#" -ne 1 ]
then
   echo usage: graphs.sh time
   exit
fi

time=$1
alpha=`grep alpha constant/environmentalProperties | awk 'NR==1{print $8}' |\
    awk -F';' '{print $1}'`

for var in sigma b u P ; do
    for part in Up Down; do
        writeCellDataxyz -case hMeans -time $time ${var}.${part}TimeMean
        sort -g -k 3 hMeans/$time/${var}.${part}TimeMean.xyz \
            | sponge hMeans/$time/${var}.${part}TimeMean.xyz
    done
done
writeCellDataxyz -case hMeans -time $time heatTransferzTimeMean
sort -g -k 3 hMeans/$time/heatTransferzTimeMean.xyz \
    | sponge hMeans/$time/heatTransferzTimeMean.xyz

sed 's/TIME/'$time'/g' gmtFiles/sigma2.gmt > gmtFiles/tmp.gmt; \
    gmtPlot gmtFiles/tmp.gmt
sed 's/TIME/'$time'/g' gmtFiles/b2.gmt > gmtFiles/tmp.gmt; \
    gmtPlot gmtFiles/tmp.gmt
sed 's/TIME/'$time'/g' gmtFiles/w2.gmt > gmtFiles/tmp.gmt; \
    gmtPlot gmtFiles/tmp.gmt
sed 's/TIME/'$time'/g' gmtFiles/P2.gmt > gmtFiles/tmp.gmt; \
    gmtPlot gmtFiles/tmp.gmt
sed 's/TIME/'$time'/g;s/ALPHA/'$alpha'/g' gmtFiles/Nusselt.gmt \
    > gmtFiles/tmp.gmt; gmtPlot gmtFiles/tmp.gmt
rm gmtFiles/tmp.gmt

#montage -scale 100% -mode concatenate -tile 4x1 \
#     $time/sigma.eps $time/b.eps  $time/w.eps $time/P.eps  \
#    $time/results.png
#display $time/results.png &
ln -sf ../gmtFiles/results2.lyx $time/results2.lyx
lyx --export pdf $time/results2.lyx 1> /dev/null
pdfCrop $time/results2.pdf
ev $time/results2.pdf


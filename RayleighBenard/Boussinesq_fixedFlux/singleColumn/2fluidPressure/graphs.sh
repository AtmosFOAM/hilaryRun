#!/bin/bash -e

if [ "$#" -ne 1 ]
then
   echo usage: graphs.sh time
   exit
fi

time=$1

for part in .up .down; do
    sumFields $time P$part $time P $time p$part
done
for part in '' .up .down; do
    for var in b u P sigma ; do
        if [ -a $time/$var$part ]; then
            writeCellDataxyz -time $time $var$part
            sort -g -k 3 $time/$var$part.xyz | sponge $time/$var$part.xyz
        fi
    done
done
for var in massTransfer; do
    for part in up.down down.up; do
        writeCellDataxyz -time $time $var.$part
        sort -g -k 3 $time/$var.$part.xyz | sponge $time/$var.$part.xyz
    done
done
if [ ! -f ../../resolved_1fluid/$time/b.xyz ]; then
    ../../resolved_1fluid/graphData.sh ../../resolved_1fluid $time
fi

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
#sed 's/TIME/'$time'/g' gmtFiles/bT.gmt > gmtFiles/tmp.gmt; \
#    gmtPlot gmtFiles/tmp.gmt

montage -scale 150% -mode concatenate -tile 5x1 \
    $time/sigma.eps $time/b.eps $time/w.eps $time/P.eps $time/massTransfer.eps \
    $time/results.png
display $time/results.png &


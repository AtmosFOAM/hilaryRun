#!/bin/bash -e

if [ "$#" -ne 1 ]
then
   echo usage: graphs.sh time
   exit
fi

time=$1

for part in stable up down; do
    sumFields $time P.$part $time P $time p.$part
done

for var in b u P sigma ; do
    for part in Stable Up Down; do
        if [ -a $time/$var$part ]; then
            writeCellDataxyz -time $time $var$part
            sort -g -k 3 $time/$var$part.xyz | sponge $time/$var$part.xyz
        fi
    done
done
for var in massTransfer; do
    for part in stable.down stable.up up.stable up.down down.stable down.up; do
        writeCellDataxyz -time $time $var.$part
        sort -g -k 3 $time/$var.$part.xyz | sponge $time/$var.$part.xyz
    done
done

sed 's/TIME/'$time'/g' gmtFiles/b.gmt > gmtFiles/tmp.gmt; \
    gmtPlot gmtFiles/tmp.gmt
sed 's/TIME/'$time'/g' gmtFiles/w.gmt > gmtFiles/tmp.gmt; \
    gmtPlot gmtFiles/tmp.gmt
sed 's/TIME/'$time'/g' gmtFiles/P.gmt > gmtFiles/tmp.gmt; \
    gmtPlot gmtFiles/tmp.gmt
sed 's/TIME/'$time'/g' gmtFiles/sigma.gmt > gmtFiles/tmp.gmt; \
    gmtPlot gmtFiles/tmp.gmt
#sed 's/TIME/'$time'/g' gmtFiles/massTransfer.gmt > gmtFiles/tmp.gmt; \
#    gmtPlot gmtFiles/tmp.gmt
#sed 's/TIME/'$time'/g' gmtFiles/bT.gmt > gmtFiles/tmp.gmt; \
#    gmtPlot gmtFiles/tmp.gmt
rm gmtFiles/tmp.gmt

montage -scale 150% -mode concatenate -tile 4x1 \
    $time/sigma.eps $time/b.eps $time/w.eps $time/P.eps  \
    $time/results.png
display $time/results.png &


#!/bin/bash -e

if [ "$#" -ne 1 ]
then
   echo usage: graphs.sh time
   exit
fi

time=$1

for var in b u P ; do
    if [ -a $time/$var ]; then
        writeCellDataxyz -time $time $var
        sort -g -k 3 $time/$var.xyz | sponge $time/$var.xyz
    fi
done

sed 's/TIME/'$time'/g' gmtFiles/b.gmt > gmtFiles/tmp.gmt; \
    gmtPlot gmtFiles/tmp.gmt
sed 's/TIME/'$time'/g' gmtFiles/w.gmt > gmtFiles/tmp.gmt; \
    gmtPlot gmtFiles/tmp.gmt
sed 's/TIME/'$time'/g' gmtFiles/P.gmt > gmtFiles/tmp.gmt; \
    gmtPlot gmtFiles/tmp.gmt
rm gmtFiles/tmp.gmt

montage -scale 100% -mode concatenate -tile 3x1 \
     $time/b.eps $time/w.eps $time/P.eps  \
    $time/results.png
display $time/results.png &


#!/bin/bash -e

if [ "$#" -ne 2 ]
then
   echo usage: plotOne.sh dirName time
   exit
fi

dir=$1
time=$2

here=$PWD
cd $dir

# Create ascii data files of all fields
for field in sigma.buoyant b b.stable b.buoyant Uf Uf.buoyant Uf.stable \
         massTransfer.buoyant.stable massTransfer.stable.buoyant dPdz.stable \
         dPdz.buoyant ; do
    for t in 0 $time; do
        writeCellDataxyz $field -time $t

        grep 500 $t/$field.xyz | sort -g -k 3 > $t/$field.xyzSorted
        mv $t/$field.xyzSorted $t/$field.xyz
    done
done

# Graphs of all fields
for field in sigma b u massTransfer dPdz; do
    sed 's/TIME/'$time'/g' plots/$field.gmt > plots/tmp.gmt; \
    gmtPlot plots/tmp.gmt
    eps2png $time/$field.eps
done
montage $time/sigma.png $time/massTransfer.png $time/b.png $time/u.png \
        $time/dPdz.png -tile 5x1 -geometry +0+0 $time/results.png
eog -w $time/results.png &

cd $here


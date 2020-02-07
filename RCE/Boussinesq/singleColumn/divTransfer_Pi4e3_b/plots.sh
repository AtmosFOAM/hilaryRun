#!/bin/bash -e

# Create ascii data files of all fields
for fluid in buoyant stable; do
    for file in */'div(volFlux.'$fluid')'; do
        if [ -a $file ]; then
            dir=`dirname $file`
            mv $file $dir/divu.$fluid
        fi
    done
done
for field in sigma.buoyant b b.stable b.buoyant Uf Uf.buoyant Uf.stable \
         massTransfer.buoyant.stable massTransfer.stable.buoyant dPdz.stable \
         dPdz.buoyant ; do
         #divu.stable divu.buoyant ; do
    writeCellDataxyz $field
    
   for time in [0-9]*; do
       grep 500 $time/$field.xyz | sort -g -k 3 > $time/$field.xyzSorted
       mv $time/$field.xyzSorted $time/$field.xyz
    done
done

# Graphs of all fields
times=`ls -d [0-9]* | sort -g`
for time in $times; do
    for field in sigma b u massTransfer dPdz; do
        sed 's/TIME/'$time'/g' plots/$field.gmt > plots/tmp.gmt; \
        gmtPlot plots/tmp.gmt
        eps2png $time/$field.eps
    done
    montage $time/sigma.png $time/massTransfer.png $time/b.png $time/u.png \
            $time/dPdz.png -tile 5x1 -geometry +0+0 $time/results.png
    eog -w $time/results.png &
done
convert 0/results.png ?????/results.png ??????/results.png results.gif
animate results.gif &


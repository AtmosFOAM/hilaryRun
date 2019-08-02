#!/bin/bash -e

## Plot cooling rate, Q
#grep value [0-9]*/Q | awk -F'/' '{print $1, $2}' | awk '{print $1, $3}' \
#     | awk -F';' '{print $1}'| sort -n > plots/Q.dat
#gmtPlot plots/Q.gmt

# Create ascii data files of all fields
for fluid in buoyant stable; do
    for file in */'div(volFlux.'$fluid')'; do
        dir=`dirname $file`
        mv $file $dir/divu.$fluid
    done
done
for field in sigma.buoyant b b.stable b.buoyant Uf Uf.buoyant Uf.stable \
         massTransfer.buoyant.stable massTransfer.stable.buoyant \
         divu.stable divu.buoyant ; do
    writeCellDataxyz $field
    
   for time in [0-9]*; do
       grep 100000 $time/$field.xyz | grep 500 | sort -g -k 3 > $time/$field.xyzSorted
       mv $time/$field.xyzSorted $time/$field.xyz
    done
done

# Graphs of all fields
times=`ls -d [0-9]* | sort -g`
for time in $times; do
    for field in sigma b u massTransfer divu; do
        sed 's/TIME/'$time'/g' plots/$field.gmt > plots/tmp.gmt; \
        gmtPlot plots/tmp.gmt
        eps2png $time/$field.eps
    done
    montage $time/sigma.png $time/massTransfer.png $time/b.png $time/u.png $time/divu.png \
             -tile 5x1 -geometry +0+0 $time/results.png
    eog -w $time/results.png &
done
convert ?/results.png ?????/results.png ??????/results.png \
         results.gif
animate results.gif &


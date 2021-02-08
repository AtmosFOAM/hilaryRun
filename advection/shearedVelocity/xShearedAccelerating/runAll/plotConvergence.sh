#!/bin/bash -e

time=120
# Gather data for each c and for each simulation type
c=05
ress='80 160 320'
for type in imp exp; do
    echo '#dx l2 linf' > plots/errors_c${c}_${type}.dat
    for res in $ress; do
        dx=`echo $res | awk '{print 10000/$1}'`
        resDir=${res}x${res}
        awk '{ if ($1 == '$time') print '$dx', $3, $4 }' \
            $resDir/c${c}_${type}/errorNorms.dat \
                >> plots/errors_c${c}_${type}.dat
    done
done

for type in imp exp_upImp impExp; do
    for c in 1 2 4; do
        echo '#dx l2 linf' > plots/errors_c${c}_${type}.dat
        for res in $ress; do
            dx=`echo $res | awk '{print 10000/$1}'`
            resDir=${res}x${res}
            awk '{ if ($1 == '$time') print '$dx', $3, $4 }' \
                $resDir/c${c}_${type}/errorNorms.dat \
                    >> plots/errors_c${c}_${type}.dat
        done
    done
done

# 1st-2nd order lines
echo '#dx 1stOrder' > plots/firstOrder.dat
echo -e '15 0.05\n150 0.5' >> plots/firstOrder.dat
echo '#dx 2ndOrder' > plots/secondOrder.dat
echo -e '15 0.005\n150 0.5' >> plots/secondOrder.dat

# Plot convergence data
gmtPlot plots/l2errors.gmt
gmtPlot plots/l2errorsMore.gmt


#!/bin/bash -e


# Start conditional averaging
case=.
startAverageTime=32
conditionalAverage -case $case uz 0 Down Up -time $startAverageTime':'

# Conditionally average b, P and u and horizontally average
# Multiply by sigma
for var in P b u; do
    for part in Up Down; do
        for time in [0-9]*; do
            if [ $time -ge $startAverageTime ]; then
                echo $time sigma$var.$part $time $var $time sigma.$part
                multiplyFields $time sigma$var.$part $time $var $time sigma.$part
            fi
        done
    done
done

# Horizontally average
blockMesh -case hMeans
horizontalMean -case $case hMeans 144 '(sigma.Up sigma.Down
                                        sigmab.Up sigmab.Down
                                        sigmau.Up sigmau.Down
                                        sigmaP.Up sigmaP.Down)' \
    -time $startAverageTime':'

# Divide by sigma
for var in P b u; do
    for part in Up Down; do
        for time in [0-9]*; do
            if [ $time -ge $startAverageTime ]; then
                multiplyFields -case hMeans $time $var.$part $time \
                    sigma$var.$part $time sigma.$part -pow1 -1
            fi
        done
    done
done

# Time averages
for part in Up Down; do
    for var in sigma P b u; do
        timeMean -case hMeans -time $startAverageTime':' ${var}.${part}
    done
done

./graphs2.sh 152


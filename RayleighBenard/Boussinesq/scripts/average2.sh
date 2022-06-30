#!/bin/bash -e

# Conditionally and horizontally average into 2 domains

if [ "$#" -ne 2 ]
then
   echo usage: average2.sh case startAveraging
   exit
fi

case=$1
startAveraging=$2 

# Conditionally average based on sign of uz (w)
writeuvw u -case $case
conditionalAverage -case $case -time $startAveraging':' uz 0 down up

# Conditionally average b, P and u and KE and horizontally average
# Multiply by sigma
for var in P b u KE heatTransfer; do
    for part in up down; do
        for time in $case/[0-9]*; do
        t=`filename $time`
            if [ $t -ge $startAveraging ]; then
                echo $t sigma$var.$part $t $var $t sigma.$part
                multiplyFields -case $case $t sigma$var.$part \
                        $t $var $t sigma.$part
            fi
        done
    done
done

# Horizontally average
blockMesh -case $case/hMeans2
nCells1=`checkMesh -case $case | grep cells | head -1 | awk '{print $2}'`
nCellsh=`checkMesh -case $case/hMeans | grep cells | head -1 | awk '{print $2}'`
cellRatio=`echo $nCells1 $nCellsh | awk '{print $1/$2}'`

horizontalMean -case $case -time $startAveraging':' $case/hMeans2 $cellRatio \
    '(sigma.up sigma.down
      sigmab.up sigmab.down
      sigmau.up sigmau.down
      sigmaP.up sigmaP.down
      sigmaKE.up sigmaKE.down KE
      sigmaheatTransfer.up sigmaheatTransfer.down
      heatTransfer)'

# Time averages
for part in  .up .down; do
    for var in sigma heatTransfer; do
        timeMean -case $case/hMeans2 -time $startAveraging':' ${var}${part}
    done
    for var in P b u KE heatTransfer; do
        timeMean -case $case/hMeans2 -time $startAveraging':' sigma${var}${part}
    done
done
timeMean -case $case/hMeans2 -time $startAveraging':' heatTransfer
timeMean -case $case/hMeans2 -time $startAveraging':' KE

# Divide by sigma
for part in up down; do
    for time in $case/hMeans2/[0-9]*; do
        t=`filename $time`
        if [ $t -ge $startAveraging ]; then
            for var in P b u KE; do
                multiplyFields -case $case/hMeans2 $t $var.${part} $t \
                    sigma$var.$part $t sigma.$part -pow1 -1
                multiplyFields -case $case/hMeans2 $t $var.${part}TimeMean $t \
                    sigma$var.${part}TimeMean $t sigma.${part}TimeMean -pow1 -1
            done
            mv $case/hMeans2/$t/sigmaheatTransfer.$part \
               $case/hMeans2/$t/heatTransfer.$part
            mv $case/hMeans2/$t/sigmaheatTransfer.${part}TimeMean \
               $case/hMeans2/$t/heatTransfer.${part}TimeMean
        fi
    done
done

# Make KE into totalKE then calculate new resolved KE and hence TKE
for time in $case/hMeans2/[0-9]*; do
    t=`filename $time`
    if [ $t -ge $startAveraging ]; then
        for part in '' .up .down; do
            cp $case/hMeans2/$t/KE${part} $case/hMeans2/$t/totalKE${part}save
            cp $case/hMeans2/$t/KE${part}TimeMean \
               $case/hMeans2/$t/totalKE${part}TimeMeansave
        done
        $case/../../scripts/KEoneTime.sh $case/hMeans2 $t 'up down'
        $case/../../scripts/KEtimeMean.sh $case/hMeans2 $t 'up down'
        for part in '' .up .down; do
            mv $case/hMeans2/$t/totalKE${part}save $case/hMeans2/$t/totalKE${part}
            mv $case/hMeans2/$t/totalKE${part}TimeMeansave \
               $case/hMeans2/$t/totalKE${part}TimeMean
            sumFields -case $case/hMeans2 $t TKE${part} \
                $t totalKE${part} $t KE${part} -scale1 -1
            sumFields -case $case/hMeans2 $t TKE${part}TimeMean \
                $t totalKE${part}TimeMean $t KE${part}TimeMean -scale1 -1
        done
    fi
done

rm -f $case/*/sigma?*.* $case/hMeans2/*/sigma?*.*


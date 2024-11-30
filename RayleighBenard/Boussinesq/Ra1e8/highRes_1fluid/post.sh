# Post processing
case=.
startAverageTime=32
writeuvw u

gmtFoam -latestTime $time ub
ev */ub.pdf

# Start conditional averaging
BoussinesqNusselt.sh $case 0 $startAverageTime
BoussinesqKE.sh $case 0 $startAverageTime air
meanHeatTransfer=`awk 'END {print $5}' $case/globalSumheatTransferzTimeMean.dat`
conditionalAverage3 -case $case -time $startAverageTime':' stable up down heatTransferz \
    $meanHeatTransfer uz 0

# Conditionally average b, P and u and KE and horizontally average
# Multiply by sigma
for var in P b u KE; do
    for part in stable up down; do
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
horizontalMean -time $startAverageTime':' hMeans 144 \
    '(sigma.stable sigma.up sigma.down
      sigmab.stable sigmab.up sigmab.down
      sigmau.stable sigmau.up sigmau.down
      sigmaP.stable sigmaP.up sigmaP.down
      sigmaKE.stable sigmaKE.up sigmaKE.down
      KE heatTransferz)'

# Divide by sigma
for var in P b u KE; do
    for part in stable up down; do
        for time in [0-9]*; do
            if [ $time -ge $startAverageTime ]; then
                multiplyFields -case hMeans $time $var.$part $time \
                    sigma$var.$part $time sigma.$part -pow1 -1
            fi
        done
    done
done

# Time averages
for part in stable up down; do
    for var in sigma P b u KE; do
        timeMean -case hMeans -time $startAverageTime':' ${var}.${part}
    done
done
timeMean -case hMeans -time $startAverageTime':' heatTransferz
timeMean -case hMeans -time $startAverageTime':' KE

./graphs.sh 152


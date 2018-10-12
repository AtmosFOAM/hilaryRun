# Plot the differences between the partioned cases and the non-partitioned cases

time=1000

case1=advective/advective_vanLeer
globalSum -case $case1 -time $time theta

for case in partitioned_identical/sigmaBubble \
            partitioned_identical/sigmaBubble2 \
            partitioned_withMassTransfer/partitioned_withMassTransferDiv \
            partitioned_withMassTransfer/partitioned_withMassTransferTheta \
            partitioned_withMassTransfer/partitioned_withMassTransferThetaDivw \
            partitioned_withMassTransfer/partitioned_withMassTransferLowTheta; do
    sumFields -case $case $time thetaDiff $time theta ../../$case1/$time theta -scale1 -1
    globalSum -case $case -time $time thetaDiff
    echo '#time l2Error' > $case/l2Error.dat
    paste $case1/globalSumsum.theta.dat $case/globalSumthetaDiff.dat | tail -1 | \
        awk '{print $1, $11/$3}' >> $case/l2Error.dat
done


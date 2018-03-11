refCase=partitioned_identical/sigmaBubble

cases="advective/advective_vanLeer
       advective/advective_linearUnpwind
       advective/advective_linear
       partitioned_05/divTransfer
       partitioned_05/hiDrag
       partitioned_05/loDiffusion
       partitioned_05/loDrag
       partitioned_05/noTransfer
       partitioned_identical/sigmaBubble
       partitioned_identical/sigmaBubble2
       partitioned_identical/sigmaBubble_linearUpwind
       partitioned_withMassTransferDiv
       partitioned_withMassTransferDivDiv
       partitioned_withMassTransferTheta
       partitioned_withMassTransferThetaDiv"

for case in $cases; do
    meld $case/system $refCase/system
done

find . -name [1-9]* -exec rm -r {} \;

for case in $cases; do
    nohup nice -n 19 partitionedExnerFoamAdv -case $case >& $case/log &
done

# post proecssing
time=1000
for case in $cases; do
    gmtFoam -case $case -time $time sigmaTheta
done

base=$PWD
for case in $cases; do
    cd $case
    mkdir -p plots
    echo $case
    gmtPlot $base/plots/plotEnergy.gmt
    #gmtPlot $base/plots/plotCo.gmt
    #$base/plots/plotRhoDiff.sh
    cd $base
done

gmtPlot plots/plotEnergy1part.gmt
gmtPlot plots/plotEnergy_05.gmt
gmtPlot plots/plotEnergy_transfers.gmt


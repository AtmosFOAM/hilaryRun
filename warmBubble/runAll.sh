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
       partitioned_withMassTransfer/partitioned_withMassTransferDiv
       partitioned_withMassTransfer/partitioned_withMassTransferLowTheta
       partitioned_withMassTransfer/partitioned_withMassTransferTheta
       partitioned_withMassTransfer/partitioned_withMassTransferThetaDivw"

for case in $cases; do
    meld $case/system $refCase/system
done

for case in $cases; do
    rm -r $case/[1-9]*
    nohup nice -n 19 partitionedExnerFoamAdv -case $case >& $case/log &
done

# post proecssing
for time in 0 1000
for case in $cases; do
    for field in sigmaTheta sigmaTheta0 sigmaTheta1; do
        gmtFoam -case $case -time $time $field
        gv $case/$time/$field.pdf &
    done
done

case=partitioned_05/noTransfer
for time in 0 100 200 290; do
    gmtFoam -case $case -time $time sigmaThetaZoom
    gv $case/$time/sigmaThetaZoom.pdf &
done

base=$PWD
for case in $cases; do
    cd $case
    mkdir -p plots
    echo $case
    gmtPlot $base/plots/plotEnergy.gmt
    gmtPlot $base/plots/plotEnergy_BW.gmt
    #gmtPlot $base/plots/plotCo.gmt
    #$base/plots/plotRhoDiff.sh
    cd $base
    pstitle $case/plots/energy.eps
    gv $case/plots/energy.eps &
    pstitle $case/plots/energy_BW.eps
    gv $case/plots/energy_BW.eps &
done

gmtPlot plots/plotEnergy1part.gmt
gmtPlot plots/plotEnergy_05.gmt
gmtPlot plots/plotEnergy_transfers.gmt

gmtPlot plots/plotEnergy1part_BW.gmt
gmtPlot plots/plotEnergy_05_BW.gmt
gmtPlot plots/plotEnergy_transfers_BW.gmt

# Plot difference between partitioned and non-partitioned cases
plots/errors.sh


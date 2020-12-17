#!/bin/bash -e
shopt -s extglob

mkdir -p plots/animategraphics
time=0
t=0
while [ "$time" -le 1000 ]; do
    mkdir -p plots/$time
    sed 's/TIME/'$time'/g' scripts/bSingleFluids.gmt > scripts/tmp.gmt
    gmtPlot scripts/tmp.gmt
    sed 's/TIME/'$time'/g' scripts/bMultiFluids.gmt > scripts/tmp.gmt
    gmtPlot scripts/tmp.gmt
    
    eps2pdf plots/$time/bSingleFluid.eps
    ln -sf ../$time/bSingleFluid.pdf plots/animategraphics/bSingleFluid_$t.pdf
    
    montage plots/$time/bSingleFluid.eps plots/$time/bMultiFluid.eps \
         -tile 2x1 -geometry +0+0 -density 400%x400% \
         plots/animategraphics/bCompare_$t.pdf
    
    let time=$time+100
    let t=$t+1
done

eps2gif plots/bSingleFluid.gif plots/0/bSingleFluid.eps \
        plots/???/bSingleFluid.eps plots/????/bSingleFluid.eps

eps2gif plots/bMultiFluid.gif plots/0/bMultiFluid.eps \
        plots/???/bMultiFluid.eps plots/????/bMultiFluid.eps


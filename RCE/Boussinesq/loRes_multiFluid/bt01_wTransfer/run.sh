#!/bin/bash -e

# clear out old stuff
rm -rf [0-9]* constant/polyMesh core log

# create mesh
blockMesh

# Initial conditions
rm -rf [0-9]* core
mkdir 0
cp -r init_0/* 0
mv 0/transferLocation constant

# Solve Euler equations
multiFluidBoussinesqFoam >& log & sleep 0.01; tail -f log

gmtFoam Ub
pdfjam --papersize '{40cm,10cm}' --outfile Ub.pdf 0/Ub.pdf 50000/Ub.pdf ??????/Ub.pdf

time=370000
for var in b.buoyant b.stable sigma; do
    gmtFoam $var -time $time':'
done
for time in [0-9]*; do
    pdfjam --papersize '{40cm,10cm}' --outfile $time/results.pdf \
        $time/sigma.pdf $time/b.stable.pdf $time/b.buoyant.pdf
    pdfnup $time/results.pdf --nup 1x3
    mv results-nup.pdf $time/results.pdf
done

pdfjam --papersize '{40cm,30cm}' --outfile results.pdf 0/results.pdf \
       [1-9]000/results.pdf [1-9]?0000/results.pdf
evince results.pdf &


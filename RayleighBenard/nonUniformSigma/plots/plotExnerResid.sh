grep ExnerPrime log | grep convergence | awk '{print $2, $5}' \
     > plots/ExnerResid.dat

echo '
inputFiles=("plots/ExnerResid.dat")
outFile=plots/ExnerResid.eps
col=2
colx=1
symbols=("x4p")
pens=("0p")
ylabel="Exner Residual"
legPos=x10/10
nSkip=0
ymin=1e-10
ymax=1e-4
dy=10
dx=10
projection=X15c/10cl
gv=0' > plots/ExnerResid.gmt

gmtPlot plots/ExnerResid.gmt


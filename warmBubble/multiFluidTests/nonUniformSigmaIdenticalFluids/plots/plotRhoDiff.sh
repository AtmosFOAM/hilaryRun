grep rho log | grep Maximum | awk '{print $2, $8}' > plots/rhoDiff.dat

echo '
inputFiles=("plots/rhoDiff.dat")
outFile=plots/rhoDiff.eps
col=2
colx=1
#symbols=("x4p")
#pens=("0p")
xlabel="Time (s)"
ylabel="Density difference"
legPos=x10/10
nSkip=0
projection=X15c/10cl
ymin=1e-10
ymax=1e-5
dy=10
dx=200
gv=0' > plots/rhoDiff.gmt

gmtPlot plots/rhoDiff.gmt


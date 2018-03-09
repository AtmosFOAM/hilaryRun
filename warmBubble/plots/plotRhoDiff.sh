tmpDir=tmp_`date +%N`
mkdir $tmpDir
grep "\bTime\b" log | grep '=' | awk '{print $3}' > $tmpDir/time
grep 'Maximum rho difference fraction' log | awk '{print $6}' > $tmpDir/rhoTmp
echo '#Time rhoDiff' > $tmpDir/rhoDiff.dat
paste $tmpDir/time $tmpDir/rhoTmp >> $tmpDir/rhoDiff.dat
head -n -1 $tmpDir/rhoDiff.dat > plots/rhoDiff.dat

echo '
inputFiles=(plots/rhoDiff.dat)
outFile=plots/rhoDiff.eps
col=2
colx=1
legends=("rho difference")
xlabel="Time (s)"
legPos=x10/10
nSkip=1
projection=X15c/10c
gv=1
' > $tmpDir/rhoDiff.gmt

gmtPlot $tmpDir/rhoDiff.gmt

rm -r $tmpDir


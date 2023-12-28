ref=explicit_dt_2

dirs="explicit_dt_5
      implicit_dt_2 implicit_dt_5 implicit_dt_10 implicit_dt_20
      ImEx_dt_5 ImEx_dt_10  ImEx_dt_20"

#for dir in $dirs; do
#    for time in $dir/[0-9]*; do
#        t=`echo $time | awk -F '/' '{print $NF}'`
#        echo $time $t
#        sumFields -case $dir $t thetaDiff $t thetap ../$ref/$t thetap -scale1 -1
#    done
#    globalSum -case $dir thetaDiff
#done

# Plot options
inputFiles=()
for dir in $dirs; do 
    inputFiles=(${inputFiles[*]} $dir/globalSumthetaDiff.dat); done
outFile=plots/RMSerrors.eps
col=3
colx=1
legends=("Explicit, @~D@~t=5 s"
         "Implicit, @~D@~t=2 s" "Implicit, @~D@~t=5 s" "Implicit, @~D@~t=10 s" "Implicit, @~D@~t=20 s"
         "ImEx, @~D@~t=5 s" "ImEx, @~D@~t=10 s" "ImEx, @~D@~t=20 s")
pens=("1,blue,8_3" 
      "0.5,black" "0.5,blue" "0.5,red" "0.5,green"
      "1.5,blue,2_3" "1.5,red,2_3" "1.5,green,2_3")

xlabel="Time"
ylabel="RMS difference (K)"
xmin=0
xmax=1000
dx=100
ddx=$dx
dxg=0
ymin=1e-6
ymax=0.1
dy=10
ddy=$dy
dyg=$dy
xscale=*1
yscale=*1
legPos=x0.1/6
nSkip=1
projection=X15c/10cl
gv=0
source gmtPlot
ev $outFile


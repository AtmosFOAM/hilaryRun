for dir in */*_dt*; do
    echo $dir
    ./runAll/nIters.sh $dir
done

#for file in Ra*/*/nExnerIter.dat; do
#    root=`fileroot $file`
#    echo $root
#    runningMean.sh 20 $file > ${root}_smooth.dat
#done


gmtPlot runAll/c.gmt
gmtPlot runAll/nItersImEx.gmt
gmtPlot runAll/nItersImplicit.gmt
gmtPlot runAll/nItersExplicit.gmt

./runAll/compareNuCoarse.sh
./runAll/compareNuMid.sh
./runAll/compareNuRa1e6.sh


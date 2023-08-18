for dir in */*_dt*; do
    echo $dir
    logStats.sh $dir Exnerp
done

gmtPlot runAll/c.gmt
gmtPlot runAll/nItersImEx.gmt
gmtPlot runAll/nItersImplicit.gmt
gmtPlot runAll/nItersExplicit.gmt

./runAll/compareNuCoarse.sh
./runAll/compareNuMid.sh
./runAll/compareNuRa1e6.sh


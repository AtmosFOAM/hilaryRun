for dir in */*_dt*; do
    echo $dir
    logStats.sh $dir Exnerp
    runAll/postOne.sh $dir
done

./runAll/compareNuCoarse.sh
./runAll/compareNuMid.sh
./runAll/compareNuRa1e6.sh

gmtPlot runAll/c.gmt
gmtPlot runAll/nItersImEx.gmt
gmtPlot runAll/nItersImplicit.gmt
gmtPlot runAll/nItersExplicit.gmt


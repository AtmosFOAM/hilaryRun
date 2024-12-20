for dir in cubic*_dt_*; do
    echo $dir
    ./runAll/postOne.sh $dir
    ./runAll/nIters.sh $dir
done

gmtPlot runAll/c.gmt
gmtPlot runAll/nItersImplicit.gmt
gmtPlot runAll/nItersImEx.gmt
gmtPlot runAll/nItersExplicit.gmt
./runAll/compareHiRes.sh

for dir in *_dt_*; do
    echo $dir
    ./runAll/nIters.sh $dir
    
done

gmtPlot runAll/c.gmt
gmtPlot runAll/nItersImplicit.gmt
gmtPlot runAll/nItersImEx.gmt
gmtPlot runAll/nItersExplicit.gmt


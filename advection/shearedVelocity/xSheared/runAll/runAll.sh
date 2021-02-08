#!/bin/bash -e

res=20
MPDATAtype=expGauge
c=05

./runAll/runOne.sh $res $c $MPDATAtype

case=`echo *x${res}/c${c}_${MPDATAtype}`
./runAll/plotOne.sh $case >& $case/plotLog&


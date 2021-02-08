#!/bin/bash -e

res=100
MPDATAtype=exp
c=1

./runOne.sh $res $c $MPDATAtype
case=${res}x${res}/c${c}_${MPDATAtype}
./plotOne.sh $case >& $case/plotLog &


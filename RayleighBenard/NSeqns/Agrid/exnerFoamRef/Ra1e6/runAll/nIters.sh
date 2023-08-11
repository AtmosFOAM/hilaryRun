#!/bin/bash

case=$1

# Create file of Courant number versus time
times=(`grep 'Time = ' $case/log | awk '{if (NF == 3) print $3}'`)
c=`grep 'Courant Number mean' $case/log | awk '{print $6}'`

echo "#Time maxC" > $case/c.dat
echo -e ${times[*]}\\n$c | \
    awk '{ for (i=1; i<=NF; i++) a[i]= (a[i]? a[i] FS $i: $i) } END{ for (i in a) print a[i] }' >> $case/c.dat

# Create file of n Exner iterations versus time
noCorr=`grep nOuterCorrectors $case/system/fvSolution | awk '{print $2}' |\
        awk -F';' '{print $1}'`
niCorr=`grep nCorrectors $case/system/fvSolution | awk '{print $2}' \
        | awk -F';' '{print $1}'`
let nCorr=$noCorr+niCorr
nTimes=${#times[*]}

nIter=(`grep 'Solving for Exnerp' $case/log | awk '{print $15}'`)

echo "#Time nExnerIter" > $case/nExnerIter.dat
let it=0
while [ "$it" -lt "$nTimes" ]; do
    let ii=0
    allIters=''
    iterSum=0
    while [ "$ii" -lt "$nCorr" ]; do
        let iterSum=$iterSum+${nIter[4*$it+$ii]}
        allIters=$(echo $allIters " " ${nIter[4*$it+$ii]})
        let ii=$ii+1
    done
    echo ${times[$it]} $iterSum $allIters >> $case/nExnerIter.dat
    let it=$it+1
done


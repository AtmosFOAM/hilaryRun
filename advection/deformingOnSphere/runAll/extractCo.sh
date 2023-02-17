#!/bin/bash -e

case=.

grep 'Courant Number mean' $case/log | awk '{print $4, $6}' \
    | sed -e "1d" > $case/Co.dat
echo 0 > $case/time.dat
grep 'Time =' $case/log | awk '{print $3}' >> $case/time.dat
paste $case/time.dat $case/Co.dat  | sponge $case/time.dat
echo '#Time mean max' > $case/Co.dat
head -n -1 $case/time.dat >> $case/Co.dat
rm $case/time.dat


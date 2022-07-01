#!/bin/bash -e

# Kinetic energy of multi-fluid Boussinesq equations at one time

if [ "$#" -ne 3 ]
then
   echo usage: KE.sh case time 'partNames'
   exit
fi

case=$1
time=$2
parts=($3)
nparts=${#parts[*]}

# Calculate resolved kinetic energy
for part in ${parts[*]}; do
    postProcess -case $case -func "magSqr(u.${part}TimeMean)" -time $time
done
for part in ${parts[*]}; do
    multiplyFields -case $case $time sigmauSqr.${part} \
        $time magSqr\(u.${part}TimeMean\) $time sigma.${part}TimeMean
    sumFields -case $case $time KE.${part}TimeMean $time sigmauSqr.${part} \
              $time sigmauSqr.${part} -scale0 0.25 -scale1 0.25
done
sumFields -case $case $time KETimeMean $time sigmauSqr.${parts[0]} \
    $time sigmauSqr.${parts[0]} -scale0 0.25 -scale1 0.25
for part in ${parts[1]} ${parts[2]} ${parts[3]} ${parts[4]} ${parts[5]}; do
    sumFields -case $case $time KETimeMean $time KETimeMean $time sigmauSqr.$part -scale1 0.5
done

# Tidy up files
rm -f $case/$time/magSqr* $case/$time/sigmauSqr.*

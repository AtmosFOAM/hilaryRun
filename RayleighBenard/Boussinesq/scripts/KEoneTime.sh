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
    postProcess -case $case -func "magSqr(u.${part})" -time $time
done
for part in ${parts[*]}; do
    multiplyFields -case $case $time sigmauSqr.${part} \
        $time magSqr\(u.${part}\) $time sigma.${part}
    sumFields -case $case $time KE.$part $time magSqr\(u.${part}\) \
              $time magSqr\(u.${part}\) -scale0 0.25 -scale1 0.25
done
sumFields -case $case $time KE $time sigmauSqr.${parts[0]} \
    $time sigmauSqr.${parts[0]} -scale0 0.25 -scale1 0.25
for part in ${parts[1]} ${parts[2]} ${parts[3]} ${parts[4]} ${parts[5]}; do
    sumFields -case $case $time KE $time KE $time sigmauSqr.$part -scale1 0.5
done
# Sum resolved and TKE
if [ -f $case/$time/TKE ] ; then
    sumFields -case $case $time totalKE $time KE $time TKE
else
    ln -sf KE $case/$time/totalKE
fi


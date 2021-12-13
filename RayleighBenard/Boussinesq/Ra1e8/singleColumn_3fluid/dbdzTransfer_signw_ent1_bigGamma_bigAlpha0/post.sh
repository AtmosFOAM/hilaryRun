# Post processing

# Calculate Nusselt number
BoussinesqNusselt.sh . 0 30
BoussinesqKE.sh . 0 30 'stable up down'

for time in [0-9]*; do for part in stable up down; do
    if [ -a $time/magSqr\(u.${part}\) ]; then
        mv $time/magSqr\(u.${part}\) $time/uSqr.${part}
    fi
done; done

time=50
./graphs.sh $time


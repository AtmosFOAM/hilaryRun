#!/bin/bash -e

# Calculate horizontal means conditioned on vertical velocity and time average
# and plot

writeuvw u

#for type in w convection; do
for type in w ; do
    # Calculate horizontal means conditioned on vertical velocity
    for time in 1????? 200000; do
        # Create cell sets "rising" and "falling" dependent on w
        rm -rf constant/polyMesh/sets
        topoSet -dict system/conditionalSamplingDict$type -time $time

        # Redefine sigma based on type
        setFields -dict system/conditionalSamplingDict$type -noFunctionObjects -time $time

        # Horizontal mean based on new sigma
        horizontalMean -time $time

        # Write out mean plus/minus one standard deviation of P, b and w
        for var in b uz P; do for fluid in none sigma.stable sigma.buoyant; do
            awk '{print $1, $2, $3, $4, $4-$5, $4+$5, $6, $7}' \
                $time/horizontalMean_${fluid}_${var}.dat \
                | sponge $time/horizontalMean_${fluid}_${var}.dat
        done; done

        # Calculate dpdz
        for part in stable buoyant; do
            echo '#level dPdz' > $time/horizontalMean_dPdz.${part}.dat
            sed -e "1d" $time/horizontalMean_sigma.${part}_P.dat | \
                awk 'BEGIN { z0=0; P0=0 }
                     { print 0.5*($1+z0), ($4-P0)/($1-z0); P0=$4; z0=$1}' \
                >> $time/horizontalMean_dPdz.${part}.dat
        done
    done

    # Calculate average over time
    rm -f timeMean_$type/*
    mkdir -p timeMean_$type
    cols=(2 2 4 4 4 4 4 4 4 4 4 4 4)
    i=0
    for field in dPdz.buoyant dPdz.stable \
           none_P sigma.buoyant_P sigma.stable_P \
           none_b sigma.buoyant_b sigma.stable_b \
           none_uz sigma.buoyant_uz sigma.stable_uz \
           none_sigma.buoyant none_sigma.stable; do
        col=${cols[$i]}
        let i=$i+1
        
        times=(1????? 200000)
        awk '{print $1, $'$col'}' ${times[0]}/horizontalMean_$field.dat \
            > timeMean_$type/$field.dat

        # Loop over time
        it=1
        while [ "$it" != ${#times[*]} ]; do
            time=${times[$it]}
            let it=$it+1
            let c=$col+2
            paste timeMean_$type/$field.dat $time/horizontalMean_$field.dat | \
                 awk '{print $1, $2+$'$c'}' \
                    | sponge timeMean_$type/$field.dat
        done
        # Take time average
        awk '{print $1, $2/'${#times[*]}'}' timeMean_$type/$field.dat \
            | sponge timeMean_$type/$field.dat
    done

    # plots
    time=timeMean_$type
    for var in b u sigma dPdz; do
        sed 's/TYPE/'$type'/g' plots/$var.gmt > plots/tmp.gmt; \
        gmtPlot plots/tmp.gmt
    done
    for file in $time/*eps; do
        eps2png $file
    done
    montage $time/sigmaMean.png  $time/bMean.png $time/wMean.png \
            $time/dPdzMean.png -tile 4x1 -geometry +0+0 $time/results.png
    eog -w $time/results.png &
done

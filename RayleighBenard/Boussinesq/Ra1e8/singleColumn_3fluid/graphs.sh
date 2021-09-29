#!/bin/bash -e

if [ "$#" -ne 1 ]
then
   echo usage: graphs.sh time
   exit
fi

time=$1

echo Summing pressure in each fluid
#########################################
for part in stable up down; do
    sumFields $time P.$part $time P $time p.$part  > /dev/null
done

#echo Calculating Nusselt number v height
##########################################
#alpha=3.1622776602
#dBdZ=7.07e-8
#scale=$(echo '' | awk '{print 1/'$alpha'/'$dBdZ'}')
#for part in stable up down; do
#    writeuvw -time $time u.$part  > /dev/null
#    multiplyFields $time wb.$part $time u.${part}z $time b.$part  > /dev/null
#    postProcess -time $time -func 'grad('b.$part')'  > /dev/null
#    mv $time/grad\(b.${part}\) $time/gradb.$part
#    writeuvw -time $time gradb.$part  > /dev/null
#    sed -i 's/\[0 0 -2 0 0 0 0\]/\[0 2 -3 0 0 0 0\]/g' $time/gradb.${part}z
#    sumFields $time Nusselt.$part $time wb.$part $time gradb.${part}z -scale1 -$alpha  > /dev/null
#    #Multiply by sigma
#    multiplyFields $time sigmaNusselt.$part $time sigma.$part $time Nusselt.$part -scale1 $scale  > /dev/null
#    sed -i 's/\[0 2 -3 0 0 0 0\]/\[0 0 0 0 0 0 0\]/g' $time/sigmaNusselt.$part
#done
#sumFields $time Nusselt $time sigmaNusselt.stable $time sigmaNusselt.up > /dev/null
#sumFields $time Nusselt $time Nusselt $time sigmaNusselt.down > /dev/null

echo Writing out xyz data
for var in b u P sigma massTransfer.stable massTransfer.up massTransfer.down; do
    for part in '' .stable .up .down; do
        if [ -a $time/${var}${part} ]; then
            writeCellDataxyz -time $time ${var}${part} > /dev/null
            sort -g -k 3 $time/${var}${part}.xyz \
                | sponge $time/${var}${part}.xyz
        fi
    done
done
#writeCellDataxyz -time $time Nusselt  > /dev/null
#sort -g -k 3 $time/Nusselt.xyz | sponge $time/Nusselt.xyz

# Create plots
sed 's/TIME/'$time'/g' gmtFiles/b.gmt > gmtFiles/tmp.gmt; \
    gmtPlot gmtFiles/tmp.gmt
sed 's/TIME/'$time'/g' gmtFiles/w.gmt > gmtFiles/tmp.gmt; \
    gmtPlot gmtFiles/tmp.gmt
sed 's/TIME/'$time'/g' gmtFiles/P.gmt > gmtFiles/tmp.gmt; \
    gmtPlot gmtFiles/tmp.gmt
sed 's/TIME/'$time'/g' gmtFiles/sigma.gmt > gmtFiles/tmp.gmt; \
    gmtPlot gmtFiles/tmp.gmt
sed 's/TIME/'$time'/g' gmtFiles/massTransfer.gmt > gmtFiles/tmp.gmt; \
    gmtPlot gmtFiles/tmp.gmt
rm gmtFiles/tmp.gmt

#montage -scale 100% -mode concatenate -tile 5x1 \
#    $time/sigma.eps $time/b.eps $time/w.eps $time/P.eps  $time/massTransfer.eps\
#    $time/results.png
#display $time/results.png &
ln -sf ../gmtFiles/results.lyx $time/results.lyx
lyx --export pdf $time/results.lyx 1> /dev/null
pdfCrop $time/results.pdf
ev $time/results.pdf


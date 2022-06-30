#!/bin/bash -e

if [ "$#" -ne 3 ]
then
   echo usage: scatter.sh case time 'partNames'
   exit
fi

case=$1
time=$2
parts=($3)
nparts=${#parts[*]}

for var in b u; do
    for part in ${parts[*]}; do
        writeCellDataxyz -case $case -time $time ${var}.${part}
    done
    cat $case/$time/${var}.*.xyz > $case/$time/$var.xyz
    rm $case/$time/${var}.*.xyz
done

#for var in b w; do
#    sed 's%TIME%'$case/$time'%g' $case/gmtFiles/${var}Scatter.gmt \
#        > $case/gmtFiles/tmp.gmt;  gmtPlot $case/gmtFiles/tmp.gmt
#done

# Plot w against z and colour by b
outFile=$case/$time/bw.eps
paste -d'   ' $case/$time/b.xyz $case/$time/u.xyz > $case/$time/bu.xyz
echo "#w(m/s)   z(m)   b(m/s^2" > $case/$time/bw.xyz
awk 'NR!=1 {print $10, $3, $4, $4**2}' $case/$time/bu.xyz \
    | sort -g -k4 | awk '{print $1, $2, $3}' >> $case/$time/bw.xyz

gmt makecpt -C$GMTU/colours/red_grey_blue.cpt -D -T-0.5/0.5/0.1 > colourScale.cpt
gmt set MAP_FRAME_AXES WeSn
gmt psbasemap -JX6c/10c -R-0.75/0.75/0/1\
          -Ba0.5g10f0.5:"w (m/s)":/a0.2f0.2 -K > $outFile
gmt psxy -J -R -A -h1 -Sc3p -O -K \
    -CcolourScale.cpt $case/$time/bw.xyz  >>$outFile

# Colorbar
gmt psscale -CcolourScale.cpt -S -K -O  -D6.3c/5c/10c/0.5c  >> $outFile
echo "" | gmt psxy -J -R -W -O >>$outFile

ps2eps -f $outFile > /dev/null 2>&1
\mv $outFile.eps $outFile

# Plot b against z and colour by w
outFile=$case/$time/wb.eps
gmt makecpt -C$GMTU/colours/red_grey_blue.cpt -D -T-0.5/0.5/0.1 > colourScale.cpt
gmt set MAP_FRAME_AXES WeSn
gmt psbasemap -JX6c/10c -R-0.5/0.5/0/1\
          -Ba0.2g1f0.2:"b (m s@+-2@+)":/a0.2f0.2 -K > $outFile
awk '{print $3, $2, $1}' $case/$time/bw.xyz  | \
    gmt psxy -J -R -A -h1 -Sc2p -O -K \
        -CcolourScale.cpt   >>$outFile

# Colorbar
gmt psscale -CcolourScale.cpt -S -K -O  -D6.3c/5c/10c/0.5c  >> $outFile
echo "" | gmt psxy -J -R -W -O >>$outFile

ps2eps -f $outFile > /dev/null 2>&1
\mv $outFile.eps $outFile

# Combine results
ln -sf ../gmtFiles/scatterResults.lyx $case/$time/scatterResults.lyx
lyx --export pdf $case/$time/scatterResults.lyx 1> /dev/null
pdfCrop $case/$time/scatterResults.pdf
ev $case/$time/scatterResults.pdf

rm $case/$time/*.xyz

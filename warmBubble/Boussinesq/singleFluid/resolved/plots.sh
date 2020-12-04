#gmtFoam bP
mkdir -p animategraphics
i=0
t=0
dt=100
var=bContour
gmtFoam bContour
while [ "$t" -le 2000 ]; do
    convert $t/$var.pdf $t/$var.png
    ln -sf ../$t/${var}.png animategraphics/${var}_$i.png
    let t=$t+$dt
    let i=$i+1
done

i=0
t=0
dt=100
while [ "$t" -le 1000 ]; do
    montage -density 200% $t/bContour.pdf"[120%]" hMean/$t/b.eps"[180%]" \
           -tile 2x1 -geometry +0+0 animategraphics/b_hMean_$i.png
    let t=$t+$dt
    let i=$i+1
done


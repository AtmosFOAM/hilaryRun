#gmtFoam bP
mkdir -p animategraphics
i=0
t=0
dt=100
var=b
while [ "$t" -le 2000 ]; do
    convert $t/$var.pdf $t/$var.png
    ln -sf ../$t/${var}.png animategraphics/${var}_$i.png
    let t=$t+$dt
    let i=$i+1
done

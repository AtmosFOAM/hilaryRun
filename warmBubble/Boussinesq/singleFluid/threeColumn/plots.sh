var=b
gmtFoam $var
mkdir -p animategraphics
i=0
t=0
dt=100
while [ "$t" -le 2000 ]; do
    ln -sf ../$t/${var}.pdf animategraphics/${var}_$i.pdf
    let t=$t+$dt
    let i=$i+1
done
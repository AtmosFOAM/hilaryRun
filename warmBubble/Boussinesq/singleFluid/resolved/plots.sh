#gmtFoam bP
mkdir -p animategraphics
i=0
t=0
dt=100
while [ "$t" -le 2000 ]; do
    ln -sf ../$t/bP.pdf animategraphics/bP_$i.pdf
    let t=$t+$dt
    let i=$i+1
done

file=bw


#gmtFoam $file
mkdir -p animategraphics
i=0
t=0
dt=1000
while [ "$t" -le 200000 ]; do
    ln -sf ../$t/$file.pdf animategraphics/${file}_$i.pdf
    let t=$t+$dt
    let i=$i+1
done

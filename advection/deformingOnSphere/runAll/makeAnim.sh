postProcess -func CourantNoU
cp 5/Co 0
gmtFoam T

mkdir anims

i=0
for time in 0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5; do
    echo $i
    eps2png $time/T.pdf
    mv $time/T.png anims/T$i.png
    let i=$i+1
done

convert -scale 200% -delay 20 anims/T?.png anims/T10.png anims/T10.png T.mp4


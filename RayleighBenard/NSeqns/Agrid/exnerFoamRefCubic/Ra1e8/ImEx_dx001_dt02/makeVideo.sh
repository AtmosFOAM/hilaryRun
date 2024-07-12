#postProcess -func CourantNoU
#gmtFoam bc

getFileTypes.sh sws02hs@arc-vm-132.rdg.ac.uk:/home/sws02hs/OpenFOAM/sws02hs-11/run/RayleighBenard/NSeqns/Agrid/exnerFoamRefCubic/Ra1e8/ImEx_dx001_dt02 pdf

eps2gif bc0.webm 0/bc.pdf ??/bc.pdf
for n in 1 2 3 4 5 6 7 8; do eps2gif bc$n.webm $n??/bc.pdf; done
eps2gif bc9.webm 9??/bc.pdf 1000/bc.pdf

ffmpeg -f concat -safe 0 -i files.txt -c copy bc.webm

totem bc.webm
rm bc?.webm

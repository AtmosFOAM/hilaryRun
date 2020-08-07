#!/bin/bash -e

rm -rf constant/polyMesh [0-9]*

blockMesh
mkdir -p 0
cp init_0/* 0

implicitExplicitAdvectionFoam


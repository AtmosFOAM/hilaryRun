# Functions used to calculate the temperature profile based on 
# Eddy diffusivity

import numpy as np

def zStar(z, T):
    "BL depth defined to be point of maximum dT/dz"
    dTdzMax = 0
    zS = 0
    for iz in range(len(z)-1):
        dTdz = (T[iz+1] - T[iz])/(z[iz+1] - z[iz])
        if dTdz > dTdzMax:
            zS = 0.5*(z[iz+1] + z[iz])
            dTdzMax = dTdz
    
    return zS

def wStar(g, zS, Qs, theta00):
    " Convective vertical velocity scale"
    return (g*zS*Qs/theta00)**(1./3.)

def K(zTilde, zS, wS):
    "Eddy diffusivity"
    vonKarman = 0.4
    return zS*wS*vonKarman*(39*vonKarman*zTilde)**(1./3)\
           *zTilde*(1-zTilde)**2

def zTilde(z, z0, zS):
    "Height normalised by BL depth and surface roughness"
    return np.where((z+z0)/(zS + z0) < 1, (z+z0)/(zS + z0), 1)


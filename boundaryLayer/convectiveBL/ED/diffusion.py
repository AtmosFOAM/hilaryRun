# Simulation of an Eddy Diffusive Boundary layer following SST07 and TEB19

import numpy as np
import matplotlib.pyplot as plt
import EDfunctions as ED
from diffusionSchemes import BTCS_fixedGrad

def main():

    # Grid and time
    zmin = 0.
    zmax = 2400.
    nz = 121
    nt = 3600
    dt = 6.
    
    # Derived parameters for the grid and half levels
    dz = (zmax - zmin)/(nz-1)
    z = np.linspace(zmin, zmax, nz)
    zH = np.linspace(zmin+0.5*dz, zmax-0.5*dz, nz-1)

    # Setup
    z0 = 0.1
    Qstar = 0.06
    theta00 = 300
    g = 9.8
    
    # Initial conditions
    T00 = 297.2
    lapseRate = 1.95e-3
    
    # Parameters in the solution
    # BL depth per time step
    zStar = np.zeros(nt+1)
    # Convective vertical velocity scale
    wStar = np.zeros(nt+1)
    # Normalised height at full and half levels
    zTildeH = ED.zTilde(zH, z0, zStar[0])

    # Initial theta and K profiles
    theta0 = T00 + lapseRate*z
    theta = theta0.copy()
    # Eddy diffusivity
    K = ED.K(zTildeH, zStar[0], wStar[0])
    
    # Time stepping
    for it in range(nt):
        zStar[it+1] = ED.zStar(z, theta)
        wStar[it+1] = ED.wStar(g, zStar[it+1], Qstar, theta00)
        zTildeH = ED.zTilde(zH, z0, zStar[it+1])
        K = ED.K(zTildeH, zStar[it+1], wStar[it+1])

        # Boundary Conditions
        BCgradients = [0, 0]
        if K[0] > 0:
            BCgradients[0] = Qstar*dz/K[0]
        #print('Time ', it*dt, ' Bottom BC is ', BCgradients[0])
        #print('zStar = ', zStar[it+1], ' K[0] = ', K[0], 'wStar = ', wStar[it+1])

        theta = BTCS_fixedGrad(theta, K*dt/dz**2, BCgradients)

    # Plot the solutions
    font = {'size'   : 20}
    plt.rc('font', **font)
    plt.figure(1)
    plt.clf()
    plt.ion()
    plt.plot(theta0, z*1e-3, label='Initial', color='black')
    plt.plot(theta, z*1e-3, label='Final', color='blue')
    plt.ylim([zmin*1e-3,zmax*1e-3])
    plt.legend(bbox_to_anchor=(1.1, 1))
    plt.xlabel(r'$\theta$ (K)')
    plt.ylabel(r'$z$ (km)')
    plt.tight_layout()
    plt.savefig('plots/theta.pdf')

    # Plot growth of the boundary layer
    plt.clf()
    t = np.linspace(0, nt*dt/3600, nt+1)
    plt.plot(t, zStar*1e-3)
    plt.xlabel(r'Time (hours)')
    plt.ylabel(r'Boundary layer depth (km)')
    plt.tight_layout()
    plt.savefig('plots/BLdepth.pdf')

    # Plot final K profile
    plt.clf()
    plt.plot(K, zH*1e-3)
    plt.ylabel(r'$K$ (m$^2$s$^{-1}$)')
    plt.xlabel(r'$z$ (km)')
    plt.tight_layout()
    plt.savefig('plots/K.pdf')

main()


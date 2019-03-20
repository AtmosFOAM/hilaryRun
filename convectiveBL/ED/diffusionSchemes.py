# Numerical schemes for simulating diffusion for outer code diffusion.py

import numpy as np

# The linear algebra package for BTCS (for solving the matrix equation)
import numpy.linalg as la

def BTCS_fixedGrad(phi, d, BCgradients):
    "Diffusion of profile in phi using BTCS using"
    "diffusion coefficient, d assuming fixed gradient boundary conditions"
    "BCgradients[0] and BCgradients[1]"
    "for 1 time step"
    
    nx = len(phi)

    # array representing BTCS
    M = np.zeros([nx,nx])
    # Fixed gradient boundary conditions
    M[0,0] = 1.
    M[0,1] = -1.
    M[-1,-1] = 1.
    M[-1,-2] = -1.
    for i in range(1,nx-1):
        M[i,i-1] = -d[i-1]
        M[i,i] = 1+d[i-1]+d[i]
        M[i,i+1] = -d[i]

    # BTCS for one time step
    # RHS for gradient boundary conditions
    phi[0] = BCgradients[0]
    phi[-1] = BCgradients[1]

    phi = la.solve(M,phi)

    return phi


import numpy as np
R = 15
dz0 = 3
S = 3000
r = 1 - dz0*(1 - R)/S
n = np.log(R)/np.log(r)
print('r = ', r, ' n = ', n)

S2 = 1200
R2 = 1 - S2*(1-r)/dz0
n2 = np.log(R2)/np.log(r)
print('R2 = ', R2, ' n2 = ', n2, ' dz2 = ', dz0*R2)


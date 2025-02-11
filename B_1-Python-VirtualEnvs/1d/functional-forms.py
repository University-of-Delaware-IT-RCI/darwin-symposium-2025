import numpy as np
import matplotlib.pyplot as plt
import csv
from scipy.optimize import curve_fit

# Read training data from Gaussian runs:
with open('data.csv', 'r') as fptr:
    fptr_reader = csv.reader(fptr)
    A = [[float(v[0]), float(v[1])] for v in fptr_reader]

x_train, y_train = np.array(A, dtype=np.float64).T


def N2N2_LJ(r, epsilon, sigma):
    # 4ε [ (σ/r)^12 - (σ/r)^6 ]
    v = (sigma / r)**6
    return 4.0 * epsilon * (v * (v - 1))

def N2N2_Buckingham(r, A, B, C):
    # A Exp[-Br] - C/r^6
    return A * np.exp(-B * r) - C * pow(r, -6.0)

def N2N2_BuckinghamPlusCoulomb(r, A, B, C, D):
    # A Exp[-Br] - C/r^6 + D^2/r
    return A * np.exp(-B * r) - C * pow(r, -6.0) + \
                    (D / r)

def D2_N2N2_LJ(r, epsilon, sigma):
    # d/dp{ 4ε [ (σ/r)^12 - (σ/r)^6 ] }
    #  0: 4[(σ/r)^12 - (σ/r)^6]
    #  1: 4ε [ (12/r)(σ/r)^11 - (6/r)(σ/r)^5 ]
    v = (sigma / r)
    w = v**5
    v = w * v
    u = (6.0 / r)
    return np.array([
            4.0 * (v * (v - 1)),
            4.0 * epsilon * u * (2.0 * w * v - w)
       ]).T

def D2_N2N2_Buckingham(r, A, B, C):
    # d/dp{ A Exp[-Br] - C/r^6 }
    #  0: Exp[-Br]
    #  1: (-Ar)Exp[-Br]
    #  2: -1/r^6
    return np.array([
            np.exp(-B * r),
            (-A * r) * np.exp(-B * r),
            -pow(r, -6.0)
       ]).T

def D2_N2N2_BuckinghamPlusCoulomb(r, A, B, C, D):
    # d/dp{ A Exp[-Br] - C/r^6 + D/r }
    # 0: Exp[-Br]
    # 1: (-Ar)Exp[-Br]
    # 2: -1/r^6
    # 3: 1/r
    return np.array([
            np.exp(-B * r),
            (-A * r) * np.exp(-B * r),
            -pow(r, -6.0),
            pow(r, -1.0)
       ]).T

# Lennard-Jones
popt, pcov, info, info_msg, info_ier = curve_fit(N2N2_LJ,
                x_train, y_train, jac=D2_N2N2_LJ,
                p0=[1000.0, 3.5], full_output=True,
                ftol=0.0001)
rmse = np.sqrt(np.mean((y_train - N2N2_LJ(x_train, *popt))**2))
print(f'Lennard-Jones          popt = [{popt}], rmse = {rmse}')

# Buckingham
popt, pcov, info, info_msg, info_ier = curve_fit(
                N2N2_Buckingham, x_train, y_train,
                jac=D2_N2N2_Buckingham, p0=[1000.0, 1.0, 3.5],
                full_output=True, ftol=0.0001)
rmse = np.sqrt(np.mean((y_train - 
                N2N2_Buckingham(x_train, *popt))**2))
print(f'Buckingham             popt = [{popt}], rmse = {rmse}')

# Buckingham + Coulomb
popt, pcov, info, info_msg, info_ier = curve_fit(
                N2N2_BuckinghamPlusCoulomb, x_train, y_train,
                jac=D2_N2N2_BuckinghamPlusCoulomb,
                p0=[1000.0,  1.0, 3.5,  0.1], full_output=True,
                ftol=0.0001)
rmse = np.sqrt(np.mean((y_train - 
              N2N2_BuckinghamPlusCoulomb(x_train, *popt))**2))
print(f'Buckingham+Coulomb     popt = [{popt}], rmse = {rmse}')

# Nice smooth series of points in the data range:
x_range = np.arange(0.3, 8.0, 0.025, dtype=np.float64)

# Clear the plotting canvas:
plt.clf()

# Plot the fitted function:
plt.plot(x_range, [N2N2_BuckinghamPlusCoulomb(x, *popt) for x in x_range], color='r')

# Plot the training data:
plt.scatter(x_train, y_train, color='g')

# Add axis labels and a title:
plt.xlabel('r/Å')
plt.ylabel('Eint/kcal•mol^-1')
plt.title('N2-N2 interaction potential')

# Save the figure to a PNG file:
plt.savefig('buckingham_coulomb.png')


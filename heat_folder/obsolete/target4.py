import numpy as np
import matplotlib.pyplot as plt

radius = 0.03
area = np.pi * radius ** 2
area_base = area
area_tar = area
area_cool = area

# length in direction of heat travel [cm]
len_base = 0.01
len_tar = 0.0003
len_cool = 0.01

# thermal conductivity (estimate 20C) [W/cm.C]
k_base = 398.0
k_tar = 71.0
k_cool = 0.6

# specific heat capacity [J/g.C]
c_base = 0.385
c_tar = 3.58
c_cool = 4.2

# mass [g]
m_base = 8.96E+6 * len_base * area # = 253
m_tar = 0.534E+6 * len_tar * area # = 0.453
m_cool = 1E+6 * len_cool * area # = 59.4

# mc coefficients
mc_base = m_base * c_base # = 97.4
mc_tar = m_tar * c_tar    # = 1.62
mc_cool = m_cool * c_cool # = 249.5

# initial temp [C]
T_room = 20.0
T_0 = T_room
T_base = T_room
T_tar = T_room
T_cool = T_room


h_base = 2435.8
h_tar = 15243.0
h_cool = 0.05756

# calculate conductance
alpha = k_base*area_base/len_base  # alpha = 1.1E6 W/K
beta = k_tar * area_tar / len_tar   # beta = 6.7E6 W/K
gamma = k_cool*area_cool/len_cool  # gamma = 3.4E3 W/K


def func(time, temp):
    x = temp[0]
    y = temp[1]
    z = temp[2]
    f = np.empty(3)
    f[0] = (h_tar - beta * (x - y)) / mc_tar
    f[1] = (h_base + beta * (x - y) - alpha * (y - z)) / mc_base
    f[2] = (h_cool + alpha * (y - z) - gamma * (z - T_0)) / mc_cool

    return f
  

def rk4(time, temp, h):

    k1 = h * func( time, temp )
    k2 = h * func( time + 0.5 * h ,  temp + 0.5 * k1 )
    k3 = h * func( time + 0.5 * h ,  temp + 0.5 * k2 )
    k4 = h * func( time + h ,  temp + k3 )

    rk4 = ( k1 + (2 * k2) + (2 * k3) + k4 ) / 6

    return rk4
  
def calculate(max, h):
    time = [i * h for i in range(max)]
    x = T_tar
    y = T_base
    z = T_cool
    temp = np.array([T_tar, T_base, T_cool])
    print("x   y   z")
    for i in range(max):

      x = temp[0]
      y = temp[1]
      z = temp[2]
      temp = temp + rk4(time[i], temp, h) 
      print(f"{x} {y} {z}" )


def euler(max, h):
    """"""
    time = [i * h for i in range(max)]
    temp = np.array([T_tar, T_base, T_cool])
    print(f"time   temp[0]   temp[1]   temp[2]")
    for i in range(max):
        f = func(time[i], temp)
        temp[0] = temp[0] + h * f[0]
        temp[1] = temp[1] + h * f[1]
        temp[2] = temp[2] + h * f[2]
        print(f"{time[i]:3.3f} {temp[0]:.2e} {temp[1]:.2e} {temp[2]:.2e}")


def dxdt(t, x, y, z):
    xdot = ( h_tar - beta * (x - y) ) / mc_tar
    return xdot


def dydt(t, x, y, z):
    ydot = ( h_base + beta * (x - y) - alpha * (y - z) ) / mc_base
    return ydot


def dzdt(t, x, y, z):
    zdot = ( h_cool + alpha * (y - z) - gamma * (z- T_0) ) / mc_cool
    return zdot


def rkc(t, x, y, z, dt, dxdt, dydt, dzdt):
    """k1 = dt * dxdt(t, x, y, z)
       k2 = dt * dxdt(t + 0.5 * dt, x + 0.5 * k1, y + 0.5 * h1, z + 0.5 * m1)
       k3 = dt * dxdt(t + 0.5 * dt, x + 0.5 * k2, y + 0.5 * h2, z + 0.5 * m2)
       k4 = dt * dxdt(t + dt, x + k3, y + h3, z + m3)"""
    k1 = dt * dxdt(t, x, y, z)
    h1 = dt * dydt(t, x, y, z)
    m1 = dt * dzdt(t, x, y, z)

    k2 = dt * dxdt(t + 0.5 * dt, x + 0.5 * k1, y + 0.5 * h1, z + 0.5 * m1)
    h2 = dt * dydt(t + 0.5 * dt, x + 0.5 * k1, y + 0.5 * h1, z + 0.5 * m1)
    m2 = dt * dzdt(t + 0.5 * dt, x + 0.5 * k1, y + 0.5 * h1, z + 0.5 * m1)

    k3 = dt * dxdt(t + 0.5 * dt, x + 0.5 * k2, y + 0.5 * h2, z + 0.5 * m2)
    h3 = dt * dydt(t + 0.5 * dt, x + 0.5 * k2, y + 0.5 * h2, z + 0.5 * m2)
    m3 = dt * dzdt(t + 0.5 * dt, x + 0.5 * k2, y + 0.5 * h2, z + 0.5 * m2)

    k4 = dt * dxdt(t + dt, x + k3, y + h3, z + m3)
    h4 = dt * dydt(t + dt, x + k3, y + h3, z + m3)
    m4 = dt * dzdt(t + dt, x + k3, y + h3, z + m3)

    x = x + (k1 + 2 * k2 + 2 * k3 + k4) / 6
    y = y + (h1 + 2 * h2 + 2 * h3 + h4) / 6
    z = z + (m1 + 2 * m2 + 2 * m3 + m4) / 6
    t = t + dt

    return t, x, y, z


def calculate(t_max, dt, x0, y0, z0, t0=0):
    """performs rk and appends to list of values"""
    tlist = [t0]
    xlist = [x0]
    ylist = [y0]
    zlist = [z0]
    t = t0
    x = x0
    y = y0
    z = z0

    while t <= t_max:
        
        t, x, y, z = rkc(t, x, y, z, dt, dxdt, dydt, dzdt)

        tlist.append(t)
        xlist.append(x)
        ylist.append(y)
        zlist.append(z)
    return tlist, xlist, ylist, zlist


def plotter(t_max, dt, x0, y0, z0, t0=0):
    """"""
    tlist, xlist, ylist, zlist = calculate(t_max, dt, x0, y0, z0, t0)
    plt.xlabel("time")
    plt.ylabel("temperature, C")
    plt.title("Temperature vs time")
    plt.scatter(tlist, xlist, label='Target', c="r")
    plt.scatter(tlist, ylist, label='Base', c='orange')
    plt.scatter(tlist, zlist, label='Coolant', c='blue')
    plt.show()


t_max = 10
dt = 0.0001
x0 = y0 = z0 = 20.0
# plotter(t_max, dt, x0, y0, z0)


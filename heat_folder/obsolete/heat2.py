'''2D Heat Equation Solver
https://levelup.gitconnected.com/solving-2d-heat-equation-numerically-using-python-3334004aa01a'''

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from matplotlib.animation import FuncAnimation

# lengths in 100 microns
x_length = 30
y_length = 600
max_frames = 750

# calculated using lithium shc at constant p, therm conductivity and density
alpha = 0.4455
delta_x = 1

delta_t = (delta_x ** 2)/(4 * alpha)
gamma = (alpha * delta_t) / (delta_x ** 2)

# initialises u, the temperature with respect to time and space matrix
u = np.empty(shape=(max_frames, x_length, y_length))

initial = 0.0  # setting to zero inside the plate
u.fill(initial)

# boundary conditions
u_top = 0.0
u_left = 2500.0
u_bottom = 0.0
u_right = 0.0

# Set the boundary conditions
u[:, (x_length-1):, :] = u_top
u[:, :, :1] = u_left
u[:, :1, 1:] = u_bottom
u[:, :, (y_length-1):] = u_right

def calculate(u):
    for k in range(0, max_frames-1, 1):
        for i in range(1, x_length-1, delta_x):
            for j in range(1, y_length-1, delta_x):
                u[k + 1, i, j] = gamma * (u[k][i+1][j] + u[k][i-1][j] +
                                          u[k][i][j+1] + u[k][i][j-1] - 
                                          4*u[k][i][j]) + u[k][i][j]

    return u

def plotheatmap(u_k, k):
    # Clear the current plot figure
    plt.clf()

    plt.title(f"Temperature at t = {k*delta_t:.3f} unit time")
    plt.xlabel("x")
    plt.ylabel("y")

    # This is to plot u_k (u at time-step k)
    plt.pcolormesh(u_k, cmap=plt.cm.jet, vmin=0, vmax=100)
    plt.colorbar()

    return plt

# Do the calculation here
u = calculate(u)

def animate(k):
    plotheatmap(u[k], k)

anim = animation.FuncAnimation(plt.figure(), animate, interval=10,
                               frames=max_frames, repeat=False)
anim.save("heat_equation_solution.gif")


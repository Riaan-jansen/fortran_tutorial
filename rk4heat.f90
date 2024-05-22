! a runge-kutta
! original for reference : https://cyber.dabamos.de/programming/modernfortran/gnuplot.html

program main
    implicit none
    external errorbar
    ! constants for the equations
    real, parameter :: A = 0.15000
    real, parameter :: B = 0.02500
    real, parameter :: C = 0.0005756
    real, parameter :: T_0 = 18.0

    real, parameter :: alpha = 1.1E+2
    real, parameter :: beta = 6.7E+2
    real, parameter :: gamma = 3.4E1
    ! step sizing
    real, parameter :: T_max = 10.0
    real, parameter :: H = 0.1
    integer, parameter :: N = T_max / H
    integer, parameter :: NDIM = 3
    integer :: i
    real, dimension(NDIM) :: r
    real, dimension(N) :: t, x, y, z, xerr, yerr

    t = [(H * i, i = 1, N)]

    ! initial values for f1 and f2
    r = [20.0, 21.0, 20.0]

    do i = 1, N
        x(i) = r(1)
        y(i) = r(2)
        z(i) = r(3)
        r = r + rk(t(i), r, H)
    end do


    print *, "sometest"
    do i = 1, N
        print '(4(es15.8, 2x))', t(i), x(i), y(i), z(i)
    end do

contains
    pure function f(t, r)
        ! ODE to solve
        real, intent(in) :: r(NDIM), t
        real :: f(NDIM), u, v, w

        u = r(1)
        v = r(2)
        !w = r(3)

        ! two coupled ODEs
        f(1) = A - beta * (u - v)
        f(2) = B + beta * (u - v) - alpha * (v - w)
        f(3) = C + alpha * (v - w) - gamma * (w - T_0)
    end function f

    pure function rk(t, r, h)
        real, intent(in) :: r(NDIM), t, h
        real :: rk(NDIM)
        real, dimension(NDIM) :: k1, k2, k3, k4

        k1 = h * f(t, r)
        k2 = h * f(t + 0.5 * h, r + 0.5 * k1)
        k3 = h * f(t + 0.5 * h, r + 0.5 * k2)
        k4 = h * f(t + h, r + k3)

        rk = (k1 + (2 * k2) + (2 * k3) + k4) / 6
    end function rk
end program main

! a runge-kutta

subroutine error(x, y, N)
    integer, intent(in) :: N
    real, intent(in) :: x(N), y(N)
    real, intent(out) :: xerr(N), yerr(N)


    

program main
    implicit none
    external error
    ! rates of change for the equations
    real, parameter :: A = 0.470
    real, parameter :: B = 0.024
    real, parameter :: D = 0.023
    real, parameter :: G = 0.760
    ! step sizing
    real, parameter :: T_max = 50.0
    real, parameter :: H = 0.01
    integer, parameter :: N = T_max / H

    integer :: i
    real, dimension(2) :: r
    real, dimension(N) :: t, x, y

    t = [(H * i, i = 1, N)]

    r = [20.0, 5.0]

    do i = 1, N
        x(i) = r(1)
        y(i) = r(2)

        r = r + rk(t(i), r, H)
        print '(3(f15.8))', t(i), x(i), y(i)

    end do

contains
    pure function f(t, r)
        ! ODE to solve
        real, intent(in) :: r(2), t
        real :: f(2), u, v

        u = r(1)
        v = r(2)

        ! two coupled ODEs
        f(1) = u * (A - B * v)
        f(2) = -v * (G - D * u)
    end function f

    pure function rk(t, r, h)
        real, intent(in) :: r(2), t, h
        real :: rk(2)
        real, dimension(2) :: k1, k2, k3, k4

        k1 = h * f(t, r)
        k2 = h * f(t + 0.5 * h, r + 0.5 * k1)
        k3 = h * f(t + 0.5 * h, r + 0.5 * k2)
        k4 = h * f(t + h, r + k3)

        rk = (k1 + (2 * k2) + (2 * k3) + k4) / 6
    end function rk
end program main

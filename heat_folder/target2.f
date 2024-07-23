c program to calculate temperature over time in fets target
c runge-kutta fourth order and euler first order methods used
c prints outcome of both 
      module variables
      ! constants relating to target geometry and material
        implicit none

        double precision, parameter :: pi = 3.1415927

        ! cross sectional area of shared surface between plates [m2]
        double precision, parameter :: radius = 0.03
        double precision, parameter :: area = pi * radius ** 2
        double precision, parameter :: area_base = area
        double precision, parameter :: area_tar = area
        double precision, parameter :: area_cool = area

        ! length in direction of heat travel [m]
        double precision, parameter :: len_base = 0.01
        double precision, parameter :: len_tar = 3D-04
        double precision, parameter :: len_cool = 0.01

        ! thermal conductivity (estimated @ 20C) [W/m.C]
        double precision, parameter :: k_base = 398.0
        double precision, parameter :: k_tar = 71.2
        double precision, parameter :: k_cool = 0.598

        ! specific heat capacity [J/g.C]
        double precision, parameter :: c_base = 0.385
        double precision, parameter :: c_tar = 3.49
        double precision, parameter :: c_cool = 4.2

        ! mass [g], density [g/m3] * volume [m3]
        double precision, parameter :: m_base = 8.96D6 * len_base * area ! = 2.5E4
        double precision, parameter :: m_tar = 5.34D5 * len_tar * area ! = 0.453
        double precision, parameter :: m_cool = 1D6 * len_cool * area ! = 

        ! mc coefficients
        double precision, parameter :: mc_base = m_base * c_base ! = 97.4
        double precision, parameter :: mc_tar = m_tar * c_tar    ! = 1.62
        double precision, parameter :: mc_cool = m_cool * c_cool ! = 249.5

        ! initial temp [C] units here shouldnt matter should just be the difference calculated?
        double precision, parameter :: T_room = 20.0 ! setting everything to room temp
        double precision, parameter :: T_0 = 20.0
        double precision, parameter :: T_base = t_room
        double precision, parameter :: T_tar = t_room
        double precision, parameter :: T_cool = t_room

        ! calculate conductance
        double precision, parameter :: alpha = k_base * area_base 
     &   / len_base  ! alpha = 112
        double precision, parameter :: beta = k_tar * area_tar 
     &   / len_tar  ! beta = 669
        double precision, parameter :: gamma = k_cool * area_cool 
     &   / len_cool * 1e6 ! gamma = 1.69E-3 * some value to flow

      end module variables

      program main
        use variables
        implicit none

        ! step sizing
        double precision, parameter :: h = 0.0001      ! step size
        double precision, parameter :: n_max = 120.0  ! time max
        integer, parameter :: n = int(n_max / h)      ! number of steps
        double precision, dimension(3) :: T

c 1002  format (4(A13,2x))

        ! T = [T_tar,T_base,T_cool]

        ! write (*,1002) "time (s)", "target (C)", "base  ", "coolant"
        ! print *, "--------------------------RK4----------------------"
        ! call calculate(n, h, T)
        ! print *, "---------------------EULER------------------------"

        T = [T_tar,T_base,T_cool]

        call euler(n, h, T)

        ! print *, "--------------------------END----------------------"

      contains
        function f(time, temp)
c ---------------------------------------------------------------------
c f is a function that takes two arguments and is of dimension(3)
c f takes the i-1 temp values and uses them as x, y, z in the ODEs
c which are represented as elements in the 3dim array f
c ---------------------------------------------------------------------
          double precision, dimension(3), intent(in) :: temp
          double precision, intent(in) :: time
          double precision, dimension(3) :: f
          double precision x, y, z

          ! heat values from fluka simulations
          double precision :: h_base
          double precision :: h_tar
          double precision :: h_cool

          integer i
          double precision rt
          ! should have effect of truncating the int part and then
          ! turning all into int
          rt = (time - int(time)) / h

          ! for 10% beam duty factor.
          if (mod(int(rt),10) .EQ. 0 ) then
          ! if (mod(int(time),10) .EQ. 0 ) then
            ! print *, "zero"
            h_base = 2435.8
            h_tar = 15243.0
            h_cool = 0.05756
          else
            ! print *, "nonzero"
            h_tar = 0.0
            h_base = 0.0
            h_cool = 0.0
          end if
c above bit of code might not work perfectly and the values from fluka
c could also be wrong, but commenting it out and using any non-zero 
c value (below) leads to similiar problem, so this cant be the issue
          ! h_base = 0.0
          ! h_tar = 0.0000001
          ! h_cool = 0.0

          ! requires declaration of f() - otherwise would have no type
          ! previous (i-1) temperature values to calculate f_i(T,t)
          ! where f is the first order derivative
          x = temp(1)
          y = temp(2)
          z = temp(3)
          do i = 1, 3
            f(i) = 0
          end do 

c equations follow form:
c ---------------------------------------------------------------------
c (dT/dt) = [ (dQ/dt) - conductance * (Temp difference heat loss) +
c             + conductance * (Temp difference heat gained) ] * 1/mc
c ---------------------------------------------------------------------
    !       f(1) = ( (h_tar - beta * (x - z)) / mc_tar )

    !       f(2) = ( (h_base + beta * (x - z) - alpha * (z - y))
    !  &           / mc_base)
    !       f(3) = ( (h_cool + alpha * (z - y) - gamma * (y - T_0))
    !  &           / mc_cool )

          f(1) = (( h_tar - beta * (x - y) ) / mc_tar )

          f(2) = (( h_base + beta * (x - y) - alpha * (y - z) )
     &           / mc_base )
          f(3) = (( h_cool + alpha * (y - z) - gamma * (z - T_0) )
     &           / mc_cool )

        end function f

        function rk4(time, temp, h)
c fourth order runge-kutta numerical integration
c ---------------------------------------------------------------------
c k1 is the gradient at the start of the step, k2 is the slope at the
c midpoint, k3 is another midpoint slope estimated from k2's slope, 
c k4 is the slope at the end of the step. kn are all 3 row arrays
c this is how f(t,T) updates the values for x y and z temperatures.
c ---------------------------------------------------------------------
          ! results are stored in 3 rows. passed by reference and
          ! updates everytime with new values for each of the 3 ODEs
          double precision, intent(in) :: time, temp(3), h
          double precision rk4(3)
          double precision, dimension(3) :: k1, k2, k3, k4

          integer i

          do i = 1, 3
            rk4(i) = 0
            k1(i) = 0
            k2(i) = 0
            k3(i) = 0
            k4(i) = 0
          end do

          k1 = h * f( time, temp )
          k2 = h * f( time + (0.5 * h) ,  temp + (0.5 * k1) )
          k3 = h * f( time + (0.5 * h) ,  temp + (0.5 * k2) )
          k4 = h * f( time + h ,  temp + k3 )

          rk4 = ( k1 + (2 * k2) + (2 * k3) + k4 ) / 6
        end function rk4


        subroutine calculate(max, step, init)
          integer,          intent(in) :: max
          double precision, intent(in) :: step
          double precision, dimension(3) :: temp
          double precision, dimension(3), intent(in) :: init
          double precision, dimension(max) :: time, x, y, z

          integer i

          time = [( step * i, i = 1, max )]  ! implied do loop

          ! setting up temp with initial values
          do i = 1, 3
            temp(i) = init(i)
          end do

          ! performing runge-kutta, reassigning temp() values and writes
          do i = 1, max
            x(i) = temp(1)
            y(i) = temp(2)
            z(i) = temp(3)

            ! temp is 3 rows, rk4 is 3 rows. each row corresponds to a 
            ! temperature value, each is independently updated.
            temp = temp + rk4( time(i), temp, step )

            write(*,1001) time(i), x(i), y(i), z(i)
          end do

1001  format (4(ES13.3,2x))

        end subroutine calculate


        subroutine euler(max, step, temp)
c ---------------------------------------------------------------------
c trying a euler method to see if that works any better. calculates
c slope at initial conditions and calculates the next point based on
c that slope and so on.
c ---------------------------------------------------------------------
          double precision, dimension(3):: temp
          integer, intent(in) :: max
          double precision, intent(in) :: step
          double precision, dimension(max) :: time, x, y, z
          integer i

          time = [( step * i, i = 1, max )]

          do i = 1, max
            x(i) = temp(1)
            y(i) = temp(2)
            z(i) = temp(3)

            ! dy/dt = f(t,y), y_n+1 = y_n + h * f_n(y,t)
            temp = temp + step * f( time(i), temp )

            write(*,1001) time(i), x(i), y(i), z(i)
          end do

1001  format (4(ES13.3,2x))

        end subroutine euler

      end program main



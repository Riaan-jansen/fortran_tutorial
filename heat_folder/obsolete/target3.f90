      module variables
        implicit none

        double precision, parameter :: pi = 3.1415

        ! cross sectional area of shared surface between plates [cm2]
        double precision, parameter :: radius = 3.0
        double precision, parameter :: area = pi * radius ** 2
        double precision, parameter :: area_base = area
        double precision, parameter :: area_tar = area
        double precision, parameter :: area_cool = area

        ! length in direction of heat travel [cm]
        double precision, parameter :: len_base = 1.0
        double precision, parameter :: len_tar = 0.03
        double precision, parameter :: len_cool = 0.5

        ! thermal conductivity (estimate 20C) [W/cm.C]
        double precision, parameter :: k_base = 39800.0
        double precision, parameter :: k_tar = 7120.0
        double precision, parameter :: k_cool = 60.0

        ! specific heat capacity [J/g.C]
        double precision, parameter :: c_base = 0.385
        double precision, parameter :: c_tar = 3.58
        double precision, parameter :: c_cool = 4.2

        ! mass [g]
        double precision, parameter :: m_base = 8.96 * len_base * area ! = 253
        double precision, parameter :: m_tar = 0.534 * len_tar * area ! = 0.453
        double precision, parameter :: m_cool = 4.2 * len_cool * area ! = 59.4

        ! mc coefficients
        double precision, parameter :: mc_base = m_base * c_base ! = 97.4
        double precision, parameter :: mc_tar = m_tar * c_tar    ! = 1.62
        double precision, parameter :: mc_cool = m_cool * c_cool ! = 249.5

        ! initial temp [C]
        double precision, parameter :: T_room = 20.0
        double precision, parameter :: T_0 = 18.0
        double precision, parameter :: T_base = 20.0
        double precision, parameter :: T_tar = 21.0
        double precision, parameter :: T_cool = 20.0

        ! calculate conductance
        double precision, parameter :: alpha = k_base*area_base/len_base  ! alpha = 1.1E6 W/K
        double precision, parameter :: beta = k_tar * area_tar / len_tar   ! beta = 6.7E6 W/K
        double precision, parameter :: gamma = k_cool*area_cool/len_cool  ! gamma = 3.4E3 W/K

      end module variables

      program main
        use variables
        implicit none

        ! step sizing
        ! double precision, parameter :: time_max = 10.0
        double precision, parameter :: step = 15.0
        ! integer, parameter :: max = anint(time_max / step)
        integer, parameter :: max = 10
        double precision, dimension(3) :: T

        T = [T_tar,T_base,T_cool]

        print *, "------------------RK4----------------------"

        call calculate(max, step, T)

        print *, "----------------EULER------------------------"

        call euler(max, step, T)

        print *, "------------------END----------------------"

      contains
        pure function f(time, temp)
          ! c f is a function that takes two arguments and is of dimension(3)
          ! c f takes the i-1 temp values and uses them as x, y, z in the ODEs
          ! c which are represented as elements in the 3dim array f
          double precision, dimension(3), intent(in) :: temp
          double precision, intent(in) :: time
          double precision, dimension(3) :: f
          double precision x, y, z

          double precision :: h_base
          double precision :: h_tar
          double precision :: h_cool
          integer A

          ! requires declaration of f() - otherwise would have no type!
          ! previous (i-1) temperature values to calculate f_i(T,t)
          ! where f is the first order derivative
          x = temp(1)
          y = temp(2)
          z = temp(3)

          ! for 10% beam duty factor. needs work
          A = int(time*100)
          if (mod(A,10) .EQ. 0 ) then
            h_tar = 0.0
            h_base = 0.0
            h_cool = 0.0
          else
            h_base = 0.0 !2435.8
            h_tar = 0.0
            h_cool = 0.0 !0.05756
          end if

          ! equations follow form:
          ! c (dT/dt) = (dQ/dt) - conductance * (Temp difference heat loss) +
          ! c             + conductance * (Temp difference heat gained) * 1/mc

          f(1) = (h_tar - beta * (x - y)) / mc_tar
          f(2) = (h_base + beta * (x - y) - alpha * (y - z)) / mc_base
          f(3) = (h_cool + alpha * (y - z) - gamma * (z - T_0))/ mc_cool

        end function f

        pure function rk4(time, temp, h)
          ! fourth order runge-kutta numerical integration

          ! c k1 is the gradient at the start of the step, k2 is the slope at the
          ! c midpoint, k3 is another midpoint estimated from k2's slope, 
          ! c k4 is the slope at the end of the step.

          ! results are stored in 3 dim arrays. passed by reference,
          ! updates everytime with new values for each of the 3 ODEs
          double precision, intent(in) :: time, temp(3), h
          double precision rk4(3)
          double precision, dimension(3) :: k1, k2, k3, k4

          k1 = h * f(time, temp)
          k2 = h * f(( time + 0.5 * h ), ( temp + 0.5 * k1 ))
          k3 = h * f(( time + 0.5 * h ), ( temp + 0.5 * k2 ))
          k4 = h * f(( time + h ), ( temp + k3 ))

          rk4 = ( k1 + (2 * k2) + (2 * k3) + k4 ) / 6
        end function rk4

        subroutine calculate(max, step, initial)
          integer,          intent(in) :: max
          double precision, intent(in) :: step
          double precision, dimension(3), intent(in) :: initial

          double precision, dimension(max) :: time, x, y, z
          double precision, dimension(3)   :: temp
          integer i

          time = [( step * i, i = 1, max )]  ! implied do loop

          ! setting up temp with initial values
          do i = 1, 3
            temp(i) = initial(i)
          end do

1001  format (4(ES13.3,2x))
          ! performing runge-kutta, reassigning temp() values and writing
          do i = 1, max
            x(i) = temp(1)
            y(i) = temp(2)
            z(i) = temp(3)
            temp = temp + rk4( time(i), temp, step)

            write(*,1001) time(i), x(i), y(i), z(i)
          end do
        end subroutine calculate

        subroutine euler(max, step, temp)
          double precision, dimension(3):: temp
          integer, intent(in) :: max
          double precision, intent(in) :: step
          double precision, dimension(max) :: time, x, y, z
          integer i

          do i = 1, max
            time(i) = step * i
          end do

          do i = 1, max
            x(i) = temp(1)
            y(i) = temp(2)
            z(i) = temp(3)

            temp = temp + f(time(i), temp)
          end do
1001  format (4(ES13.3,2x))
          do i = 1, max
            write(*,1001) time(i), x(i), y(i), z(i)
          end do

        end subroutine euler


      end program main



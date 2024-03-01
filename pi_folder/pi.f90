program main
    implicit none

    type :: tuple
        real :: xc, yc
    end type

    real, parameter :: R = 1.0
    integer, parameter :: N = 10000000
    real :: pin, pi
    ! real*8 :: pi
    integer :: ins

    real, dimension(N) :: rand_x, rand_y
    ! real, dimension(N) :: pin_x, pin_y
    ! type(tuple), allocatable :: in(:), out(:)

    integer :: i

    call random_number(rand_x)
    call random_number(rand_y)

    ins = 0
    do i = 1, N
        pin = rand_x(i)**2 + rand_y(i)**2
        if (pin <= 1) then
            ins = ins + 1 
        end if
    end do

    pi = piCalc(ins, N)
    print *, 'pi =', pi

contains
    pure function piCalc(ins, trials) result(retval)
        integer, intent(in) :: ins, trials
        real :: retval, ratio
        real :: in_r, n_r

        n_r = real(trials)
        in_r = real(ins)
        ratio = in_r / n_r
        retval = 4 * ratio

    end function piCalc

end program
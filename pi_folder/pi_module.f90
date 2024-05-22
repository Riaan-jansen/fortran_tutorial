module pi_finder

    use, intrinsic :: iso_fortran_env, only: sp=>real32, dp=>real64
    implicit none

contains

    real(dp) function pin_dropper(n, radius) result(inpins)

        real(dp), intent(in) :: n
        real(dp), intent(in) :: radius

        integer :: trials
        real(dp) :: x, y

        integer :: i

        inpins = 0.0
        trials = INT(n)
        do i = 1, trials
            call random_number(x)
            call random_number(y)
            if (x**2 + y**2 <= radius**2) then
                inpins = inpins + 1.0
            end if
        end do

    end function pin_dropper

    real(dp) function pi_calculator(n, inpins) result(pi_guess)

        real(dp), intent(in) :: n, inpins

        real(dp) :: No, PINS

        No = real(n)
        PINS = real(inpins)

        pi_guess = 4 * PINS / No  ! factor of 4 for quadrant

    end function pi_calculator

    subroutine pi_print(p_start, p_max, r)
        integer, intent(in) :: p_start, p_max
        real(dp), intent(in) :: r
        real(dp), parameter :: real_pi = 3.14159265359
        integer :: i
        real(dp) :: inpins, n, pi

        do i = p_start, p_max
            n = 100000.0*(i)
            inpins = pin_dropper(n, r)
            pi = pi_calculator(n, inpins)
            print *, n, pi
        end do
    end subroutine pi_print

end module pi_finder

program main

    use pi_finder
    use, intrinsic :: iso_fortran_env, only: sp=>real32, dp=>real64

    implicit none

    real(dp), parameter :: r = 1.0
    integer, parameter :: power = 1, power_max = 40
    integer :: t0, t1, cr
    real :: rate

    call system_clock(count_rate=cr)
    rate = real(cr)

    call system_clock(t0)
    call pi_print(power, power_max, r)
    call system_clock(t1)

    print *, "clock =", (t1 - t0) / rate

end program main

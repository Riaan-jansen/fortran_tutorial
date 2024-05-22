MODULE pi_finder

    USE, INTRINSIC :: iso_fortran_env, only: sp=>real32, dp=>real64
    IMPLICIT NONE

CONTAINS

    INTEGER FUNCTION pin_dropper(n, radius) result(inpins)

        INTEGER, INTENT(IN) :: n
        REAL, INTENT(IN) :: radius

        REAL, DIMENSION(n, 2) :: rand  ! not necessary but shows MxN matrix...
        REAL, DIMENSION(n) :: x, y     ! ... in fact probably slower

        INTEGER :: i

        CALL random_number(rand)  ! floats from interval [0,1]

        inpins = 0

        DO i = 1, n
            x(i) = rand(i, 1) * radius
            y(i) = rand(i, 2) * radius
            IF (x(i)**2 + y(i)**2 <= radius**2) THEN
                inpins = inpins + 1.0
            END IF
        END DO

    END FUNCTION pin_dropper

    REAL FUNCTION pi_calculator(n, inpins) result(pi_guess)

        INTEGER, INTENT(IN) :: n, inpins

        pi_guess = 4 * real(inpins) / real(n)  ! factor of 4 for quadrant

    END FUNCTION pi_calculator

    SUBROUTINE pi_print(p_start, p_max, r)
        INTEGER, INTENT(IN) :: p_start, p_max
        REAL, INTENT(IN) :: r
        INTEGER :: inpins, i, n
        REAL :: pi

        DO i = p_start, p_max
            n = 2000000*(i)
            inpins = pin_dropper(n, r)
            pi = pi_calculator(n, inpins)
            print *, n, pi
        END DO
    END SUBROUTINE pi_print

END MODULE pi_finder

PROGRAM main

    USE pi_finder
    USE, INTRINSIC :: iso_fortran_env, only: sp=>real32, dp=>real64

    IMPLICIT NONE

    REAL, PARAMETER :: r = 1.0
    INTEGER, PARAMETER :: power = 1, power_max = 20
    INTEGER :: t0, t1, cr
    REAL :: rate

    CALL SYSTEM_CLOCK(count_rate=cr)
    rate = real(cr)

    CALL SYSTEM_CLOCK(t0)
    CALL pi_print(power, power_max, r)
    CALL SYSTEM_CLOCK(t1)

    print *, "clock =", (t1 - t0) / rate

END PROGRAM main

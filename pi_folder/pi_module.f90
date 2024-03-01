MODULE pi_finder

    IMPLICIT NONE

CONTAINS

    INTEGER FUNCTION pin_dropper(n, radius) result(inpins)

        INTEGER, INTENT(IN) :: n
        REAL, INTENT(IN) :: radius

        REAL, DIMENSION(n, 2) :: rand  ! not necessary but shows MxN matrix...
        REAL, DIMENSION(n) :: x, y     ! ... in fact probably slower

        INTEGER :: i

        CALL random_number(rand)

        inpins = 0

        DO i = 1, n
            x(i) = rand(i, 1) * radius
            y(i) = rand(i, 2) * radius
            IF (x(i)**2 + y(i)**2 <= radius**2) THEN
                inpins = inpins + 1.0
            END IF
        END DO

    END FUNCTION pin_dropper

    REAL FUNCTION pi_calculator(inpins, n) result(pi_guess)

        INTEGER, INTENT(IN) :: n, inpins

        pi_guess = 4 * real(inpins) / real(n)  ! factor of 4 for quadrant

    END FUNCTION pi_calculator

END MODULE pi_finder

PROGRAM main

    USE pi_finder

    IMPLICIT NONE

    INTEGER, PARAMETER :: n = 1000000
    REAL, PARAMETER :: r = 1
    REAL :: pi
    INTEGER :: inpins

    inpins = pin_dropper(n, r)
    pi = pi_calculator(inpins, n)
    PRINT *, '--- pi =', pi, '---'

END PROGRAM main

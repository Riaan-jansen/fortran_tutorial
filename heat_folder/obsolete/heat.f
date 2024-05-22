* SOLVES HEAT EQUATION FOR 2D

      PROGRAM MAIN
        USE, INTRINSIC :: ISO_FORTRAN_ENV, ONLY: SP=>REAL32, DP=>REAL64
        IMPLICIT NONE

        ! CONDUCTIVITY AND MATERIAL SPECIFIC VALUES (LITHIUM) 
        REAL(DP), PARAMETER :: KAPPA = 0.85     ![W/(CMK)]
        REAL(DP), PARAMETER :: CP = 3.58        ![J/(GK)]
        REAL(DP), PARAMETER :: DENSITY = 0.533  ![G/CM3]
        REAL(DP) :: ALPHA, GAMMA

        ! NUMBER OF POINTS IN MESH
        INTEGER, PARAMETER :: IMAX = 15
        INTEGER, PARAMETER :: JMAX = 15
        INTEGER, PARAMETER :: KMAX = 15
        INTEGER, PARAMETER :: TMAX = 60 ! TIME MAX

        REAL(DP), PARAMETER :: STEPTIME = 1.0
        REAL(DP), PARAMETER :: STEPX = 1.0

        INTEGER, DIMENSION(4) :: MESH

        ! INITIAL CONDITIONS
        REAL(DP), ALLOCATABLE :: U(:, :, :, :)

        INTEGER :: X
        ALPHA = FALPHA(KAPPA, CP, DENSITY)
        GAMMA = FGAMMA(ALPHA, STEPX, STEPTIME)

        CALL INIT(U)

        CALL SOLVE(U)

        DO X = 1, 10
          PRINT *, U(X, 0, 0, 0)
        END DO

        PRINT *, "DONE"
      CONTAINS
        REAL(DP) FUNCTION FALPHA(K, SHC, P) RESULT(ALPHA)
          REAL(DP), INTENT(IN) :: K, SHC, P

          ALPHA = K / (SHC * P)
        END FUNCTION FALPHA

        REAL(DP) FUNCTION FGAMMA(ALPHA, STEPX, STEPTIME) RESULT(GAMMA)
          REAL(DP), INTENT(IN) :: ALPHA, STEPX, STEPTIME

          GAMMA = ALPHA * STEPTIME / (STEPX**2)
        END FUNCTION FGAMMA

        SUBROUTINE INIT(U)
          REAL(DP), ALLOCATABLE :: U(:, :, :, :)
          ALLOCATE(U(0:TMAX, 0:IMAX, 0:JMAX, 0:KMAX), SOURCE=0.0_DP)

        END SUBROUTINE INIT


        SUBROUTINE SOLVE(U)
          ! DOES THE CALCULATION FOR TEMPERATURE AS A FUNCTION OF TIME, X, Y, Z.
          REAL(DP), DIMENSION(0:TMAX, 0:IMAX, 0:JMAX, 0:KMAX) :: U
!          INTEGER, DIMENSION(4) :: MESH

          INTEGER :: T, I, J, K
!          INTEGER :: TMAX, IMAX, JMAX, KMAX

          DO T = 1, TMAX
            IF ( T .GT. TMAX ) THEN
              EXIT
            END IF
            DO I = 1, IMAX
              IF ( I .GT. IMAX ) THEN
                EXIT
              END IF
              DO J = 1, JMAX
                IF ( J .GT. JMAX ) THEN
                  EXIT
                END IF
                DO K = 1, KMAX
                  IF ( K .GT. KMAX ) THEN
                    EXIT
                  END IF

                  U(T+1, I, J, K) = GAMMA * (U(T, I+1, J, K) + U(T, I-1,
     &            J, K) + U(T, I, J+1, K) + U(T, I, J-1, K) + U(T, I, J,
     &            K+1) + U(T, I, J, K-1) - 6*U(T, I, J, K)) +
     &            U(T, I, J, K)

                END DO
              END DO
            END DO
          END DO
        END SUBROUTINE SOLVE

      END PROGRAM MAIN

      module variables
        implicit none

        double precision, parameter :: pi = 3.1415

        ! cross sectional area of shared surface between plates [cm2]
        double precision, parameter :: radius = 3D0
        double precision, parameter :: area = pi*radius**2
        double precision :: area_base
        double precision :: area_tar
        double precision :: area_cool

        ! length in direction of heat travel [cm]
        double precision, parameter :: len_base = 1.0
        double precision, parameter :: len_tar = 0.03
        double precision, parameter :: len_cool = 0.5

        ! thermal conductivity (estimate 20C) [W/cm.K]
        double precision, parameter :: k_base = 3.85D4
        double precision, parameter :: k_tar = 8.5D3
        double precision, parameter :: k_cool = 6.0D1

        ! specific heat capacity [J/g.K]
        double precision, parameter :: c_base = 0.385
        double precision, parameter :: c_tar = 3.58
        double precision, parameter :: c_cool = 4.2

        ! mass [g]
        double precision, parameter :: m_base = 8.96**len_base*area
        double precision, parameter :: m_tar = 0.538*len_tar*area
        double precision, parameter :: m_cool = 4.2*len_cool*area

        ! heat over time [W] and initial temp [K]

        double precision, parameter :: T_0 = 296.0

        double precision, parameter :: h_base = 0
        double precision, parameter :: h_tar = 15000
        double precision, parameter :: h_cool = 0

      end module variables

      program main
        use variables
        implicit none

        double precision, parameter :: T_base = 296.0
        double precision, parameter :: T_tar = 296.0
        double precision, parameter :: T_cool = 296.0

        double precision, parameter :: mc_base = m_base * c_base
        double precision, parameter :: mc_tar = m_tar * c_tar
        double precision, parameter :: mc_cool = m_cool * c_cool

        double precision alpha, beta, gamma

        double precision dt_base, dt_tar, dt_cool

        double precision, dimension(3,3) :: a
        double precision, dimension(3) :: b
        double precision, dimension(3) :: c
        integer i, j

        alpha = conduct(k_base, area, len_base)
        beta = conduct(k_tar, area, len_tar)
        gamma = conduct(k_cool, area, len_cool)

        print *, "empty"
        call assign(a, b)
        print *, "empty"
        do j = 1, 3
          print *, a(1,j), a(2,j), a(3,j)
        end do

        call mattimes(a, b, c)

        c(1) = c(1) + 
        do i = 1, 3
          print *, c(i)
        end do 

      contains

        double precision function conduct(K, area, len) result(G)
          double precision K
          double precision area
          double precision len

          G = K * area / len
        end function conduct

        subroutine mattimes(a, b, c)
          double precision, dimension(3,3) :: a
          double precision, dimension(3) :: b
          double precision, dimension(3), intent(out) :: c
          integer i, j

          do i = 1, 3
            do j = 1, 3
              c(i) = a(i, j) * b(i)
            end do
          end do
        end subroutine mattimes

        subroutine assign(mat, mat2)
          double precision, dimension(3,3) :: mat
          double precision, dimension(3) :: mat2

          mat(1,1) = -beta/mc_tar
          mat(2,1) = beta/mc_tar
          mat(3,1) = 0

          mat(1,2) = beta/mc_base
          mat(2,2) = -(beta + alpha)/mc_base
          mat(3,2) = alpha/mc_base

          mat(1,3) = 0
          mat(2,3) = alpha/mc_cool
          mat(3,3) = -(alpha + gamma)/mc_cool

          mat2(1) = T_base
          mat2(2) = T_tar
          mat2(3) = T_cool

        end subroutine assign

      end program main



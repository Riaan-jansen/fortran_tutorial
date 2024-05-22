      program main
        implicit none

        double precision, parameter :: decay = 6E+12
        double precision, parameter :: step = 3600.0 * 24
        double precision, parameter :: n_max = 3600 * 24 * 100
        integer, parameter          :: n = int(n_max / step)

        double precision, parameter :: N_start = 3.929E+22
        double precision N_0, time
        integer i

        character(len=1024) :: fname
        integer :: ounit

        ounit = 21

1001  FORMAT (F18.3,2x,ES18.6)  ! another method in subroutine

c writing filename and opening. explained in subroutine.
        write(fname, '("decay", I0, ".txt")') ounit
        open(unit=ounit, file=fname)

        ! initial no of lithium
        N_0 = N_start

        ! repeat total lithium - decay
        do i = 1, n
          time = step * i
          N_0 = f(N_0)

          ! cant have negative total lithium
          if (N_0 .LE. 0) then
            exit
          end if

          write(ounit,1001) time, N_0

        end do

        close(ounit)

        ! call to subroutine where expo decay data is written to
        ! different file
        call exponential(N_start)

      contains

        ! using decremental decay (informed by fluka sim more directly)
        double precision function f(N_in)
          double precision, intent(in)  :: N_in

          f = N_in - ( decay * step * N_in / N_start )

        end function f

        ! using exponential decay model
        subroutine exponential(N_0)
          integer i
          double precision, intent(in) :: n_0
          double precision, parameter  :: lambda = (1E-9) + (1E-18)
          double precision N_t

          character(len=1024) :: format_str
          character(len=1024) :: filename
          integer :: outunit

c         float, spaces, scientific. Can be declared like this or
c 101 FORMAT ()
          format_str = '(F18.3,2x,ES18.6)'
          ! This is the output unit. used to open & write to file.
          ! can also be used to write to files iteratively in a loop
          outunit = 22

          ! writing the filename
c the I0  takes the place of the outunit, and the rest is concatenating
c to form FILENAME. Can also put filepath here '("/path/to/file/" ... )
c ==================IMPORTANT=======================
c WRITE(X,*) 'ABC' turns X into 'ABC'.
c ==================================================
c filename = "..." would be easier but this can be transfered to loop
c writing of files. 
          write(filename, '("exp", I0, ".txt")') outunit

          ! open the file unit. form is either "formatted" or "un..."
          open(unit=outunit, file=filename, form='formatted')

          N_t = N_0

          do i = 1, n
            time = i * step
            N_t = N_0 * exp( -lambda * step * i )

            ! writing as per format_str time and no atoms to file
            write(outunit,format_str) time, N_t

          end do

          ! closing the file
          close(outunit)

        end subroutine exponential

      end program main

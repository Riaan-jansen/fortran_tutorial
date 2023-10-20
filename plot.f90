! basic plot using gnuplot!
program plotpls
    implicit none
    character(len=*), parameter :: OUT = 'data.txt'
    character(len=*), parameter :: PLT = 'plot.plt'
    integer, parameter :: N = 10

    integer :: i, file
    real :: x(N), y(N)

    do i = 1, N
        x(i) = 0.1 * i
        y(i) = x(i)**2
    end do

    open(action='write', file='data.txt', newunit=file, status='replace')

    do i = 1, N
        write(file,*) x(i), y(i)
    end do

    close(file)

    call execute_command_line('pwd')
    call execute_command_line("gnuplot -p 'plot.plt'")

    write(*,*) "Done"

end program plotpls

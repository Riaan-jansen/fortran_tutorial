! graphing
program main
    implicit none

    integer :: i
    integer, parameter :: N = 10

    real :: x, dx, y, dy

    character(len=64):: FILE

    write(*,*) 'Type file name'
    read(*,*) FILE
    OPEN(10, file = FILE)

    do
        read(10, *, end=1) x, dx, y, dy
        write(*,*) x, dx, y, dy
    end do
1 write(*,*) 'EOF'

end program main
program variables
	implicit none
	
	integer :: amount, i
	real :: pi
	complex :: frequency
	character :: initial
	logical :: isOkay
	real, dimension(10) :: hash = [ &
										1, 2, 4, 8, 16, &
										32, 64, 128, 256, 512]

	integer, parameter :: n = 11
	integer, parameter :: h = 0.01
	real :: r
	real, dimension(n) :: time
	integer t, a
	amount = 10
	pi = 3
	frequency = (1, -0.5)
	initial = 'init'
	isOkay = .true.

	if (isOkay .eqv.  .true.) then
		write(*,*) "pi =", pi
	end if

	call random_number(hash)

	! do i = 1, amount
	! 	print *, hash(i)
	! end do

	time = [(i * h, i = 1, n)]
	do i = 1, n
		t = floor(time(i)) * 100
		r = mod(t,10)
		print *, r
	end do


	! for 10% beam duty factor. needs work
	A = int(time*100)
	if (mod(A,10) .EQ. 0 ) then
		isOkay = .true.
	else
		isOkay = .false.
	end if

end program variables

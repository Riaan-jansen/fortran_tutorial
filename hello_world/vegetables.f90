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

	amount = 10
	pi = 3
	frequency = (1, -0.5)
	initial = 'init'
	isOkay = .true.

	if (isOkay .eqv.  .true.) then
		write(*,*) "pi =", pi
	end if

	call random_number(hash)

	do i = 1, amount
		print *, hash(i)
	end do

end program variables

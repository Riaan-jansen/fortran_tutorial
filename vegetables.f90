program variables
	implicit none
	
	integer :: amount
	real :: pi
	complex :: frequency
	character :: initial
	logical :: isOkay

	amount = 10
	pi = 3
	frequency = (1, -0.5)
	initial = 'init'
	isOkay = .true.

	if (isOkay .eqv.  .true.) then
		write(*,*) "pi =", pi
	end if

end program variables

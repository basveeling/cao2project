	.begin
	.org 0
	ld [i], %r1
	ld [d], %r2
	call aux
	! call test_ov
	halt

! This subroutine should reset the CWD to 0
aux:	call test_ov			
		
! This should, after nine iterations set the overflow bit
test_ov:	addcc %r1, %r2, %r1
		be einde
		call test_ov
		jmpl %r15+4, %r0
einde:		jmpl %r15+4, %r0

i:	9
d:	-1
	.end

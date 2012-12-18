	.begin
	.org 0
	! Creeer een underflow
	addcc %r0, -1, %r7
	.end
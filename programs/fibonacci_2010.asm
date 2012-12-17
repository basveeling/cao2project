! fibonacci(N) 
	.begin
! Macro PUSH
  .macro push arg1
    st  arg1, %r14
    addcc %r14, -4, %r14
  .endmacro
!Macro POP
  .macro pop arg2
    addcc %r14, 4, %r14
    ld %r14, arg2
  .endmacro
  
! Macro push_locals
  .macro push_locals
    push %r3
    push %r11
    push %r12
    push %r13
  .endmacro

! Macro pop_locals
  .macro pop_locals
    pop %r13
    pop %r12
    pop %r11
    pop %r3
  .endmacro
  
	.org 0
SP	.equ 600	! Stack pointer
N	.equ 6			! Fibonacci(N)
	add %r0, SP, %r14	! %r14 <- SP
	add %r0, N, %r1	! N in %r1
  push %r1  ! N op stack
	call fib
  pop %r1 ! resultaat in %r1
!	add %r14, 4,%r14	! N hoeft nu ook niet meer op de stack (aanpassen stack pointer)
	halt

fib:
! Uitgangspunt dat de locale variabelen en N (vd aanroep) op de stack moeten worden geplaatst voordat de recursieve
! functie wordt aangeroepen. Na afloop deze variabele weer terugzetten in %r11 (=r1), %r12 (=r2) en %r13 (=res=r3)
  push %r15 ! terugkeeradres op de stack
  ld [%r14+8], %r3  ! ophalen van N van de stack; %r3 wordt gebruik voor N
  ! CASE 
	! controleer op N=0, 1 of N>1 (verondersteld is dat N >= 0)
	addcc %r3, 0, %r6	! als N is 0 of 1 staat het resultaat in %r6 
	be Nis01
	addcc %r3, -1, %r0
	be Nis01
  ! fib(N-1)
	! Een recursieve aanroep. Nu plaatsen we N, r11, r12, r13 op de stack
  push_locals
  ! we moeten de parameter N-1 meegeven.
  addcc %r3, -1, %r3
  push %r3
  call fib
  pop %r5 ! het resultaat even tijdelijk in %r5
  ! terugzetten van de localen
  pop_locals
  add %r5, 0, %r11  ! r11=fib(N-1)
  ! fib(N-2)
	! Een recursieve aanroep. Nu plaatsen we N, r11, r12, r13 op de stack
  push_locals
  ! we moeten de parameter N-2 meegeven.
  addcc %r3, -2, %r3
  push %r3
  call fib
  pop %r5 ! het resultaat even tijdelijk in %r5
  ! terugzetten van de localen
  pop_locals
  add %r5, 0, %r12  ! r12=fib(N-2)
  ! fib(N-1)+fib(N-2)
  add %r11, %r12, %r13
	! Het resultaat (%r13) op de stack plaatsen op plaats van terugkeeradres 
	st %r13, [%r14+8]
  pop %r15  ! terugkeeradres in %r15  
	jmpl %r15+4, %r0	! uit subroutine  
Nis01:	! afronden; d.w.z. %r1 en %r15 terugplaatsen van de stack
	! Het resultaat (%r6) op de stack plaatsen op plaats van terugkeeradres 
	st %r6, [%r14+8]
  pop %r15  ! terugkeeradres in %r15  
	jmpl %r15+4, %r0	! uit subroutine
	halt
	.end


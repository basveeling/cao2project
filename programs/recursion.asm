! test programma om de CWP te testen. Dit is de happy flow (e.g. zonder window overflow/underflow).
! Berekent SUM(i) met i=0 tot N. 
  .begin
  .org 0
N .equ 6
  addcc %r0, N, %r24
  call sum 
! %r25 has the result, should be 21
  halt

sum:  addcc %r8, %r0, %r0
! controleer op N=0, 1 of N>1 (verondersteld is dat N >= 0)
  be nzero
  addcc %r8, -1, %r24
  call sum
! %r25 has result
  addcc %r25, %r8, %r9
  jmpl %r15+4, %r0 !r15 bevat nu natuurlijk niet het adres?

nzero: addcc %r0, %r0, %r9
  jmpl %r15+4, %r0
.end

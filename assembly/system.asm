%define system.numbers.call  0x80

section .text
  global kernel

kernel:
  int system.numbers.call
  ret

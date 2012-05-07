section .data
  success_token     db  "."
  success_token_len equ $-success_token
  failure_token     db  "X"
  failure_token_len equ $-failure_token

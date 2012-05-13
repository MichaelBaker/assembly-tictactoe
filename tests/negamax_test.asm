%include 'system.macro'
%include 'system.h'
%include 'board.macro'
%include 'board.h'
%include 'negamax.h'
%include 'test.macro'
%include 'test.h'

section .text
  global main

test_takes_center_to_counter_corner:
  push_board
  set_space esp, 0x0, 0x0, x_token
  mov eax, esp
  mov ebx, o_token
  call negamax
  mov ebx, 0x4
  assert_equal ebx, eax
  pop_board
  ret

test_takes_the_win_0:
  push_board
  set_space esp, 0x0, x_token
  set_space esp, 0x2, x_token
  mov eax, esp
  mov ebx, x_token
  call negamax
  mov ebx, 0x1
  assert_equal eax, ebx
  pop_board
  ret

test_takes_the_win_1:
  push_board
  set_space esp, 0x0, x_token
  set_space esp, 0x2, x_token
  set_space esp, 0x3, o_token
  set_space esp, 0x4, o_token
  mov eax, esp
  mov ebx, x_token
  call negamax
  mov ebx, 0x1
  assert_equal eax, ebx
  pop_board
  ret

test_last_move_is_tie:
  push_board
  set_space esp, 0x0, x_token
  set_space esp, 0x1, x_token
  set_space esp, 0x2, o_token
  set_space esp, 0x3, o_token
  set_space esp, 0x4, o_token
  set_space esp, 0x5, x_token
  set_space esp, 0x6, x_token
  set_space esp, 0x7, x_token
  mov eax, esp
  mov ebx, o_token
  call negamax
  mov ecx, 0x0
  assert_equal ebx, ecx
  pop_board
  ret

test_takes_only_move:
  push_board
  set_space esp, 0x0, x_token
  set_space esp, 0x1, x_token
  set_space esp, 0x2, o_token
  set_space esp, 0x3, o_token
  set_space esp, 0x4, o_token
  set_space esp, 0x5, x_token
  set_space esp, 0x6, x_token
  set_space esp, 0x7, x_token
  mov eax, esp
  mov ebx, o_token
  call negamax
  mov ecx, 0x8
  assert_equal eax, ecx
  pop_board
  ret

test_blocks_the_win:
  push_board
  set_space esp, 0x0, o_token
  set_space esp, 0x2, o_token
  mov eax, esp
  mov ebx, o_token
  call negamax
  mov edx, 0x1
  assert_equal eax, edx
  pop_board
  ret

main:
  call test_takes_center_to_counter_corner
  call test_takes_the_win_0
  call test_takes_the_win_1
  call test_last_move_is_tie
  call test_takes_only_move
  call test_blocks_the_win
  print newline, newline_len
  system.exit system.success

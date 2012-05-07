%include 'system.macro'
%include 'system.h'
%include 'test.macro'
%include 'test.h'
%include 'command_line.h'
%include 'board.macro'
%include 'board.h'

section .data
  board_string db "X________"

section .text
  global main

test_X_char_to_token:
  mov eax, 0x58
  call char_to_token
  assert_equal eax, x_token
  ret

test_O_char_to_token:
  mov eax, 0x4f
  call char_to_token
  assert_equal eax, o_token
  ret

test__char_to_token:
  mov eax, 0x5f
  call char_to_token
  assert_equal eax, empty_token
  ret

test_string_to_board:
  push_board
  mov eax, board_string
  mov ebx, esp
  call string_to_board
  mov al, [esp]
  assert_equal al, x_token
  pop_board
  ret

test_x_token_to_char:
  mov eax, x_token
  call token_to_char
  assert_equal eax, 0x58
  ret

test_o_token_to_char:
  mov eax, o_token
  call token_to_char
  assert_equal eax, 0x4f
  ret

test__token_to_char:
  mov eax, empty_token
  call token_to_char
  assert_equal eax, 0x5f
  ret

test_board_to_string:
  push_board
  set_space esp, 0x0, x_token
  mov eax, esp
  call board_to_string
  mov eax, 0x0
  mov al, [esp]
  assert_equal eax, 0x58
  pop_board
  ret

main:
  call test_X_char_to_token
  call test_O_char_to_token
  call test__char_to_token
  call test_string_to_board
  call test_x_token_to_char
  call test_o_token_to_char
  call test__token_to_char
  call test_board_to_string
  print newline, newline_len
  system.exit system.success

%include 'system.macro'
%include 'system.h'
%include 'test.macro'
%include 'test.h'
%include 'board.macro'
%include 'board.h'

section .text
  global main

; create_board allocates memory for a board and sets every space to empty
test_create_board:
  push_board            ; Allocates an empty board on the stack
  is_empty esp          ; Sets eax to the result of this predicate
  pop_board             ; Deallocates the board
  mov ebx, 0x1          ; Sets up the desired result for the assertion
  assert_equal ebx, eax
  ret

test_x_wins_row_0:
  push_board
  set_space esp, 0x0, 0x0, x_token
  set_space esp, 0x0, 0x1, x_token
  set_space esp, 0x0, 0x2, x_token
  x_wins esp
  mov ebx, 0x1
  assert_equal ebx, eax
  pop_board
  ret

test_x_blocked:
  push_board
  set_space esp, 0x0, 0x0, x_token
  set_space esp, 0x0, 0x1, o_token
  set_space esp, 0x0, 0x2, x_token
  x_wins esp
  mov ebx, 0x0
  assert_equal ebx, eax
  pop_board
  ret

test_x_only_two_tokens:
  push_board
  set_space esp, 0x0, 0x0, x_token
  set_space esp, 0x0, 0x2, x_token
  x_wins esp
  mov ebx, 0x0
  assert_equal ebx, eax
  pop_board
  ret

test_x_wins_row_1:
  push_board
  set_space esp, 0x1, 0x0, x_token
  set_space esp, 0x1, 0x1, x_token
  set_space esp, 0x1, 0x2, x_token
  x_wins esp
  mov ebx, 0x1
  assert_equal ebx, eax
  pop_board
  ret

test_x_wins_row_2:
  push_board
  set_space esp, 0x2, 0x0, x_token
  set_space esp, 0x2, 0x1, x_token
  set_space esp, 0x2, 0x2, x_token
  x_wins esp
  mov ebx, 0x1
  assert_equal ebx, eax
  pop_board
  ret

test_x_wins_column_0:
  push_board
  set_space esp, 0x0, 0x0, x_token
  set_space esp, 0x1, 0x0, x_token
  set_space esp, 0x2, 0x0, x_token
  x_wins esp
  mov ebx, 0x1
  assert_equal ebx, eax
  pop_board
  ret

test_x_wins_column_1:
  push_board
  set_space esp, 0x0, 0x1, x_token
  set_space esp, 0x1, 0x1, x_token
  set_space esp, 0x2, 0x1, x_token
  x_wins esp
  mov ebx, 0x1
  assert_equal ebx, eax
  pop_board
  ret

test_x_wins_column_2:
  push_board
  set_space esp, 0x0, 0x2, x_token
  set_space esp, 0x1, 0x2, x_token
  set_space esp, 0x2, 0x2, x_token
  x_wins esp
  mov ebx, 0x1
  assert_equal ebx, eax
  pop_board
  ret

test_x_wins_diagonal_0:
  push_board
  set_space esp, 0x0, 0x0, x_token
  set_space esp, 0x1, 0x1, x_token
  set_space esp, 0x2, 0x2, x_token
  x_wins esp
  mov ebx, 0x1
  assert_equal ebx, eax
  pop_board
  ret

test_x_wins_diagonal_1:
  push_board
  set_space esp, 0x0, 0x2, x_token
  set_space esp, 0x1, 0x1, x_token
  set_space esp, 0x2, 0x0, x_token
  x_wins esp
  mov ebx, 0x1
  assert_equal ebx, eax
  pop_board
  ret

test_o_wins_diagonal_0:
  push_board
  set_space esp, 0x0, 0x0, o_token
  set_space esp, 0x1, 0x1, o_token
  set_space esp, 0x2, 0x2, o_token
  o_wins esp
  mov ebx, 0x1
  assert_equal ebx, eax
  pop_board
  ret

test_copy_board:
  push_board
  mov eax, esp ; board one is pointed to by eax
  push_board
  mov ebx, esp ; board two is pointed to by ebx
  set_space eax, 0x0, 0x0, x_token
  set_space eax, 0x2, 0x2, o_token
  push eax
  push ebx
  copy_board ebx, eax
  pop ebx
  pop eax
  mov ecx, 0x0
  .loop
    mov edx, [ebx + ecx]
    cmp edx, [eax + ecx]
    jne .fail
    inc ecx
    cmp ecx, 0x2
    jbe .loop
  .success
    mov eax, 0x0
    jmp .end
  .fail
    mov eax, 0x1
  .end
  assert_equal eax, 0x0
  pop_board
  pop_board
  ret

test_is_tie:
  push_board
  mov ecx, 0x0
  .loop
    set_space esp, ecx, x_token
    inc ecx
    cmp ecx, 0x8
    jbe .loop
  is_tie esp
  assert_equal eax, 0x1
  pop_board
  ret

test_is_not_tie:
  push_board
  set_space esp, 0x0, x_token
  is_tie esp
  assert_equal eax, 0x0
  pop_board
  ret

test_is_empty_space_0:
  push_board
  mov eax, esp
  mov ebx, 0x0
  call _is_empty_space
  assert_equal eax, 0x1
  pop_board
  ret

test_is_empty_space_1:
  push_board
  mov eax, esp
  mov ebx, 0x8
  call _is_empty_space
  assert_equal eax, 0x1
  pop_board
  ret

test_is_not_empty_space_0:
  push_board
  set_space esp, 0x4, x_token
  mov eax, esp
  mov ebx, 0x4
  call _is_empty_space
  assert_equal eax, 0x0
  pop_board
  ret

test_is_not_empty_space_1:
  push_board
  set_space esp, 0x4, x_token
  mov eax, esp
  mov ebx, 0x3
  call _is_empty_space
  assert_equal eax, 0x1
  pop_board
  ret

test_other_token_x:
  push_board
  mov eax, x_token
  call _other_token
  mov ebx, o_token
  assert_equal eax, ebx
  pop_board
  ret

test_other_token_o:
  push_board
  mov eax, o_token
  call _other_token
  mov ebx, x_token
  assert_equal eax, ebx
  pop_board
  ret

test_get_token_X_on_space_one:
  push_board
  set_space esp, 0x0, x_token
  get_token esp, 0x0
  assert_equal eax, x_token
  pop_board
  ret

test_get_token_O_on_space_eight:
  push_board
  set_space esp, 0x8, o_token
  get_token esp, 0x8
  assert_equal eax, o_token
  pop_board
  ret

test_valid_space_is_empty:
  push ebp
  mov  ebp, esp
  push_board

  %define board [ebp - board_size - 0x4]
  push esp

  is_valid_space board, 0x0
  assert_equal eax, 0x1

  add esp, 0x4
  pop_board
  pop ebp
  ret

test_space_invalid_when_occupied:
  push ebp
  mov ebp, esp
  push_board

  %define board [ebp - 0x10]
  push esp

  mov ecx, board
  set_space ecx, 0x0, x_token
  is_valid_space board, 0x0
  assert_equal eax, 0x0

  add esp, 0x4
  pop_board
  pop ebp
  ret

test_space_invalid_when_over_eight:
  push ebp
  mov  ebp, esp
  push_board

  %define board [ebp - board_size - 0x4]
  push esp

  is_valid_space board, 0x9
  assert_equal eax, 0x0

  add esp, 0x4
  pop_board
  pop ebp
  ret

test_space_zero_valid_on_almost_full_board:
  push_board

  set_space esp, 0x1, x_token
  set_space esp, 0x2, o_token
  set_space esp, 0x3, o_token
  set_space esp, 0x4, o_token
  set_space esp, 0x5, x_token
  set_space esp, 0x6, x_token
  set_space esp, 0x7, x_token
  set_space esp, 0x8, o_token

  is_valid_space esp, 0x0

  assert_equal eax, 0x1

  pop_board
  ret

test_zero_board_works:
  push_board

  mov ecx, 0x0
  mov eax, empty_token

  .loop
    xor eax, [esp + ecx]
    cmp ecx, 0x8
    inc ecx
    jle .loop

  assert_equal eax, empty_token

  pop_board
  ret

main:
  call test_create_board
  call test_x_wins_row_0
  call test_x_blocked
  call test_x_only_two_tokens
  call test_x_wins_row_1
  call test_x_wins_row_2
  call test_x_wins_column_0
  call test_x_wins_column_1
  call test_x_wins_column_2
  call test_x_wins_diagonal_0
  call test_x_wins_diagonal_1
  call test_o_wins_diagonal_0
  call test_copy_board
  call test_is_tie
  call test_is_not_tie
  call test_is_empty_space_0
  call test_is_empty_space_1
  call test_is_not_empty_space_0
  call test_is_not_empty_space_1
  call test_other_token_x
  call test_other_token_o
  call test_get_token_X_on_space_one
  call test_get_token_O_on_space_eight
  call test_valid_space_is_empty
  call test_space_invalid_when_occupied
  call test_space_invalid_when_over_eight
  call test_space_zero_valid_on_almost_full_board
  call test_zero_board_works
  print newline, newline_len
  system.exit system.success

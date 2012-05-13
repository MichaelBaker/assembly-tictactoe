%include 'system.h'
%include 'system.macro'
%include 'test.macro'
%include 'test.h'
%include 'board.macro'
%include 'board.h'
%include 'tictactoe.h'

section .data
  number_of_tries dw 0x0
  game_ended      dw 0x0

section .text
  global main

; Mocks the user's move
user_chooses_space_zero:
  mov eax, 0x0
  ret

user_chooses_space_one:
  mov eax, 0x1
  ret

user_chooses_space_two:
  mov eax, 0x2
  ret

user_chooses_space_nine:
  inc dword [number_of_tries]
  cmp dword [number_of_tries], 0x1
  je .nine
  .eight ; Return an eight if it's the second try
    mov eax, 0x8
    jmp .end
  .nine  ; Return a nine if this is the first try
    mov eax, 0x9
    jmp .end
  .end
  ret

game_ends:
  mov dword [game_ended], 0x1
  ret

assert_x_wins:
  assert_equal eax, x_token
  ret

assert_o_wins:
  assert_equal eax, o_token
  ret

assert_empty_wins:
  assert_equal eax, empty_token
  ret

test_places_X_on_player_ones_position:
  push_board

  mov eax, esp
  mov ebx, user_chooses_space_zero
  mov ecx, user_chooses_space_one
  mov edx, game_ends
  call perform_turn

  get_token esp, 0x0
  assert_equal eax, x_token

  pop_board
  ret

test_retries_if_user_enters_invalid_token:
  push_board

  mov dword [number_of_tries], 0x0 ; Reset try count

  mov eax, esp
  mov ebx, user_chooses_space_nine
  mov ecx, user_chooses_space_one
  mov edx, game_ends
  call perform_turn

  mov dword eax, [number_of_tries] ; Ensure the user was asked twice
  assert_equal eax, 0x2

  pop_board
  ret

test_ends_game_if_its_a_tie:
  push_board

  set_space esp, 0x1, x_token
  set_space esp, 0x2, o_token
  set_space esp, 0x3, o_token
  set_space esp, 0x4, o_token
  set_space esp, 0x5, x_token
  set_space esp, 0x6, x_token
  set_space esp, 0x7, x_token
  set_space esp, 0x8, o_token

  mov dword [game_ended], 0x0 ; Reset game ended flag

  mov eax, esp
  mov ebx, user_chooses_space_zero
  mov edx, game_ends
  call perform_turn

  assert_equal [game_ended], 0x1

  pop_board
  ret

test_game_ends_if_X_wins:
  push_board

  set_space esp, 0x1, x_token
  set_space esp, 0x2, x_token

  mov dword [game_ended], 0x0 ; Reset game ended flag

  mov eax, esp
  mov ebx, user_chooses_space_zero
  mov edx, game_ends

  call perform_turn

  assert_equal [game_ended], 0x1

  pop_board
  ret

test_game_ends_if_O_wins:
  push_board

  set_space esp, 0x3, o_token
  set_space esp, 0x4, o_token
  set_space esp, 0x5, o_token

  mov dword [game_ended], 0x0 ; Reset game ended flag

  mov eax, esp
  mov ebx, user_chooses_space_zero
  mov edx, game_ends

  call perform_turn

  assert_equal [game_ended], 0x1

  pop_board
  ret

test_places_O_on_player_twos_position:
  push_board

  mov eax, esp
  mov ebx, user_chooses_space_zero
  mov ecx, user_chooses_space_one
  mov edx, game_ends
  call perform_turn

  get_token esp, 0x1
  assert_equal eax, o_token

  pop_board
  ret

test_eax_has_x_token_in_game_over_callback_if_x_wins:
  push_board

  set_space esp, 0x1, x_token
  set_space esp, 0x2, x_token

  mov dword [game_ended], 0x0 ; Reset game ended flag

  mov eax, esp
  mov ebx, user_chooses_space_zero
  mov edx, assert_x_wins

  call perform_turn

  pop_board
  ret

test_eax_has_o_token_in_game_over_callback_if_o_wins:
  push_board

  set_space esp, 0x2, o_token
  set_space esp, 0x4, o_token
  set_space esp, 0x6, o_token

  mov dword [game_ended], 0x0 ; Reset game ended flag

  mov eax, esp
  mov ebx, user_chooses_space_zero
  mov edx, assert_o_wins

  call perform_turn

  pop_board
  ret

test_eax_has_empty_token_in_game_over_callback_if_tie:
  push_board

  set_space esp, 0x1, x_token
  set_space esp, 0x3, o_token
  set_space esp, 0x4, o_token
  set_space esp, 0x5, x_token
  set_space esp, 0x6, x_token
  set_space esp, 0x7, x_token
  set_space esp, 0x8, o_token

  mov eax, esp
  mov ebx, user_chooses_space_zero
  mov ecx, user_chooses_space_two
  mov edx, assert_empty_wins

  call perform_turn

  pop_board
  ret

main:
  call test_places_X_on_player_ones_position
  call test_retries_if_user_enters_invalid_token
  call test_ends_game_if_its_a_tie
  call test_game_ends_if_X_wins
  call test_game_ends_if_O_wins
  call test_places_O_on_player_twos_position
  call test_eax_has_x_token_in_game_over_callback_if_x_wins
  call test_eax_has_o_token_in_game_over_callback_if_o_wins
  call test_eax_has_empty_token_in_game_over_callback_if_tie
  print newline, newline_len
  system.exit system.success

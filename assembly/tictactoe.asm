%include 'board.h'
%include 'board.macro'

section .text
  global perform_turn

; Arguments
;   eax - pointer to a board
;   ebx - pointer to a procedure which gets the move for player one
;   edx - pointer to a procedure which ends the game
%macro end_if 1
  %1 [ebp - 0x4]
  cmp eax, 0x1
  je .game_over
%endmacro

; A pointer to the current board need to be in eax
; The token to be placed needs to be in ebx
%macro player_turn 3
  .%1
    mov eax, [ebp - 0x4]
    mov ebx, %3
    call %2
    mov edx, eax ; Save the move
    is_valid_space [ebp - 0x4], edx
    jne .%1
    mov ecx, [ebp - 0x4]
    set_space ecx, edx, %3
    end_if is_tie
    end_if x_wins
    end_if o_wins
%endmacro

%macro save_pointers 0
  push eax ; Save the pointer to the board [ebp - 0x4]
  push ebx ; Save the pointer to the player one procedure [ebp - 0x8]
  push edx ; Save the pointer to end_game [ebp - 0xc]
  push ecx ; Save the pointer to the player two procedure [ebp - 0x10]
%endmacro

perform_turn:
  push ebp
  mov ebp, esp

  save_pointers
  player_turn player_one, [ebp - 0x8],  x_token
  player_turn player_two, [ebp - 0x10], o_token

  jmp .end
  .game_over
    .tie
      is_tie [ebp - 0x4]
      cmp eax, 0x1
      jne .x_wins
      mov eax, empty_token
      mov ebx, [ebp - 0x4]
      jmp .callback
    .x_wins
      x_wins [ebp - 0x4]
      cmp eax, 0x1
      jne .o_wins
      mov eax, x_token
      mov ebx, [ebp - 0x4]
      jmp .callback
    .o_wins
      mov eax, o_token
      mov ebx, [ebp - 0x4]
    .callback
    call [ebp - 0xc]

  .end
  add esp, 0x10
  pop ebp
  ret

%include 'board.macro'
%include 'board.h'

section .text
  global negamax

; Arguments:
;   eax - pointer to a board
;   ebx - the token that needs to be placed
; Return:
;   eax - the space into which the token should be placed
;   ebx - the expected score
negamax:
  push ebp       ; Save the previous stack pointer
  mov  ebp, esp

  %define current_token [ebp - 0x4]  ; The token to be placed
  push dword ebx

  %define space_count [ebp - 0x8]    ; The space count
  push dword 0x0

  %define original_board [ebp - 0xc] ; Pointer to original board
  push dword eax

  %define best_score [ebp - 0x10]    ; Best score
  push dword -1

  %define best_space [ebp - 0x14]    ; Best space
  push dword 0x0

  .loop
    ; Duplicate the board
    push_board
    mov eax, esp
    mov ebx, original_board
    call _copy_board

    ; Skip if this token is occupied
    mov eax, esp
    mov ebx, space_count
    call _is_empty_space
    cmp eax, 0x0
    je .next

    ; Place the token
    mov edi, space_count
    mov edx, current_token
    set_space esp, edi, dl

    ; Return if this move wins the game
    mov edx, current_token
    token_wins esp, dl
    cmp eax, 0x1
    je .take_win

    ; Return if this move results in a tie
    is_tie esp
    cmp eax, 0x1
    je .take_tie

    ; Get the result from the opponents move
    mov eax, current_token
    call _other_token
    mov ebx, eax
    mov eax, esp
    call negamax

    ; Update the score if this move is better or the same
    neg ebx
    cmp ebx, best_score
    jge .update_score

    jmp .next

    .take_win
      pop_board
      jmp .player_wins
    .take_tie
      pop_board
      jmp .tie_game
    .update_score
      mov edx, space_count
      mov best_space, edx
      mov best_score, ebx

  ; Try the next space
  .next
    pop_board
    inc dword space_count
    cmp dword space_count, 0x8
    jbe .loop

  .take_best_score
    mov eax, best_space
    mov ebx, best_score
    jmp .return

  .player_wins
    mov eax, space_count
    mov ebx, 0x1
    jmp .return

  .tie_game
    mov eax, space_count
    mov ebx, 0x0
    jmp .return

  .return
  add esp, 0x14 ; Clean up the stack
  pop ebp       ; Restore the previous base pointer
  ret

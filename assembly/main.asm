%include 'negamax.h'
%include 'board.h'
%include 'board.macro'
%include 'command_line.h'
%include 'system.h'
%include 'system.macro'
%include 'tictactoe.h'

section .data
  game_over_message     db  "Game Over"
  game_over_message_len equ $-game_over_message
  prompt                db  "Enter your move: "
  prompt_len            equ $-prompt
  x_wins_message        db  "~ X Wins ~"
  x_wins_message_len    equ $-x_wins_message
  o_wins_message        db  "~ O Wins ~"
  o_wins_message_len    equ $-o_wins_message
  tie_message           db  " ~ Tie ~"
  tie_message_len       equ $-tie_message

section .text
  global main

; Read a move from the player
player_one:
  push ebp
  mov ebp, esp
  push dword 0x0 ; Input buffer [ebp - 0x4]

  ; Prompt user
  push eax
  push ebx
  print prompt, prompt_len
  pop ebx
  pop eax

  ; Read first character from the user
  push eax
  push ebx
  push dword 0x1
  lea eax, [ebp - 0x4]
  push eax
  push dword 0x0
  push dword 0x0
  mov eax, 0x3
  int 0x80
  add esp, 0x10
  pop ebx
  pop eax

  ; Flush the rest of the characters from stdin
  .next_char
    push eax
    push ebx
    push dword 0x1
    lea eax, [ebp - 0x5]
    push eax
    push dword 0x0
    push dword 0x0
    mov eax, 0x3
    int 0x80
    add esp, 0x10
    cmp byte [ebp - 0x5], 0xa
    jne .next_char
  pop ebx
  pop eax

  ; Convert to a number
  xor eax, eax
  mov al, [ebp - 0x4]
  sub eax, 0x30

  leave
  ret

player_two:
  push ebx
  call negamax
  pop ebx
  ret

end_game:
  push eax
  push ebx
  print newline, newline_len
  pop ebx
  pop eax

  push eax
  mov eax, ebx
  call print_board
  pop eax

  cmp eax, empty_token
  je .tie
  cmp eax, x_token
  je .x_wins
  cmp eax, o_token
  je .o_wins

  .tie
    print tie_message, tie_message_len
    jmp .end
  .x_wins
    print x_wins_message, x_wins_message_len
    jmp .end
  .o_wins
    print o_wins_message, o_wins_message_len

  .end
  print newline, newline_len
  system.exit system.success

main:
  push ebp
  mov ebp, esp
  push_board ; [ebp - 0xc]

  .loop
    lea eax, [ebp - 0xc]
    call print_board
    lea eax, [ebp - 0xc]
    mov ebx, player_one
    mov ecx, player_two
    mov edx, end_game
    call perform_turn
    print newline, newline_len
    jmp .loop

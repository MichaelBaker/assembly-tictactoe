%include 'negamax.h'
%include 'board.h'
%include 'board.macro'
%include 'command_line.h'
%include 'system.h'
%include 'system.macro'
%include 'tictactoe.h'

section .data
  prompt                db  "Enter your move: "
  prompt_len            equ $-prompt
  x_wins_message        db  " ~ X Wins ~"
  x_wins_message_len    equ $-x_wins_message
  o_wins_message        db  " ~ O Wins ~"
  o_wins_message_len    equ $-o_wins_message
  tie_message           db  "   ~ Tie ~"
  tie_message_len       equ $-tie_message

section .text
  global main

flush_stdin:
  push eax
  push ebp
  mov ebp, esp

  ; Read characters until a newline is read
  .next_char
    call read_character
    cmp  eax, 0xa
    jne .next_char

  leave
  pop eax
  ret

read_character:
  push ebp
  mov ebp, esp
  push dword 0x0 ; Buffer [ebp - 0x4]

  ; Read Character
  lea eax, [ebp - 0x4]
  push dword 0x1        ; Number of bytes to read
  push eax              ; Pointer to a buffer to read into
  push dword 0x0        ; File descriptor to read from 
  system.systemcall 0x3 ; Perform system call
  add esp, 0xc          ; Clean up
  xor eax, eax
  mov al, [ebp - 0x4]

  leave
  ret

; Get move from a human player
player_one:
  push ebp
  mov ebp, esp
  push dword 0x0 ; Input buffer [ebp - 0x4]

  print prompt, prompt_len ; Prompt user
  call read_character      ; Read first character from the user
  push eax                 ; Save the user's choice
  call flush_stdin         ; Discard the remaining characters
  pop eax                  ; Recover user's choice
  sub eax, 0x30            ; Convert user's input to a number

  leave
  ret

player_two:
  push ebx
  call negamax
  pop ebx
  ret

end_game:
  ; Print a newline
  push eax
  push ebx
  print newline, newline_len
  pop ebx
  pop eax

  ; Print the final board
  push eax
  mov eax, ebx
  call print_board
  pop eax

  ; Determine game-over message
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
    ; Print the board
    lea eax, [ebp - 0xc]
    call print_board

    ; Let both players place a token
    lea eax, [ebp - 0xc]
    mov ebx, player_one
    mov ecx, player_two
    mov edx, end_game
    call perform_turn

    ; Go to next turn
    print newline, newline_len
    jmp .loop

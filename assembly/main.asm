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

section .text
  global main

player_one:
  push ebx
  call negamax
  pop ebx
  ret

player_two:
  push ebx
  call negamax
  pop ebx
  ret

end_game:
  mov eax, ebx
  call print_board
  print game_over_message, game_over_message_len
  system.exit system.success

main:
  push ebp
  mov ebp, esp
  push_board ; [ebp - 0xc]

  .loop
    lea eax, [ebp - 0xc]
    mov ebx, player_one
    mov ecx, player_two
    mov edx, end_game
    call perform_turn
    lea eax, [ebp - 0xc]
    call print_board
    print newline, newline_len
    jmp .loop

  system.exit system.success

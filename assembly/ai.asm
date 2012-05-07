%include 'system.macro'
%include 'system.h'
%include 'board.macro'
%include 'board.h'
%include 'command_line.h'
%include 'negamax.h'

section .text
  global main

main:
  pop eax ; argc
  pop ebx ; filename
  pop ebx ; pointer to board string
  pop ecx ; pointer to token character
  push_board

  ; Convert board
  mov eax, ebx
  mov ebx, esp
  call string_to_board

  ; Convert player token
  mov eax, 0x0
  mov al, [ecx]
  call char_to_token
  mov ecx, eax

  ; Make move
  mov eax, esp
  mov ebx, ecx
  push ecx
  call negamax
  pop ecx
  set_space esp, eax, cl

  ; Convert back to string
  mov eax, esp
  call board_to_string

  ; Print new board
  mov eax, esp
  print eax, 0x9

  system.exit system.success

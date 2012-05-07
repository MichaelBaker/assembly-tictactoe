%include 'board.macro'

section .text
  global char_to_token
  global string_to_board
  global token_to_char
  global board_to_string

; Arguments
;   eax - the character to convert
; Result:
;   eax - the token
char_to_token:
  cmp eax, 0x58 ; Is it an 'X' character
  je .x_token
  cmp eax, 0x4f ; Is it an 'O' character
  je .o_token
  .empty_token  ; Is it a '_' character
    mov eax, empty_token
    jmp .end
  .o_token
    mov eax, o_token
    jmp .end
  .x_token
    mov eax, x_token
  .end
  ret

; Arguments
;   eax - pointer to string
;   ebx - pointer to destination board
string_to_board:
  ; Save the caller's registers
  push ecx
  push edx
  mov edx, eax
  mov ecx, 0x0
  ; For each character in the string, place the token on the board
  .loop
    mov eax, 0x0
    mov al, [edx + ecx]
    call char_to_token
    mov [ebx + ecx], al
    inc ecx
    cmp ecx, 0x8
    jbe .loop
  ; Restore the caller's registers
  pop edx
  pop ecx
  ret

; Arguments
;   eax - token to convert
; Result
;   eax - character
token_to_char:
  cmp al, x_token  ; Is it an x token
  je .x_token
  cmp eax, o_token ; Is it an o token
  je .o_token
  .empty_token     ; Is it an empty token
    mov eax, 0x5f
    jmp .end
  .o_token
    mov eax, 0x4f
    jmp .end
  .x_token
    mov eax, 0x58
  .end
  ret

; Arguments
;   eax - pointer to board
board_to_string:
  ; Save the caller's registers
  push ecx
  push edx
  mov edx, eax
  mov ecx, 0x0

  ; For each token, replace it with a character
  .loop
    mov eax, 0x0
    mov al, [edx + ecx]
    call token_to_char
    mov [edx + ecx], al
    inc ecx
    cmp ecx, 0x8
    jbe .loop

  ; Restore the caller's registers
  pop edx
  pop ecx
  ret

%include 'system.macro'
%include 'system.h'
%include 'board.macro'

section .text
  global _is_empty
  global _token_wins
  global _copy_board
  global _is_empty_space
  global _is_tie
  global _other_token
  global _zero_board

; Arguments
;   eax - pointer to a board
; Result
;   eax - boolean
_is_empty:
  push ecx
  mov ecx, empty_token
  mov ebx, eax
  mov eax, 0x0
  or al, [ebx]
  or al, [ebx + 0x1]
  or al, [ebx + 0x2]
  or al, [ebx + 0x3]
  or al, [ebx + 0x4]
  or al, [ebx + 0x5]
  or al, [ebx + 0x6]
  or al, [ebx + 0x7]
  or al, [ebx + 0x8]
  cmp al, cl
  jne .is_empty_failure
    mov eax, 0x1
    jmp .end
  .is_empty_failure
    mov eax, 0x0
  .end
  pop ecx
  ret

%macro test_line 3
  mov ebx, 0x0
  or  bl,  %1
  and bl,  %2
  and bl,  %3
  cmp ecx, ebx
  je .success
%endmacro

; Arguments
;   eax - pointer to a board
;   ecx - token to test against
; Result
;   eax - boolean
_token_wins:
  push ecx
  test_line [eax],        [eax + 0x1],  [eax + 0x2]
  test_line [eax + 0x3],  [eax + 0x4],  [eax + 0x5]
  test_line [eax + 0x6],  [eax + 0x7],  [eax + 0x8]
  test_line [eax],        [eax + 0x3],  [eax + 0x6]
  test_line [eax + 0x1],  [eax + 0x4],  [eax + 0x7]
  test_line [eax + 0x2],  [eax + 0x5],  [eax + 0x8]
  test_line [eax],        [eax + 0x4],  [eax + 0x8]
  test_line [eax + 0x2],  [eax + 0x4],  [eax + 0x6]

  .failure
    mov eax, 0x0
    jmp .end
  .success
    mov eax, 0x1
  .end
  pop ecx
  ret

; Arguments:
;   eax - Pointer to the board
;   ebx - space to check
; Result:
;   eax - boolean
_is_empty_space:
  cmp byte [eax + ebx], empty_token
  jne .failure
  .success
    mov eax, 0x1
    jmp .end
  .failure
    mov eax, 0x0
  .end
  ret

; Arguments
;   eax - pointer to destination board
;   ebx - pointer to the source board
_copy_board:
  push ecx
  mov ecx, 0x0
  .loop
    mov edx, [ebx + ecx] ; Fetch the other board's values
    mov [eax + ecx], edx ; Place them in this board's memory
    add ecx, 0x4         ; Increment counter
    cmp ecx, 0x8         ; Loop if necessary
    jbe .loop
  pop ecx
  ret

; Arguments
;   eax - pointer to the board
_is_tie:
  push ecx
  mov ecx, 0x0
  .loop
    mov byte dl, [eax + ecx]
    cmp dl, empty_token
    je .is_not_tie
    inc ecx
    cmp ecx, 0x8
    jbe .loop
  .is_tie
    pop ecx
    mov eax, 0x1
    ret
  .is_not_tie
    pop ecx
    mov eax, 0x0
    ret

; Arguments
;   eax - token to convert
; Result
;   eax - new token
_other_token:
  cmp eax, x_token
  je .o_token
    mov eax, x_token
    jmp .end
  .o_token
    mov eax, o_token
  .end
  ret

; Arguments
;   eax - pointer to the board to clear
_zero_board:
  push edx

  ; Create an empty double word
  mov edx, empty_token
  shl edx, 0x8
  add edx, empty_token
  shl edx, 0x8
  add edx, empty_token
  shl edx, 0x8
  add edx, empty_token

  ; Copy the empty double word over the entire board
  mov dword [eax], edx
  mov dword [eax + 0x4], edx
  mov dword [eax + 0x8], edx

  pop edx
  ret

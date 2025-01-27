; cmp  == compare
; je : equal
; jne : not equal
; jg : greater
; jl : less
; jge : greater or equal
; jle : less or equal



section .data
    msg1 db "First number is greater", 10
    msg2 db "First number is less", 10
    msg3 db "Both number are equal", 10

section .bss
    num1 resb 1
    num2 resb 2

section .text
    global _start:

_start:
    ; inisialisasi angka
    mov byte [num1], 10                 ; pindahkan value dalam byte ke num1
    mov byte [num2], 5                  ; pindahkan value dalam byte ke num2

    ; ambil nilai dari num1 dan num2 ke register
    mov al, [num1]
    mov bl, [num2]

    cmp al, bl                          ; bandingkan value di register
    je equal_label                      ; jika sama pindah ke label equal_label
    jl less_label                       ; jika lebih kecil pindah ke less_label
    jg greater_label                    ; jika lebih besar pindah ke greater_label

equal_label:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg3
    mov edx, 22
    int 0x80

less_label:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, 21
    int 0x80

greater_label:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, 24
    int 0x80

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80

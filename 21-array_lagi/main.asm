section .data
    array db '1', '2', '3', '4', '5'
    newline db 10

section .bss


section .text
    global _start

_start:
    mov edi, array
    mov esi, 0

loop_from_start:
    mov eax, 4
    mov ebx, 1
    lea ecx, [edi + esi]
    mov edx, 1
    int 0x80

    inc esi
    cmp esi, 5
    jl loop_from_start

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov esi, 4
loop_from_end:
    mov eax, 4
    mov ebx, 1
    lea ecx, [edi + esi]
    mov edx, 1
    int 0x80

    dec esi
    cmp esi, 0
    jge loop_from_end

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80

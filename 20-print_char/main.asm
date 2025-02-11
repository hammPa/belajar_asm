section .data
    text db "hello world", 0
    text_len equ $ - text
    newline db 10

section .text
    global _start

_start:
    mov edi, text
    mov esi, 0

print_char:
    movzx eax, byte [edi + esi]  ; Ambil 1 byte karakter
    cmp eax, 0                   ; Periksa apakah null terminator
    je exit

    mov ecx, edi                 ; Pindahkan alamat string ke ecx
    add ecx, esi                 ; Geser ke karakter saat ini
    mov eax, 4                   ; syscall write
    mov ebx, 1                   ; stdout
    mov edx, 1                   ; Panjang karakter = 1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    inc esi                      ; Geser ke karakter berikutnya
    cmp esi, text_len            ; Cek apakah sudah selesai
    jl print_char                ; Jika belum, ulangi

exit:
    mov eax, 1                   ; syscall exit
    xor ebx, ebx
    int 0x80

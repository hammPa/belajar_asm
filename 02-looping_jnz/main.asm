section .data
    message db "Hello, World!", 0xA ; Pesan dengan newline (0xA)
    len_msg equ $ - message          ; Panjang pesan

section .text
    global _start

_start:
    ; Menginisialisasi counter loop
    mov esi, 3          ; Set jumlah iterasi loop ke 3

loop_start:
    ; Cetak pesan
    mov eax, 4          ; syscall: write
    mov ebx, 1          ; file descriptor: stdout
    mov edx, len_msg    ; Panjang pesan
    mov ecx, message    ; Gunakan ESI untuk alamat pesan
    int 0x80            ; Panggil kernel

    dec esi
    jnz loop_start

exit:
    ; Keluar dari program
    mov eax, 1          ; syscall: exit
    xor ebx, ebx        ; Status keluar: 0
    int 0x80

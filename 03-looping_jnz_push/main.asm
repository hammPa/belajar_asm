section .data
    message db "Hello, World!", 0xA ; Pesan dengan newline (0xA)
    len_msg equ $ - message          ; Panjang pesan
    count db 3

section .text
    global _start

_start:
    ; Menginisialisasi counter loop
    mov ecx, [count]          ; ambil nilai dari alamat count

loop_start:
    push ecx            ; pindahkan nilai counter ke stack (stack sifatnya FILO)
    ; Cetak pesan
    mov eax, 4          ; syscall: write
    mov ebx, 1          ; file descriptor: stdout
    mov edx, len_msg    ; Panjang pesan
    mov ecx, message    ; Gunakan ESI untuk alamat pesan
    int 0x80            ; Panggil kernel

    pop ecx             ; ambil dari stack
    ;dec ecx             ; kurangkan 1
    ;jnz loop_start      ; periksa apakah 0
    loop loop_start

exit:
    ; Keluar dari program
    mov eax, 1          ; syscall: exit
    xor ebx, ebx        ; Status keluar: 0
    int 0x80

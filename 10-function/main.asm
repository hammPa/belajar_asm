; fungsi
; Sebuah fungsi biasanya menerima argumen melalui register atau stack.
; Hasil dari fungsi dikembalikan melalui register tertentu (misalnya, eax).
; Fungsi memiliki label sebagai titik masuk dan titik keluar.

section .data
    message db "hello world", 0xA
    messageLen equ $ - message
    count db 3

section .text
    global _start

_start:
    call print_message

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80

; fungsi print message
print_message:
    mov eax, 4
    mov ebx, 1
    mov ecx, message
    mov edx, messageLen
    int 0x80
    ret

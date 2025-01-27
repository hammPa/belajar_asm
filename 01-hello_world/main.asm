section .data
    msg db "hello world", 10, 0
    msgLen equ $-msg

section .text
    global  _start

start:
    mov eax, 4      ; kernel system write
    mov ebx, 1      ; stdout
    mov ecx, msg    ; alamat string
    mov edx, msgLen ; panjangnya
    int 0x80        ; panggil syscall kernel

    mov eax, 1      ; kernel system out
    xor ebx, ebx    ; exit code 0 : success
    int 0x80

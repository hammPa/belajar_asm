section .data
    result db "Factorial: ", 0
    newline db 10, 0

section .bss
    buffer resb 10      ; Buffer untuk menyimpan hasil angka

section .text
    global _start

_start:
    mov eax, 5          ; Masukkan angka 5 ke EAX
    call factorial      ; Panggil fungsi factorial
    call print_number
    mov eax, 1          ; syscall: sys_exit
    int 0x80            ; Keluar dari program

factorial:
    cmp eax, 1          ; Jika EAX <= 1, keluar dari rekursi
    jle end_factorial   ; Lompat ke end_factorial jika <= 1
    push eax            ; Simpan nilai EAX di stack
    dec eax             ; Kurangi EAX (n-1)
    call factorial      ; Panggil factorial(n-1)
    pop ebx             ; Ambil nilai n dari stack
    mul ebx             ; EAX = EAX * EBX (perkalian rekursif)
end_factorial:
    ret                 ; Kembali ke pemanggil

print_number:
    mov ecx, buffer + 9 ; Mulai dari belakang buffer
    mov byte [ecx], 0   ; Tambahkan null-terminator
    ; Kita menyimpan 0 di alamat ecx.
    ; Ini adalah null-terminator (\0), yang menandakan akhir dari string dalam bahasa Assembly/C.
    ; String di Assembly tidak punya panjang bawaan, jadi kita pakai 0 sebagai penanda akhir.

convert_loop:
    dec ecx
    mov edx, 0
    div dword [ten]     ; EAX / 10, sisa di EDX, dword → Menunjukkan bahwa data yang digunakan adalah 4 byte (32-bit).
    add dl, '0'         ; Ubah ke karakter ASCII
    mov [ecx], dl       ; Simpan di buffer
    test eax, eax       ; Jika EAX = 0, selesai
    jnz convert_loop

    mov eax, 4          ; syscall: sys_write
    mov ebx, 1
    mov edx, buffer + 9
    sub edx, ecx
    mov ecx, ecx
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ret

section .data
    ten dd 10

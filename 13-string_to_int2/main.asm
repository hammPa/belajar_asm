section .data
    message db "Masukkan angka: ", 0
    messageLen equ $ - message

    messageResult db "Hasil konversi: ", 0
    messageResultLen equ $ - messageResult

    newline db 10, 0

section .bss
    buffernum resb 32                                           ; buffer untuk input
    buffertext resb 32                                          ; buffer untuk hasil konversi ke string

section .text
    global _start

_start:
    ; tampilkan "Masukkan angka: "
    mov eax, 4
    mov ebx, 1
    mov ecx, message
    mov edx, messageLen
    int 0x80

    ; ambil input angka
    mov eax, 3
    mov ebx, 0                                                  ; input dari stdin (file descriptor 0)
    mov ecx, buffernum
    mov edx, 32                                                 ; maksimal 32 byte
    int 0x80

    ; Konversi string ke integer (langsung di main)
    xor eax, eax                                                ; clear eax, untuk menampung hasil konversi
    xor ebx, ebx                                                ; clear ebx, untuk index buffer
    mov edx, 10                                                 ; basis 10 untuk konversi

next_digit:
    mov ecx, [buffernum + ebx]                                  ; ambil karakter input menurut index
    cmp ecx, 10                                                 ; cek apakah newline (\n), jika ya, selesai
    je done
    cmp ecx, 13                                                 ; cek apakah carriage return (\r), jika ya, selesai
    je done
    sub ecx, '0'                                                ; konversi karakter jadi angka
    imul eax, edx                                               ; eax = eax * 10 (basis 10)
    add eax, ecx                                                ; tambahkan angka yang ditemukan
    inc ebx                                                     ; naikkan index
    jmp next_digit                                              ; lanjutkan ke digit berikutnya

done:
                                                                ; sekarang eax berisi angka yang dikonversi (misal 50)
                                                                ; sub eax dengan dirinya sendiri (set menjadi 0)
    sub eax, eax

    ; convert integer (0) ke string
    add eax, '0'                                                ; konversi ke karakter ASCII (misalnya, 0 -> '0')
    mov [buffertext], al                                        ; simpan hasil ke buffertext
    mov byte [buffertext + 1], 0                                ; null terminator

    ; tampilkan "Hasil konversi: "
    mov eax, 4
    mov ebx, 1
    mov ecx, messageResult
    mov edx, messageResultLen
    int 0x80

    ; tampilkan hasil konversi (buffertext)
    mov eax, 4
    mov ebx, 1
    mov ecx, buffertext
    mov edx, 2                                                  ; panjang string hasil konversi '0' + null terminator
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80

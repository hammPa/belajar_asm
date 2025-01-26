section .data
    arr db 1, 2, 3
    len_of_arr equ 3
    buffer db '0', 10

section .text
    global _start

_start:
    xor eax, eax
    lea esi, [arr]              ; ambil alamat awal array dan pindahkan ke esi
    mov ecx, len_of_arr         ; ambil alamat dari nilai panjang array dan pindahkan ke ecx

loop_of_sum_start:
    add al, [esi]               ; jumlahkan niai array pada esi dengan al
    inc esi                     ; naikkan pointer array
    loop loop_of_sum_start

    add al, '0'                 ; ubah jadi string
    mov [buffer], al            ; pindahkan string dari al ke buffer

    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 2
    int 0x80


    mov eax, 1
    xor ebx, ebx
    int 0x80

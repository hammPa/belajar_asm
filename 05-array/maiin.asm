section .data
    array db 1, 2, 3, 4, 5
    count db 5
    buffer db '0', 0  ; buffer untuk menyimpan karakter yang akan dicetak


section .text
    global _start

_start:
    movzx ecx, byte [count]    ; ambil nilai dari alamat count
    lea esi, [array]    ; pindahkan alamat array ke esi

loop_start:
    push ecx
    movzx eax, byte [esi] ; ambil elemen array dan zero-extend ke eax
    add eax, '0'        ; konversi angka ke karakter ASCII
    mov [buffer], al    ; simpan karakter ke buffer

    mov eax, 4
    mov ebx, 1
    mov ecx, buffer  ; ambil elemen array
    mov edx, 1
    int 0x80

    inc esi ; increment alamatnya
    pop ecx
    dec ecx ; kurangi counter
    jnz loop_start

    mov eax, 1
    xor ebx, ebx
    int 0x80


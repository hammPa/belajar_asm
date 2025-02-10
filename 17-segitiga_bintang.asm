section .data
    pesan db "Masukkan jumlah baris bintang : ", 0
    pesanLen equ $ - pesan

    newline db 10
    star db '*', 0

section .bss
    buffer resb 10

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, pesan
    mov edx, pesanLen
    int 0x80

    mov eax, 3
    mov ebx, 0
    lea ecx, [buffer]
    mov edx, 10
    int 0x80

    call string_to_int
    mov esi, eax


first_loop:
    test esi, esi       ; Cek apakah sudah mencapai 0
    jz exit             ; Jika 0, keluar

    mov edi, esi        ; Simpan jumlah bintang yang akan dicetak dalam satu baris
second_loop:
    test edi, edi       ; Cek apakah sudah mencapai 0
    jz print_newline    ; Jika 0, cetak newline

    ; Cetak bintang
    mov eax, 4
    mov ebx, 1
    mov ecx, star
    mov edx, 1
    int 0x80

    dec edi             ; Kurangi jumlah bintang
    jmp second_loop     ; Ulangi loop dalam

print_newline:
    ; Cetak newline setelah selesai mencetak satu baris bintang
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    dec esi             ; Kurangi jumlah baris
    jmp first_loop      ; Ulangi loop luar

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80

string_to_int:
    xor ebx, ebx            ; bersihkan ebx dan ecx
    xor ecx, ecx            ; ebx untuk menyimpan hasil

next_char:
    mov al, byte [buffer + ecx] ; pindahkan nilai dari buffer perkarakter ke al
    cmp al, 0xA             ; newline
    je done
    cmp al, 0               ; endstring
    je done
    sub al, '0'             ; ubah jadi int
    imul ebx, ebx, 10       ; kalikan ebx dengan 10
    add ebx, eax            ; tambahkan dengan angka baru
    inc ecx                 ; naikkan nilainya
    jmp next_char

done:
    mov eax, ebx            ; pindahkan buffer dari ebx ke eax
    ret

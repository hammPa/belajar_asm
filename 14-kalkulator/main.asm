section .data
    messageInput1 db "Masukkan angka pertama: ", 0
    input1Len equ $ - messageInput1

    messageInput2 db "Masukkan angka kedua  : ", 0
    input2Len equ $ - messageInput2

    messageOperator db "Masukkan operator : ", 0
    operatorLen equ $ - messageOperator

    messageHasil db "Hasil operasi adalah : ", 0
    hasilLen equ $ - messageHasil

    newline db 0xA, 0

section .bss
    operand1 resd 1         ; 4 bytes untuk integer (32-bit)
    operand2 resd 1         ; 4 bytes untuk integer (32-bit)
    result resb 12          ; buffer untuk string hasil
    inputBuffer resb 12     ; buffer untuk input angka
    operator resb 1         ; 1 byte untuk operator

section .text
    global _start

_start:
    ; Input angka pertama
    mov eax, 4              ; syscall write
    mov ebx, 1              ; stdout
    mov ecx, messageInput1  ; alamat string
    mov edx, input1Len      ; panjang string
    int 0x80

    mov eax, 3              ; syscall read
    mov ebx, 0              ; stdin
    lea ecx, [inputBuffer]  ; gunakan buffer untuk input
    mov edx, 12             ; panjang maksimal input
    int 0x80
    call string_to_int
    mov [operand1], eax     ; simpan hasil konversi ke operand1

    ; Input angka kedua
    mov eax, 4              ; syscall write
    mov ebx, 1              ; stdout
    mov ecx, messageInput2  ; alamat string
    mov edx, input2Len      ; panjang string
    int 0x80

    mov eax, 3              ; syscall read
    mov ebx, 0              ; stdin
    lea ecx, [inputBuffer]  ; gunakan buffer untuk input
    mov edx, 12             ; panjang maksimal input
    int 0x80
    call string_to_int
    mov [operand2], eax     ; simpan hasil konversi ke operand2

    ; Input operator
    mov eax, 4              ; syscall write
    mov ebx, 1              ; stdout
    mov ecx, messageOperator
    mov edx, operatorLen
    int 0x80

    mov eax, 3              ; syscall read
    mov ebx, 0              ; stdin
    lea ecx, [operator]
    mov edx, 1
    int 0x80

    ; Operasi matematika
    mov eax, [operand1]
    mov ebx, [operand2]
    mov cl, [operator]

    cmp cl, '+'
    je jumlah

    cmp cl, '-'
    je kurang

    cmp cl, '*'
    je kali

    cmp cl, '/'
    je bagi

jumlah:
    add eax, ebx
    jmp save_result

kurang:
    sub eax, ebx
    jmp save_result

kali:
    imul eax, ebx
    jmp save_result

bagi:
    xor edx, edx            ; Pastikan edx = 0 untuk div
    div ebx
    jmp save_result

save_result:
    ; Konversi hasil ke string
    call int_to_string

    ; Tampilkan hasil
    mov eax, 4
    mov ebx, 1
    mov ecx, messageHasil
    mov edx, hasilLen
    int 0x80

    lea ecx, [result]
    mov edx, 12
    mov eax, 4
    mov ebx, 1
    int 0x80

    ; Newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

exit:
    mov eax, 1              ; syscall exit
    xor ebx, ebx            ; return 0
    int 0x80

string_to_int:
    xor ebx, ebx            ; bersihkan ebx dan ecx
    xor ecx, ecx            ; ebx untuk menyimpan hasil

next_char:
    mov al, byte [inputBuffer + ecx] ; pindahkan nilai dari buffer perkarakter ke al
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

int_to_string:
    ; Memulai konversi integer di EAX menjadi string di buffer 'result'
    ; Lokasi akhir string diinisialisasi di posisi terakhir buffer

    mov ecx, result + 11    ; Set pointer ke akhir buffer (11 karakter, termasuk null terminator)
    mov byte [ecx], 0       ; Tambahkan null terminator di akhir string
    mov ebx, 10             ; Gunakan basis 10 untuk konversi (desimal)

convert_loop:
    ; Loop untuk membagi angka di EAX dengan 10, menghasilkan digit paling kanan
    xor edx, edx            ; Bersihkan EDX untuk menyimpan sisa pembagian
    div ebx                 ; Bagi EAX dengan 10, hasil ada di EAX, sisa ada di EDX
    dec ecx                 ; Pindahkan pointer buffer ke posisi berikutnya
    add dl, '0'             ; Ubah digit angka menjadi karakter ASCII
    mov [ecx], dl           ; Simpan karakter ASCII di buffer
    test eax, eax           ; Periksa apakah EAX sudah nol (selesai konversi)
    jnz convert_loop        ; Jika belum nol, ulangi proses

    ; Konversi selesai, string yang dihasilkan dimulai dari alamat [ecx]
    ret                     ; Kembali ke caller

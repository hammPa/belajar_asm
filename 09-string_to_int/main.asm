section .data
    messageInput1 db "Masukkan angka pertama: ", 0
    input1Len equ $ - messageInput1

    messageInput2 db "Masukkan angka kedua: ", 0
    input2Len equ $ - messageInput2

    resultMessage db "Hasil penjumlahan : ", 0
    resultLen equ $ - resultMessage

    newline db 0xA

section .text
    global _start

_start:
    ; input pertama
    mov eax, 4              ; syscall write
    mov ebx, 1              ; stdout
    mov ecx, messageInput1  ; alamat string
    mov edx, input1Len      ; panjang string
    int 0x80

    mov eax, 3              ; syscall read
    mov ebx, 0              ; stdin
    lea ecx, [operand1]     ; alamat memory
    mov edx, 4              ; 4 bytes sesuai tipe data
    int 0x80


    ; input kedua
    mov eax, 4              ; syscall write
    mov ebx, 1              ; stdout
    mov ecx, messageInput2  ; alamat string
    mov edx, input2Len      ; panjang string
    int 0x80

    mov eax, 3              ; syscall read
    mov ebx, 0              ; stdin
    lea ecx, [operand2]     ; alamat memory
    mov edx, 4              ; 4 bytes sesuai tipe data
    int 0x80

    ; convert ke int masukkan ke buffer
    lea esi, [operand1]     ; masukkan alamat memroy operand ke esi
    call string_to_int      ; panggil fungsi
    mov [buffer_int1], eax     ; pindahkan hasil return fungsi dari eax ke operand


    lea esi, [operand2]     ; masukkan alamat memroy operand ke esi
    call string_to_int      ; panggil fungsi
    mov [buffer_int2], eax     ; pindahkan hasil return fungsi dari eax ke operand

    ; jumlahkan di eax lalu pindahkan ke result dan tampilkan dalam string
    mov eax, [buffer_int1]
    mov ebx, [buffer_int2]
    add eax, ebx
    add eax, '0'
    mov [result], eax


    ; teks hasil
    mov eax, 4
    mov ebx, 1
    mov ecx, resultMessage
    mov edx, resultLen
    int 0x80

    ; tampilkan
    mov eax, 4              ; syscall write
    mov ebx, 1              ; stdout
    lea ecx, [result]       ; alamat string
    mov edx, 4              ; panjang string
    int 0x80

    ; enter newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80


exit:
    mov eax, 1              ; syscall out
    xor ebx, ebx            ; return 0
    int 0x80


string_to_int:
    xor eax, eax            ; buat eax 0 (hasil akhir)
    xor ebx, ebx            ; buat ebx 0 (temp untuk igit)

convert_loop:
    mov bl, byte [esi]      ; ambil nilai dalam esi dan pindahkan ke bl
    cmp bl, 0xA             ; bandingkan apakah ini newline, jika iya program selesai
    je end_string_to_int
    cmp bl, 0             ; bandingkan apakah ini null, jika iya program selesai
    je end_string_to_int
    sub bl, '0'             ; kurangkan string dengan '0' untuk membuat angka
    imul eax, eax, 10       ; eax = eax * 10
    add eax, ebx            ; geser hasil sebelumnya ke kiri
    inc esi                 ; naikkan pointer esi (pindah ke karakter berikut)
    jmp convert_loop        ; ulangi

end_string_to_int:
    ret




section .bss
    operand1 resd 1         ; operand pertama panjang 32 bit / 4 bytes
    operand2 resd 1         ; operand pertama panjang 32 bit / 4 bytes

    buffer_int1 resd 1      ; operand pertama panjang 32 bit / 4 bytes
    buffer_int2 resd 1      ; operand pertama panjang 32 bit / 4 bytes

    result resd 1 

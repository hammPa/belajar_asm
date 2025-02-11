section .data
    ten dd 10
    newline db 10, 0  ; Newline dengan null-terminator

section .bss
    buffer resb 10    ; Buffer untuk menyimpan string angka

section .text
    global _start

_start:
    mov eax, 10
    mov ecx, 3
    mov ebx, 1

loop_start:
    imul ebx, eax

    dec ecx
    jnz loop_start

    mov eax, ebx
    call int_to_string
    mov ecx, eax      ; Simpan alamat string hasil konversi ke ECX
    call string_length ; Hitung panjang string hasil konversi
    mov edx, eax      ; Simpan panjang string ke EDX untuk syscall

    ; Cetak hasil konversi
    mov eax, 4
    mov ebx, 1
    ; Gunakan alamat string yang dikembalikan oleh int_to_string
    int 0x80

    ; Cetak newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80

int_to_string:
    mov edi, buffer + 9
    mov byte [edi], 0  ; Null terminator

    test eax, eax
    jz zero_case        ; Jika EAX = 0, langsung simpan '0'

convert_loop:
    xor edx, edx        ; Pastikan EDX = 0 sebelum div
    div dword [ten]     ; EAX / 10, sisa ke EDX

    add dl, '0'         ; Ubah digit ke karakter ASCII
    dec edi
    mov [edi], dl       ; Simpan di buffer

    test eax, eax       ; Cek apakah EAX = 0
    jnz convert_loop    ; Jika belum, lanjutkan loop

    mov eax, edi        ; Return alamat string
    ret

zero_case:
    mov byte [edi - 1], '0'
    lea eax, [edi - 1]  ; Return alamat string
    ret

; Fungsi untuk menghitung panjang string (null-terminated)
string_length:
    mov edx, 0
.count_loop:
    cmp byte [ecx + edx], 0
    je .done
    inc edx
    jmp .count_loop
.done:
    mov eax, edx
    ret


; 120 -> eax
; 10 -> ten
; 
; eax / ten = 120 / 10 = 12 -> eax
; sisa = 0 -> edx
; 0 -> 0 + '0' = '0'
; 
; bufferstr = '0'
; 
; 12 -> eax
; eax / ten = 12 / 10 -> 1 -> eax
; sisa  = 2 -> edx
; 2 -> 2 + '0' = '2'
; 
; bufferstr '20'
; 
; 1 = 1 + '0' = '1'
; 
; bufferstr = '120'

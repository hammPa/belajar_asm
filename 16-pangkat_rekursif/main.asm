section .data
    newline db 10, 0
    basis db "Masukkan angka : ", 0
    basis_len equ $ - basis
    pangkat db "Masukkan pangkat : ", 0
    pangkat_len equ $ - pangkat

    result_text db "Hasilnya adalah ", 0
    result_text_len equ $ - result_text

section .bss
    angka1_buffer resb 8
    angka2_buffer resb 8
    hasil resd 1

section .text
    global _start

_start:
    ; Tampilkan teks untuk input angka
    mov eax, 4
    mov ebx, 1
    mov ecx, basis
    mov edx, basis_len
    int 0x80

    ; Baca input angka pertama
    mov eax, 3
    mov ebx, 0
    mov ecx, angka1_buffer
    mov edx, 8
    int 0x80

    ; Konversi string ke integer
    mov esi, angka1_buffer
    call string_to_int
    mov [angka1_buffer], eax  ; Simpan hasil konversi

    ; Tampilkan teks untuk input pangkat
    mov eax, 4
    mov ebx, 1
    mov ecx, pangkat
    mov edx, pangkat_len
    int 0x80

    ; Baca input angka kedua
    mov eax, 3
    mov ebx, 0
    mov ecx, angka2_buffer
    mov edx, 8
    int 0x80

    ; Konversi string ke integer
    mov esi, angka2_buffer
    call string_to_int
    mov [angka2_buffer], eax  ; Simpan hasil konversi

    ; Pemangkatan
    mov eax, dword [angka1_buffer]  ; Basis
    mov ecx, dword [angka2_buffer]  ; Pangkat
    call power                      ; Hitung base^exp
    mov [hasil], eax                ; Simpan hasil

    ; Tampilkan newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Tampilkan teks hasil
    mov eax, 4
    mov ebx, 1
    mov ecx, result_text
    mov edx, result_text_len
    int 0x80

    ; Konversi hasil ke string dan cetak
    mov eax, [hasil]
    call itoa
    mov ecx, eax
    mov edx, 11  ; Panjang maksimal angka
    mov eax, 4
    mov ebx, 1
    int 0x80

    ; Tampilkan newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Keluar dari program
    mov eax, 1
    xor ebx, ebx
    int 0x80

; Konversi string angka ke integer
string_to_int:
    mov eax, 0
convert_stoi:
    movzx ebx, byte [esi]       ; Ambil 1 karakter
    cmp bl, 10                  ; Apakah newline?
    je end_convert_stoi
    sub bl, '0'                 ; Ubah ASCII ke angka
    imul eax, eax, 10           ; Kali 10 (geser tempat desimal)
    add eax, ebx                ; Tambah angka baru
    inc esi
    jmp convert_stoi
end_convert_stoi:
    ret

; Fungsi rekursi untuk pemangkatan (base^exp)
power:
    cmp ecx, 0
    je power_base_case   ; Jika pangkat 0, hasilnya harus 1

    push ecx             ; Simpan nilai pangkat
    push eax             ; Simpan nilai basis
    dec ecx              ; Kurangi pangkat (n - 1)
    call power           ; Rekursi: base^(n-1)
    pop ebx              ; Pulihkan nilai basis
    pop ecx              ; Pulihkan nilai pangkat
    imul eax, ebx        ; Hasil = base * (base^(n-1))
    ret

power_base_case:
    mov eax, 1           ; Jika pangkat 0, hasilnya harus 1
    ret

; Konversi integer ke string ASCII (itoa)
itoa:
    mov edi, hasil    ; Penunjuk ke akhir buffer
    add edi, 11       ; Buffer cukup besar untuk angka 32-bit
    mov byte [edi], 0 ; Null-terminate string
    dec edi
    
    mov ecx, 10       ; Basis desimal
convert_loop:
    xor edx, edx      ; Bersihkan EDX sebelum membagi
    div ecx           ; EAX / 10, hasil di EAX, sisa di EDX
    add dl, '0'       ; Konversi angka ke karakter ASCII
    mov [edi], dl     ; Simpan karakter di buffer
    dec edi           ; Pindah ke kiri di buffer
    test eax, eax     ; Cek apakah EAX sudah nol
    jnz convert_loop  ; Jika belum, lanjutkan
    
    inc edi           ; Geser pointer ke awal string
    mov eax, edi      ; Kembalikan alamat string
    ret

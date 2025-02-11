section .data
    char db 65  ; ASCII 'A'

section .text
    global _start

_start:

print:
    mov eax, 4      ; syscall write
    mov ebx, 1      ; stdout
    mov ecx, char   ; Ambil alamat char
    mov edx, 1      ; Panjang 1 byte
    int 0x80

    movzx esi, byte [char]  ; Ambil nilai dari char (zero-extend)
    inc esi                 ; Tambah 1
    mov [char], esi         ; Simpan kembali

    cmp esi, 91             ; Apakah sudah mencapai 'Z' + 1?
    jl print                ; Jika belum, lanjut cetak

exit:
    mov eax, 1      ; syscall exit
    xor ebx, ebx    ; status 0
    int 0x80

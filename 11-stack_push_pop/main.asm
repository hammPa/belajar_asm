; Stack adalah struktur data LIFO (Last In, First Out) yang digunakan secara luas dalam Assembly untuk menyimpan data sementara, seperti:
; Alamat kembali setelah fungsi selesai.
; Parameter fungsi.
; Data lokal dalam fungsi.
; ESP adalah register yang menyimpan alamat teratas dari stack.


section .data
    var db 42

section .text
    global _start

_start:
    mov eax, 10      ; Simpan 10 di EAX
    push eax         ; Masukkan nilai EAX ke stack
    mov eax, 20      ; Simpan 20 di EAX
    push eax         ; Masukkan nilai EAX ke stack
    pop ebx          ; Ambil nilai teratas stack (20) ke EBX
    pop ecx          ; Ambil nilai berikutnya (10) ke ECX


    mov eax, 1
    xor ebx, ebx
    int 0x80



; Sebelum push eax pertama:

; ESP → alamat kosong (misalnya 0xFFFF)
; 
; Setelah push eax pertama:
; 
; [0xFFFB]: 10   ; (nilai pertama di stack)
; ESP → 0xFFFB
; 
; Setelah push eax kedua:
; 
; [0xFFF7]: 20   ; (nilai kedua di stack)
; [0xFFFB]: 10
; ESP → 0xFFF7






; Sebelum pop ebx:
; 
; [0xFFF7]: 20
; [0xFFFB]: 10
; ESP → 0xFFF7
; 
; Setelah pop ebx:
; 
; EBX = 20
; [0xFFFB]: 10
; ESP → 0xFFFB
; 
; Setelah pop ecx:
; 
;     ECX = 10
;     ESP → 0xFFFF (stack kosong lagi)


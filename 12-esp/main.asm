; Contoh push dan pop:
; 
; push eax      ; ESP otomatis dikurangi 4 byte
; pop eax       ; ESP otomatis ditambah 4 byte
; 
; Manipulasi ESP Langsung:
; 
; sub esp, 4    ; Sama seperti `push` (tapi Anda harus menulis ke alamat manual)
; mov [esp], eax ; Simpan nilai di alamat ESP
; 
; add esp, 4    ; Sama seperti `pop` (tapi Anda tidak mengambil nilai otomatis)


section .data
    var db 42
    buffer db '0', 0
    newline db 10, 0

section .text
    global _start

_start:
    mov eax, 5          ; Simpan nilai 5 di EAX
    push eax            ; Masukkan nilai ke stack
    mov eax, 9          ; Simpan nilai 10 di EAX
    push eax            ; Masukkan nilai ke stack

    mov eax, [esp]      ; ambil nilai teratas dari stack
    add esp, 4          ; hapus nilainya dari stack
    add eax, '0'        ; ubah jadi string
    mov [buffer], eax

    mov eax, 4          ; syscall write
    mov ebx, 1          ; stdout
    lea ecx, [buffer]   ; alamat string
    mov edx, 1          ; panjang string
    int 0x80            ; call kernel


    mov eax, [esp]      ; ambil nilai teratas dari stack
    add esp, 4          ; hapus nilainnya dari stack
    add eax, '0'        ; ubah jadi string
    mov [buffer], eax

    mov eax, 4          ; syscall write
    mov ebx, 1          ; stdout
    lea ecx, [buffer]   ; alamat dari string
    mov edx, 1          ; panjang string
    int 0x80



    sub esp, 4          ; tambah nilai dari stack
    mov eax, 7          ; ini nilainya
    mov [esp], eax      ; pindahkan nilainya

    mov eax, [esp]      ; ambil nilai teratas dari stack
    add esp, 4          ; hapus nilainnya dari stack
    add eax, '0'        ; ubah jadi string
    mov [buffer], eax

    mov eax, 4          ; syscall write
    mov ebx, 1          ; stdout
    lea ecx, [buffer]   ; alamat dari string
    mov edx, 1          ; panjang string
    int 0x80


    ; Menampilkan newline

    mov eax, 4
    mov ebx, 1
    lea ecx, [newline]
    mov edx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80

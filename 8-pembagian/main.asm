section .data
    number db 10
    basis db 10                 ; basis 10
    buffer db '00', 10

section .text
    global _start

_start:
    mov al, [number]           ; eax adalah angka yang akan di bagi dan tempat hasil bagi
    mov cl, [basis]            ; ecx adalah pembagi

    xor edx, edx                ; tempat sisa pembagian, diawal ditetapkan dengan 0

    div ecx                     ; fungsi div akan membagi eax dengan ecx

    add dl, '0'                 ; sisa bagi di dl ubah jadi string
    mov [buffer + 1], dl        ; simpan sisa bagi yang sudah jadi string ke digit terakhir

    add al, '0'                 ; hasil bagi ubah jadi string
    mov [buffer], al            ; hasil bagi yang sudah jadi string di simpan ke digit awal

    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 3
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80

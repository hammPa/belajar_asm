section .data
    messages db "php ", 0, "absurd ", 0, "banget", 10
    lengths db 5, 8, 7
    count db 3

section .text:
    global _start

_start:
    movzx ecx, byte [count]     ; pindahkan nilai dari alamat count ke ecx
    lea esi, [messages]         ; pindahkan alamat messages ke esi
    lea ebx, [lengths]          ; pindahkan alamat dari lengths ke ebx

loop_start:
    push ecx                    ; pindahkan nilai counter di ecx ke stack
    movzx edx, byte [ebx]       ; ambil nilai (panjang per string) dari alamat yang tersimpan di ebx dan pindahkan ke edx
    push ebx                    ; pindahkan alamat lengths dari ebx ke stack
    mov eax, 4
    mov ebx, 1
    mov ecx, esi                ; ambil alamat string dari esi
    int 0x80

    pop ebx                     ; ambil alamat lengths dari stack ke ebx
    pop ecx                     ; ambil nilai counter dari stack ke ecx
    
    add esi, edx                ; naikkan pointer alamat messages dengan panjang string
    add ebx, 1                  ; naikkan pointer alamat lengths
    dec ecx                     ; kurangi counter

    jnz loop_start

exit:
    mov eax, 1                  ; system call out
    xor ebx, ebx                ; return 0
    int 0x80

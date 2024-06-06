// used for lab q3

section .data
    X db 1, 2, 3, 4, 5, 6, 7, 8, 9, 10   ; Input signal
    c db 1, 1, 1, 1, 1                   ; Coefficients (simple averaging filter)
    Y times 10 db 0                      ; Output signal (initialize with 0s)
    N equ 10                             ; Number of input samples
    M equ 5                              ; Number of coefficients

section .bss

section .text
    global _start

_start:
    ; Initialize pointers
    mov esi, X          ; ESI points to X[0]
    mov edi, Y          ; EDI points to Y[0]
    mov ecx, N - M + 1  ; ECX is the loop counter for output samples

main_loop:
    push ecx            ; Save the outer loop counter

    ; Initialize sum to 0
    xor eax, eax        ; EAX will hold the sum

    ; Inner loop to calculate the convolution sum
    mov ebx, c          ; EBX points to c[0]
    mov ecx, M          ; ECX is the loop counter for the coefficients

inner_loop:
    mov al, byte [esi]  ; Load X[n-i] into AL
    mov dl, byte [ebx]  ; Load c[i] into DL
    mul dl              ; AL = AL * DL (unsigned multiplication)
    add eax, ax         ; Add to sum in EAX
    inc esi             ; Move to the next input sample
    inc ebx             ; Move to the next coefficient
    loop inner_loop     ; Repeat for all coefficients

    ; Store the result in Y[n]
    mov byte [edi], al

    ; Update pointers for the next output sample
    pop ecx             ; Restore the outer loop counter
    inc edi             ; Move to the next output sample
    add esi, 1          ; Move to the next input sample
    loop main_loop      ; Repeat for all output samples

    ; Exit program (Linux syscall)
    mov eax, 1          ; Syscall number (sys_exit)
    xor ebx, ebx        ; Exit code 0
    int 0x80            ; Interrupt to invoke syscall

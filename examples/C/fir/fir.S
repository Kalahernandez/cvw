// used for lab q3

.section .data
X: .byte 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
c: .byte 1, 1, 1, 1, 1
Y: .space 10  ; Allocate space for 10 bytes (output array)
N: .equ 10
M: .equ 5

.section .text
.global _start

_start:
    # Initialize pointers
    movl $X, %esi     # ESI points to X[0]
    movl $Y, %edi     # EDI points to Y[0]
    movl $N, %ecx     # ECX is the loop counter for output samples
    subl $M, %ecx
    addl $1, %ecx

main_loop:
    push %ecx         # Save the outer loop counter

    # Initialize sum to 0
    xorl %eax, %eax   # EAX will hold the sum

    # Inner loop to calculate the convolution sum
    movl $c, %ebx     # EBX points to c[0]
    movl $M, %ecx     # ECX is the loop counter for the coefficients

inner_loop:
    movzbl (%esi), %al   # Load X[n-i] into AL (zero-extend to 32 bits)
    movzbl (%ebx), %dl   # Load c[i] into DL (zero-extend to 32 bits)
    mull %dl             # AL = AL * DL (unsigned multiplication)
    addl %eax, %ebx      # Add to sum in EAX
    incl %esi            # Move to the next input sample
    incl %ebx            # Move to the next coefficient
    loop inner_loop      # Repeat for all coefficients

    # Store the result in Y[n]
    movb %al, (%edi)

    # Update pointers for the next output sample
    pop %ecx             # Restore the outer loop counter
    incl %edi            # Move to the next output sample
    addl $1, %esi        # Move to the next input sample
    loop main_loop       # Repeat for all output samples

    # Exit program (Linux syscall)
    movl $1, %eax        # Syscall number (sys_exit)
    xorl %ebx, %ebx      # Exit code 0
    int $0x80            # Interrupt to invoke syscall

    add esi, 1          ; Move to the next input sample
    loop main_loop      ; Repeat for all output samples

    ; Exit program (Linux syscall)
    mov eax, 1          ; Syscall number (sys_exit)
    xor ebx, ebx        ; Exit code 0
    int 0x80            ; Interrupt to invoke syscall

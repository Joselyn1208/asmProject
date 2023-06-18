section .data
    LF equ 0Ah
    NULL equ 0

section .text
    global _readString, _readChar

_readString:
    push rdi      ; Save rdi
    mov ecx, edx  ; Max buffer size
    xor eax, eax  ; Character count (initially 0)

read_loop:
    call _readChar ; Read a character
    cmp al, LF     ; Check if it is a line feed (LF)
    je read_done   ; If so, exit loop
    cmp al, NULL   ; Check if it is end of input
    je read_done   ; If so, exit loop
    mov [rdi], al  ; Store character in buffer
    inc rdi        ; Move to next position in buffer
    inc eax        ; Increment counter
    loop read_loop ; Continue reading until buffer is full

read_done:
    mov byte [rdi], NULL  ; End string with a null character
    pop rdi          ; Restore rdi
    ret

_readChar:
    mov eax, 0       ; SYS_read
    mov edi, 0       ; File descriptor (stdin)
    mov rsi, rdi     ; Buffer destination address
    mov rdx, 1       ; Number of bytes to read
    syscall          ; Invoke system call
    ret
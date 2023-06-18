section .data
    matrix dq 0

section .bss
    matrix_size resb 4

section .text
    global validateMatrixSize
    global allocateMatrixMemory

    extern menu
    extern readInteger

    validateMatrixSize:
        cmp byte [rdi], '0'
        jl validate_fail
        cmp byte [rdi], '9'
        jg validate_fail
        mov eax, dword [rdi]
        cmp eax, 1
        jl validate_fail
        cmp eax, 10
        jg validate_fail
        xor eax, eax  ; Success
        ret

    validate_fail:
        mov eax, -1  ; Failure
        ret

    allocateMatrixMemory:
        shl rdi, 2  ; Multiply size by 4 (since each element is a double word)
        mov rax, rdi
        mov rdi, 0
        mov rsi, rdi
        mov rdx, rdi
        mov r10, 0x22  ; PROT_READ | PROT_WRITE
        mov r8, -1  ; MAP_ANONYMOUS | MAP_PRIVATE
        mov r9, -1  ; File descriptor (unused)
        mov eax, 9  ; SYS_mmap
        syscall
        test rax, rax
        js allocate_fail
        ret

    allocate_fail:
        mov rax, -1
        ret

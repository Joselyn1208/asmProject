section .data
    LF equ 10
    NULL equ 0

    menu_options db "Menu Options:", LF
                 db "1. Calculate Euclidean Distance", LF
                 db "2. Calculate Manhattan Distance", LF
                 db "3. Calculate Mahalanobis Distance", LF
                 db "4. Exit Program", LF
                 db "Enter your choice: ", NULL

section .bss
    matrix resd 1  ; Reserve a double word for the matrix pointer

section .text
    global _start

    extern printString
    extern readInteger
    extern validateMatrixSize
    extern allocateMatrixMemory
    extern display_menu
    extern menu

    _start:
        ; Prompt the user for matrix size
        mov edi, matrix_size_prompt
        call printString
        call readInteger
        mov ecx, eax  ; Use ecx to store the matrix size

        ; Validate matrix size
        mov edi, ecx
        call validateMatrixSize
        cmp eax, 0
        jl exit_program

        ; Allocate memory for the matrix
        mov eax, ecx
        shl eax, 2  ; Multiply size by 4 (since each element is a double word)
        mov edi, eax
        call allocateMatrixMemory
        mov [matrix], eax  ; Save the matrix pointer

        call display_menu

    exit_program:
        ; Exit the program
        mov eax, 1  ; SYS_exit
        xor ebx, ebx  ; Exit status code
        int 0x80

section .rodata
    matrix_size_prompt db "Enter the size of the matrix (1-10): ", NULL

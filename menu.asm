section .data
    LF equ 10
    NULL equ 0

    menu_options db "Menu Options:", LF
                db "1. Calculate Euclidean Distance", LF
                db "2. Calculate Manhattan Distance", LF
                db "3. Calculate Mahalanobis Distance", LF
                db "4. Exit Program", LF
                db "Enter your choice: ", NULL

section .text
    global printString

    printString:
        ; Prologue
        push rbx

        ; Count characters in string
        mov rbx, rdi
        mov rdx, 0
        countStrLoop:
            cmp byte [rbx], NULL
            je countStrDone

            inc rdx
            inc rbx
            jmp countStrLoop

        countStrDone:
            cmp rdx, 0
            je prtDone

        ; Call OS to output string
        mov rax, 1        ; SYS_write
        mov rdi, 1        ; STDOUT
        mov rsi, rdi      ; Address of characters to write
        mov rdx, rdx      ; Count to write, set above
        syscall

        ; String printed, return to calling routine
        prtDone:
            pop rbx
            ret

section .rodata
    menu_option_prompt db "Enter your choice (1-4): ", NULL

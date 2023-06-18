section .data
    LF equ 10
    NULL equ 0
section .text
    global calculateDistance

    extern printString
    extern readCoordinates
    extern euclideanDistance
    extern manhattanDistance
    extern mahalanobisDistance
    extern matrix
    extern menu


    calculateDistance:
        push rbp
        mov rbp, rsp
        sub rsp, 16

        ; Read coordinates from the user
        mov rdi, coordinates_prompt
        call printString
        call readCoordinates

        ; Calculate distance based on user choice
        cmp byte [rdi], '1'
        je calculate_euclidean
        cmp byte [rdi], '2'
        je calculate_manhattan
        cmp byte [rdi], '3'
        je calculate_mahalanobis

    exit_calculate:
        add rsp, 16
        pop rbp
        ret

    calculate_euclidean:
        ; Calculate Euclidean distance
        mov rdi, matrix
        call euclideanDistance
        jmp exit_calculate

    calculate_manhattan:
        ; Calculate Manhattan distance
        mov rdi, matrix
        call manhattanDistance
        jmp exit_calculate

    calculate_mahalanobis:
        ; Calculate Mahalanobis distance
        mov rdi, matrix
        call mahalanobisDistance
        jmp exit_calculate

section .rodata
    coordinates_prompt db "Enter the coordinates (row and column) separated by a space: ", NULL

section .data
    LF equ 10
    NULL equ 0

    distance_prompt db "Distance: ", NULL
    distance_buffer resb 12

section .text
    global euclideanDistance
    global manhattanDistance
    global mahalanobisDistance

    extern menu
    extern printString
    extern readString
    extern matrix
    extern num_to_ascii

    euclideanDistance:
        ; Calculate Euclidean distance between two points
        mov rdi, coordinates_buffer
        mov rsi, matrix
        mov edx, [rsi + rdx * 4]  ; Load element at row rdx
        mov ecx, [rdi]  ; Load X coordinate
        sub ecx, edx
        imul ecx, ecx  ; Square the difference
        mov edx, [rsi + rsi * 4]  ; Load element at row rsi
        mov eax, [rdi + 1]  ; Load Y coordinate
        sub eax, edx
        imul eax, eax  ; Square the difference
        add eax, ecx  ; Sum the squared differences
        call printDistance
        ret

    manhattanDistance:
        ; Calculate Manhattan distance between two points
        mov rdi, coordinates_buffer
        mov rsi, matrix
        mov edx, [rsi + rdx * 4]  ; Load element at row rdx
        mov ecx, [rdi]  ; Load X coordinate
        sub ecx, edx
        cdq
        idiv rbx  ; Divide by 10
        mov edx, [rsi + rsi * 4]  ; Load element at row rsi
        mov eax, [rdi + 1]  ; Load Y coordinate
        sub eax, edx
        cdq
        idiv rbx  ; Divide by 10
        add eax, ecx  ; Sum the absolute differences
        call printDistance
        ret

    mahalanobisDistance:
        ; Calculate Mahalanobis distance between two points
        mov rdi, coordinates_buffer
        mov rsi, matrix
        mov eax, [rsi + rdx * 4]  ; Load element at row rdx
        mov ecx, [rdi]  ; Load X coordinate
        sub ecx, eax
        imul ecx, ecx  ; Square the difference
        mov eax, [rsi + rsi * 4]  ; Load element at row rsi
        mov edx, [rdi + 1]  ; Load Y coordinate
        sub edx, eax
        imul edx, edx  ; Square the difference
        add eax, ecx  ; Sum the squared differences
        mov ecx, [rsi + rdx * 4]  ; Load element at row rdx
        sub ecx, eax
        imul ecx, ecx  ; Square the difference
        call printDistance
        ret

    printDistance:
        ; Print the calculated distance
        push rax
        push rdx

        ; Convert distance to string
        mov rdi, distance_buffer
        call num_to_ascii

        ; Print the distance
        mov rdi, distance_prompt
        call printString
        mov rdi, distance_buffer
        call printString

        pop rdx
        pop rax
        ret

section .bss
    coordinates_buffer resb 4
    
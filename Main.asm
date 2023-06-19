section .data
    matrix_file db "matrix.txt", 0
    buffer times 256 db 0
    menu db "1. Euclidean Distancia", 10, "2. Manhattan Distancia", 10, "3. Mahalanobis Distancia", 10, "Elige: ", 0
    user_input db 0 ; stores the user's input
    enter_data_msg db "Escribe los datos de la matriz (5x5):", 0
    enter_data_msg_len equ $-enter_data_msg
    error_msg db "Invalid input. Please try again.", 0
    error_msg_len equ $-error_msg

section .bss
    matrix resb 25

section .text
    global _start

_start:
    ; Open file to write
    mov eax, 2 ; syscall number for open
    mov edi, matrix_file ; pointer to file name
    xor esi, esi ; file mode (0 is read-only)
    xor edx, edx ; permissions (not used for read-only)
    syscall ; call kernel

    ; Save file descriptor
    mov ebx, eax

    ; Print enter data message
    mov eax, 4 ; syscall number for write
    mov edi, 1 ; file descriptor 1 is stdout
    mov esi, enter_data_msg ; pointer to message
    mov edx, enter_data_msg_len ; message length
    syscall ; call kernel

    ; Loop to get user input and write to file
    mov ecx, matrix ; pointer to matrix buffer
    mov edx, 25 ; number of bytes to read
    call read_matrix_input

    ; Write matrix to file
    mov eax, 1 ; syscall number for write
    mov edi, ebx ; file descriptor
    mov esi, matrix ; pointer to matrix buffer
    mov edx, 25 ; number of bytes to write
    syscall ; call kernel

    ; Close file
    mov eax, 3 ; syscall number for close
    mov edi, ebx ; file descriptor
    syscall ; call kernel

    ; Print menu and get user choice
    call print_menu
    call get_user_input

    ; based on user input, calculate and print the corresponding distance
    cmp al, '1'
    je calculate_euclidean_distance

    cmp al, '2'
    je calculate_manhattan_distance

    cmp al, '3'
    je calculate_mahalanobis_distance

    ; if none of the above, print error message and exit
    jmp exit

calculate_euclidean_distance:
    ; read matrix from file
    mov eax, 2 ; syscall number for open
    mov edi, matrix_file ; pointer to file name
    xor esi, esi ; file mode (0 is read-only)
    xor edx, edx ; permissions (not used for read-only)
    syscall ; call kernel

    ; Save file descriptor
    mov ebx, eax

    ; Read matrix data
    mov eax, 0 ; syscall number for read
    mov edi, ebx ; file descriptor
    mov esi, matrix ; pointer to matrix buffer
    mov edx, 25 ; number of bytes to read
    syscall ; call kernel

    ; Calculate Euclidean distance
    ; Implement your Euclidean distance calculation logic here

    ; Close file
    mov eax, 3 ; syscall number for close
    mov edi, ebx ; file descriptor
    syscall ; call kernel

    jmp exit

calculate_manhattan_distance:
    ; read matrix from file
    mov eax, 2 ; syscall number for open
    mov edi, matrix_file ; pointer to file name
    xor esi, esi ; file mode (0 is read-only)
    xor edx, edx ; permissions (not used for read-only)
    syscall ; call kernel

    ; Save file descriptor
    mov ebx, eax

    ; Read matrix data
    mov eax, 0 ; syscall number for read
    mov edi, ebx ; file descriptor
    mov esi, matrix ; pointer to matrix buffer
    mov edx, 25 ; number of bytes to read
    syscall ; call kernel

    ; Calculate Manhattan distance
    ; Implement your Manhattan distance calculation logic here

    ; Close file
    mov eax, 3 ; syscall number for close
    mov edi, ebx ; file descriptor
    syscall ; call kernel

    jmp exit

calculate_mahalanobis_distance:
    ; read matrix from file
    mov eax, 2 ; syscall number for open
    mov edi, matrix_file ; pointer to file name
    xor esi, esi ; file mode (0 is read-only)
    xor edx, edx ; permissions (not used for read-only)
    syscall ; call kernel

    ; Save file descriptor
    mov ebx, eax

    ; Read matrix data
    mov eax, 0 ; syscall number for read
    mov edi, ebx ; file descriptor
    mov esi, matrix ; pointer to matrix buffer
    mov edx, 25 ; number of bytes to read
    syscall ; call kernel

    ; Calculate Mahalanobis distance
    ; Implement your Mahalanobis distance calculation logic here

    ; Close file
    mov eax, 3 ; syscall number for close
    mov edi, ebx ; file descriptor
    syscall ; call kernel

    jmp exit

exit:
    ; exit program
    mov eax, 1 ; syscall number for exit
    xor ebx, ebx ; exit code
    syscall ; call kernel

; Function to read matrix input from user
read_matrix_input:
    pushad ; save registers

    mov esi, ecx ; pointer to matrix buffer
    mov ecx, edx ; number of bytes to read
    xor eax, eax ; set eax to 0

    read_loop:
        mov ebx, 0 ; file descriptor 0 is stdin
        mov edx, 1 ; read only one byte
        syscall ; call kernel

        ; check for valid input (digits only)
        cmp al, '0'
        jb read_error
        cmp al, '9'
        ja read_error

        ; store digit in matrix buffer
        stosb

        ; check if all bytes have been read
        loop read_loop

    popad ; restore registers
    ret

; Function to print menu
print_menu:
    mov eax, 4 ; syscall number for write
    mov ebx, 1 ; file descriptor 1 is stdout
    mov ecx, menu ; pointer to message
    mov edx, 79 ; message length
    syscall ; call kernel
    ret

; Function to get user input
get_user_input:
    mov eax, 3 ; syscall number for read
    mov ebx, 0 ; file descriptor 0 is stdin
    mov ecx, user_input ; pointer to buffer
    mov edx, 1 ; read only one byte
    syscall ; call kernel
    ret

; Function to print error message
print_error_message:
    mov eax, 4 ; syscall number for write
    mov ebx, 1 ; file descriptor 1 is stdout
    mov ecx, error_msg ; pointer to message
    mov edx, error_msg_len ; message length
    syscall ; call kernel
    ret

read_error:
    call print_error_message
    jmp read_loop

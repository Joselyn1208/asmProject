section .data
    SYS_exit equ 60 
    LF equ 10  
    NULL equ 0 
    newline db LF, NULL
    matrix_file db "matrix.txt", 0
    buffer times 256 db 0
    menu db "1. Euclidean Distancia", 10, "2. Manhattan Distancia", 10, "3. Mahalanobis Distancia", 10, "Elige: ", 0
    user_input db 0 
    enter_data_msg db "Escribe los datos de la matriz (5x5):", 10, 0
    enter_data_msg_len equ $-enter_data_msg
    error_msg db "Invalid input. Please try again.", 10, 0
    error_msg_len equ $-error_msg

section .bss
    matrix resb 25

section .text
    global _start
    _start:
        ; Abrir el archivo en modo lectura
        mov eax, 2 
        mov edi, matrix_file 
        xor esi, esi 
        xor edx, edx 
        syscall 

        ; Guardar el file descriptor
        mov ebx, eax

        ; Imprimir el mensaje para ingresar los datos
        mov eax, 1
        mov edi, 1 
        mov esi, enter_data_msg 
        mov edx, enter_data_msg_len 
        syscall 

        ; Bucle para obtener la entrada del usuario y escribir en el archivo
        mov ecx, matrix 
        mov edx, 25 
        call read_matrix_input

        ; Escribir la matriz en el archivo
        mov eax, 1 
        mov edi, ebx 
        mov esi, matrix 
        mov edx, 25 
        syscall 

        ; Cerrar el archivo
        mov eax, 3 
        mov edi, ebx 
        syscall 

        ; Imprimir el menú y obtener la elección del usuario
        call print_menu
        call get_user_input

        ; En función de la entrada del usuario, calcular e imprimir la distancia correspondiente
        cmp byte [user_input], '1'
        je calculate_euclidean_distance

        cmp byte [user_input], '2'
        je calculate_manhattan_distance

        cmp byte [user_input], '3'
        je calculate_mahalanobis_distance

        ; Si no se selecciona ninguna opción válida, imprimir el mensaje de error y salir
        jmp exit

    ; Done, terminate program.
    exit:
        mov eax, SYS_exit 
        xor edi, edi 
        syscall 

    calculate_euclidean_distance:
        mov ecx, matrix
        mov edx, 25
        call calculate_sum_of_squares
        ; ax ahora contiene la suma de los cuadrados de las distancias
        jmp exit

    calculate_manhattan_distance:
        mov ecx, matrix
        mov edx, 25
        call calculate_sum_of_absolute_differences
        ; ax ahora contiene la suma de las diferencias absolutas
        jmp exit

    calculate_mahalanobis_distance:
        jmp exit

    ; Función para leer la entrada de la matriz del usuario
    read_matrix_input:
        push ebx 
        mov esi, ecx 
        mov ecx, edx 
        xor eax, eax 

    read_loop:
        ; leer primer dígito
        mov edi, 0 
        mov edx, 1 
        mov eax, 3 
        syscall 

        ; revisar si es un dígito válido
        cmp al, '0'
        jb read_error
        cmp al, '9'
        ja check_space

        ; convertir el primer dígito a número y almacenarlo en bl
        sub al, '0'
        mov bl, al

        ; leer siguiente carácter
        mov edi, 0 
        mov edx, 1 
        mov eax, 3 
        syscall 

        ; revisar si es un dígito válido
        cmp al, '0'
        jb store_single_digit
        cmp al, '9'
        ja store_single_digit

        ; si es un dígito válido, multiplicar bl por 10 y sumar el segundo dígito
        sub al, '0'
        imul bl, 10
        add bl, al

        ; leer siguiente carácter
        mov edi, 0 
        mov edx, 1 
        mov eax, 3 
        syscall 

    store_single_digit:
        ; almacenar el número en la matriz
        mov [esi], bl
        inc esi

        ; comprobar si el carácter actual es un espacio o nueva línea
        cmp al, ' '
        je read_loop
        cmp al, 10 ; ascii code for newline
        je read_loop

        jmp read_error

    check_space:
        cmp al, ' '
        je read_loop
        cmp al, 10 ; ascii code for newline
        je read_loop

        jmp read_error


    read_error:
        mov eax, 1 
        mov edi, 1 
        mov esi, error_msg 
        mov edx, error_msg_len 
        syscall 
        jmp exit

    ; Función para imprimir el menú
    print_menu:
        mov eax, 1 
        mov edi, 1 
        mov esi, menu 
        mov edx, 32 
        syscall 
        ret

    ; Función para obtener la entrada del usuario
    get_user_input:
        mov eax, 0 
        mov edi, 0 
        mov esi, user_input 
        mov edx, 1 
        syscall 
        ret

    calculate_sum_of_squares:
        xor eax, eax 
        xor ebx, ebx 
        xor edx, edx
        xor esi, esi

    loop_calc_sum_of_squares:
        cmp edx, 25
        je end_calc_sum_of_squares
        mov al, byte [ecx+edx]
        inc edx
        mov bl, byte [ecx+edx]
        sub al, bl
        imul ax, ax
        add esi, ax
        jmp loop_calc_sum_of_squares

    end_calc_sum_of_squares:
        mov ax, si
        ret

    calculate_sum_of_absolute_differences:
        xor eax, eax 
        xor ebx, ebx 
        xor edx, edx
        xor esi, esi

    loop_calc_sum_of_absolute_differences:
        cmp edx, 25
        je end_calc_sum_of_absolute_differences
        mov al, byte [ecx+edx]
        inc edx
        mov bl, byte [ecx+edx]
        sub al, bl
        call calc_absolute
        add esi, eax
        jmp loop_calc_sum_of_absolute_differences

    end_calc_sum_of_absolute_differences:
        mov ax, si
        ret

    calc_absolute:
        cmp eax, 0
        jge end_abs
        neg eax
    end_abs:
        ret
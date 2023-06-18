section .text
    global readCoordinates
    extern menu
    extern printString
    extern readInteger

    readCoordinates:
        call readString

        ; Parse the coordinates
        mov rdi, coordinates_buffer
        call parseCoordinate
        movzx eax, byte [rdi]
        mov [rdi], al
        add rdi, 2
        call parseCoordinate
        movzx edx, byte [rdi]
        mov [rdi], dl

        ret

    readString:
        mov rdx, 255  ; Tamaño máximo del buffer de entrada
        mov rsi, rsp  ; Puntero al buffer de entrada (en la pila)
        mov rdi, 0    ; Descriptor de archivo de entrada estándar (STDIN)
        mov eax, 0x0  ; Código de llamada al sistema para la lectura (SYS_read)
        syscall

        ; Eliminar el carácter de nueva línea al final de la cadena ingresada
        mov ecx, eax
        dec ecx
        mov bl, byte [rsi + rcx]  ; Último carácter ingresado
        cmp bl, 10  ; Comprobar si es un salto de línea
        jne rs_exit

        ; Reemplazar el carácter de nueva línea con NULL
        mov byte [rsi + rcx], 0

    rs_exit:
        ret

    parseCoordinate:
        xor eax, eax
        xor ecx, ecx

        ; Skip leading spaces
        parse_loop:
            mov al, byte [rdi]
            cmp al, ' '
            je parse_loop_end
            cmp al, 0
            je parse_loop_end
            inc rdi
            jmp parse_loop

        parse_loop_end:
            cmp al, '0'
            jl parse_fail
            cmp al, '9'
            jg parse_fail
            sub al, '0'
            add cl, al
            shl ecx, 8
            ret

    parse_fail:
        mov ecx, -1
        ret

section .bss
    coordinates_buffer resb 4
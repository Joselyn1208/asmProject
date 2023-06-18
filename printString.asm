;Demostracion basica de un ensamblador
;write some instructions
;Note: this file name and write message are
;Adrian Ochoa
;may/16/2023

;*****************************************

section .data

;Define constants

    EXIT_SUCCES     equ 0   ;succesful operation
    SYS_exit        equ 60 ;call code for terminate 

    ;--------
    LF equ 10   ;line feed
    NULL equ 0  ;end of string
    TRUE equ 1
    FALSE equ 0

    STDIN equ 0 ;standard input
    STDOUT equ 1 ;standard output
    STDERR equ 2    ;standard error

    SYS_read equ 0 ;read 
    SYS_write equ 1 ;write
    SYS_open equ 2 ;open file
    SYS_close equ 3 ;close file
    SYS_fork equ 57 ;fork
    SYS_creat equ 85    ;open file/create
    SYS_time equ 201    ;get time

    O_CREATE equ 0x40
    O_TRUNC equ 0x200
    O_APPEND equ 0x400
    O_RONLY equ 000000q ;read only
    O_WRONLY equ 0000001q ;write only
    O_RDWR equ 0000002q ;read and write

    S_IRUSR equ 00400q
    S_IWUSR equ 00200q
    S_IXUSR equ 00100q



    ;________________________________________________________________________________________
    ;Define some strings 
    newline db LF,NULL
    fileDesc dq 0
    header db LF, "File write example"
            db LF,LF,NULL
    filename db "pruW.txt",NULL
    dirWeb db "Santana ijueverga ojala que te viole balderas y te lleves sexto semestre"
          db LF,LF,NULL
    len dq  $-dirWeb-1      

    writeDone db "Write Completed",LF,NULL
    errMsgOpen       db "Error opening file",LF,NULL
    errMsgWrite     db "Error Writting file",LF,NULL
    exito db "Si se pudo",LF,NULL






    ;__________________________Memory storage


section .text
    global _start
    _start:
    ;-----------------------
    ;Display first message
    mov rdi, header 
    call printString

    ;attempt to open file
    ;Use system service
    ;   if error -> eax<0
    ;   if success -> eax=file descriptor number

    openInputFile:
        mov rax,SYS_creat   ;file open/create
        mov rdi, filename  ;filename str
        mov rsi, S_IRUSR | S_IWUSR
        syscall
        cmp ax,0
        jl errorOpen
        mov qword[fileDesc], rax
        mov rdi, exito
        call printString
      
        ;___________________________________________________________
        ;write file 
        ;In this example the characters to write are in a predifined string containing a URL

        ;System service -write
        ;returns
        ;if error ->rax<0
        ;if succes -> rax=actual count characters
        mov rax, SYS_write  ;value=1
        mov rdi, qword[fileDesc]
        mov rsi, dirWeb
        mov rdx, qword[len]
        syscall

        cmp rax,0
        jl errorWrite 

        mov rdi, writeDone 
        call printString
        ;close file
        ;system service -close

        mov rax, SYS_close
        mov rdi, qword[fileDesc]
        syscall
        jmp last

    errorOpen:
        mov rdi, errMsgOpen
        call printString
        jmp last    

    errorWrite:
        mov rdi, errMsgWrite
        call printString
        jmp last



    last:
        mov rax, SYS_exit  ;call code for exit
        mov rdi, EXIT_SUCCES ;Exit program with success
        syscall


;-------------------------------------------------------------------------------------------
;Generic function to display a string to the screen
;String must be NULL terminated
global printString

printString:
    ;prologue
    push rbx

    ;Count characters in string
    mov rbx, rdi
    mov rdx, 0
    countStrLoop:
        cmp byte[rbx], NULL
        je countStrDone

        inc rdx
        inc rbx
        jmp countStrLoop

    countStrDone:
        cmp rdx,0
        je prtDone

    ;______________________________
    ;call OSto output string
    mov rax, SYS_write ;System code for write()
    mov rsi, rdi    ;address of  cahras to write
    mov rdi, STDOUT ;standard out
                        ;RDX = count to write, set above 
    syscall


    ;String printed, return to calling routine- prologue
    prtDone:
        pop rbx
        ret
    ;-------------------------------------------------------------------------------------------


    ;rax sys_read (0)
    ;rdi STDIN (0)
    ;rsi Address of where the store chars
    ;rdx #of chars LF,NULL

.MODEL SMALL
.STACK 100h

EXTRN StartGame:PROC ; game_logic.asm

PUBLIC ShowMainMenu

.CODE
ShowMainMenu PROC
    ; Mostrar titulo del juego
    MOV AH, 09h
    LEA DX, gameTitle
    INT 21h

MenuLoop:
    ; Mostrar menu de opciones
    MOV AH, 09h
    LEA DX, menuOption1
    INT 21h

    MOV AH, 09h
    LEA DX, menuOption2
    INT 21h

    MOV AH, 09h
    LEA DX, chooseMsg
    INT 21h

    ; Leer tecla presionada
    MOV AH, 1
    INT 21h
    MOV BL, AL

    ; Salto de linea
    MOV AH, 09h
    LEA DX, newline
    INT 21h

    ; Evaluar opcion
    CMP BL, '1'
    JE StartGameCall
    CMP BL, '2'
    JE ExitGame

    ; Caso de opcion invalida
    MOV AH, 09h
    LEA DX, invalidMsg
    INT 21h
    JMP MenuLoop

; call al procedimiento para iniciar el juego
    CALL StartGame   

; salir del menu
ExitGame:
    RET

ShowMainMenu ENDP

.DATA
    gameTitle   DB 13,10, '==== BLACKJACK 16-BIT ====',13,10,'$'
    menuOption1 DB '1. Jugar',13,10,'$'
    menuOption2 DB '2. Salir',13,10,'$'
    chooseMsg   DB 13,10,'Seleccione una opcion: $'
    invalidMsg  DB 13,10,'Opcion invalida. Intente nuevamente.$'
    newline     DB 13,10,'$'

END

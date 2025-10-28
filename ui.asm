; ============================================================
; Proyecto: Blackjack - Ensamblador 16 bits
; Archivo : ui.asm
; Descripción : Manejo de interfaz de usuario en modo texto.
;               Pantalla inicial con opciones "Jugar" y "Salir".
; ============================================================

.MODEL SMALL
.STACK 100h

PUBLIC SHOWMAINMENU

.CODE
SHOWMAINMENU PROC
    ; Mostrar título
    MOV AH, 09h
    LEA DX, title
    INT 21h

MenuLoop:
    ; Mostrar opciones
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

    ; Salto de línea
    MOV AH, 09h
    LEA DX, newline
    INT 21h

    ; Evaluar opción
    CMP BL, '1'
    JE StartGame
    CMP BL, '2'
    JE ExitGame

    ; Opción inválida
    MOV AH, 09h
    LEA DX, invalidMsg
    INT 21h
    JMP MenuLoop

StartGame:
    ; Placeholder mientras se conecta la lógica del juego
    MOV AH, 09h
    LEA DX, newline
    INT 21h
    MOV AH, 09h
    LEA DX, msgStart
    INT 21h
    JMP ExitGame

ExitGame:
    RET
ShowMainMenu ENDP

; ------------------------------------------------------------
; Variables (declaradas al final del archivo)
; ------------------------------------------------------------
.DATA
    title       DB 13,10, '==== BLACKJACK 16-BIT ====',13,10,'$'
    menuOption1 DB '1. Jugar',13,10,'$'
    menuOption2 DB '2. Salir',13,10,'$'
    chooseMsg   DB 13,10,'Seleccione una opción: $'
    invalidMsg  DB 13,10,'Opción inválida. Intente nuevamente.$'
    msgStart    DB 'Iniciando partida... (pendiente de implementar)',13,10,'$'
    newline     DB 13,10,'$'

END

.MODEL SMALL
.STACK 100h

EXTRN SHOWMAINMENU:PROC ; ui.asm

.DATA
    exitMsg DB 13,10, 'Gracias por jugar Blackjack 16-bit!',13,10,'$'

.CODE

main PROC
    ; inicializar segmento de datos
    MOV AX, @DATA
    MOV DS, AX

    ; call al menu principal
    CALL SHOWMAINMENU

    ; mensaje de salida
    MOV AH, 09h
    LEA DX, exitMsg
    INT 21h

    ; salir del programa
    MOV AH, 4Ch
    INT 21h
main ENDP

END main

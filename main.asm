; ============================================================
; Proyecto: Blackjack - Ensamblador 16 bits
; Archivo : main.asm
; Descripción : Programa principal. Inicializa segmentos y
;               muestra la pantalla de inicio (UI principal)
; ============================================================

.MODEL SMALL
.STACK 100h

; ------------------------------------------------------------
; Declaración de procedimientos externos
; ------------------------------------------------------------
EXTERN ShowMainMenu:NEAR

.CODE
MAIN PROC
    ; Inicializar segmento de datos
    MOV AX, @DATA
    MOV DS, AX

    ; Llamar a la interfaz inicial  
    CALL ShowMainMenu

    ; Mostrar mensaje de salida
    MOV AH, 09h
    LEA DX, msg_exit
    INT 21h

    ; Finalizar programa
    MOV AH, 4Ch
    INT 21h
MAIN ENDP

; ------------------------------------------------------------
; Variables y mensajes (declaradas al final)
; ------------------------------------------------------------
.DATA
    msg_exit DB 13,10, 'Saliendo del juego...', '$'

END MAIN

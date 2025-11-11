.MODEL SMALL
.STACK 100h

PUBLIC StartGame ; procedimiento publico

.CODE

StartGame PROC
    ; Inicializar variables
    CALL InitGame

    ; Repartir cartas : 2 al jugador y 2 a la máquina
    CALL GetRandomCard
    CBW                  ; extender AL a AX (AX contiene la carta)
    ADD playerScore, AX

    CALL GetRandomCard
    CBW
    ADD playerScore, AX

    CALL GetRandomCard
    CBW
    ADD machineScore, AX

    CALL GetRandomCard
    CBW
    ADD machineScore, AX

    ; Mostrar puntajes iniciales
    MOV AH, 09h
    LEA DX, newline
    INT 21h

    MOV AH, 09h
    LEA DX, msgPlayerScore
    INT 21h
    MOV AX, playerScore
    CALL PrintDec
    MOV AH, 09h
    LEA DX, newline
    INT 21h

    MOV AH, 09h
    LEA DX, msgMachineScore
    INT 21h
    MOV AX, machineScore
    CALL PrintDec
    MOV AH, 09h
    LEA DX, newline
    INT 21h

PlayerLoop:
    ; Si el jugador ya está en bust, terminar (CheckBustPlayer hará exit)
    ; Preguntar acción al jugador
    MOV AH, 09h
    LEA DX, playerPrompt
    INT 21h

    ; Leer tecla
    MOV AH, 01h
    INT 21h
    ; aceptar opcion mayuscula o minuscula (H/h o S/s)
    MOV BL, AL
    CMP BL, 'H'
    JE PlayerHit
    CMP BL, 'h'
    JE PlayerHit
    CMP BL, 'S'
    JE PlayerStand
    CMP BL, 's'
    JE PlayerStand
    ; reiniciar el loop en caso de opción invalida
    JMP PlayerLoop

PlayerHit:
    ; dar carta al jugador
    CALL GetRandomCard
    CBW
    ADD playerScore, AX

    ; mostrar la carta obtenida
    MOV AH, 09h
    LEA DX, msgYouGot
    INT 21h
    MOV AX, AX          ; AX ya contiene la carta por CBW
    CALL PrintDec
    MOV AH, 09h
    LEA DX, newline
    INT 21h

    ; Verificar si jugador se pasó
    CALL CheckBustPlayer

    ; la maquina elige H o S
    CALL MachineDecision
    CMP AL, 1
    JE MachineHitAfterPlayer ;maquina escoge Hit
    ; Si la maquina se planta
    MOV AH, 09h
    LEA DX, msgMachineStands
    INT 21h
    MOV AH, 09h
    LEA DX, newline
    INT 21h

    JMP PlayerLoop   ; volver a preguntar al jugador

PlayerStand:
    ; El jugador se planta y ahora la máquina seguirá tomando decisiones
    MOV AH, 09h
    LEA DX, msgPlayerStand
    INT 21h
    MOV AH, 09h
    LEA DX, newline
    INT 21h

MachineLoopAfterPlayerStand:
    CALL MachineDecision
    CMP AL, 1
    JE MachineHitAfterStand
    ; terminar si la máquina se queda
    MOV AH, 09h
    LEA DX, msgMachineStands
    INT 21h
    MOV AH, 09h
    LEA DX, newline
    INT 21h
    JMP EndGame

MachineHitAfterPlayer:
    ; Maquina pide carta
    CALL GetRandomCard
    CBW
    ADD machineScore, AX

    MOV AH, 09h
    LEA DX, msgMachineGot
    INT 21h
    MOV AX, AX
    CALL PrintDec
    MOV AH, 09h
    LEA DX, newline
    INT 21h

    ; verificar si la máquina se pasó
    CALL CheckBustMachine

    JMP PlayerLoop

MachineHitAfterStand:
    ; maquina pide carta
    CALL GetRandomCard
    CBW
    ADD machineScore, AX

    MOV AH, 09h
    LEA DX, msgMachineGot
    INT 21h
    MOV AX, AX
    CALL PrintDec
    MOV AH, 09h
    LEA DX, newline
    INT 21h

    CALL CheckBustMachine

    ; vuelve a decidir si no se pasó
    JMP MachineLoopAfterPlayerStand

EndGame:
    ; mostrar resultados y determinar el ganador
    MOV AH, 09h
    LEA DX, newline
    INT 21h

    MOV AH, 09h
    LEA DX, msgFinalPlayer
    INT 21h
    MOV AX, playerScore
    CALL PrintDec
    MOV AH, 09h
    LEA DX, newline
    INT 21h

    MOV AH, 09h
    LEA DX, msgFinalMachine
    INT 21h
    MOV AX, machineScore
    CALL PrintDec
    MOV AH, 09h
    LEA DX, newline
    INT 21h

    CALL DetermineWinner

    RET
StartGame ENDP

InitGame PROC
    MOV word ptr playerScore, 0
    MOV word ptr machineScore, 0 ; Reiniciar los puntajes
    RET
InitGame ENDP

; carta random entre 1 y 11
GetRandomCard PROC
    ; Usamos INT 21h AH=2Ch para obtener el tiempo (DL = hundredths/seconds según DOS)
    MOV AH, 2Ch
    INT 21h
    MOV AL, DL          ; base pseudoaleatoria
    XOR AH, AH
    MOV BL, 11
    DIV BL              ; AX / BL -> AL = quotient ; AH = remainder
    MOV AL, AH          ; remainder 0..10
    INC AL              ; rango 1..11
    CBW                 ; extender AL a AX (para sumas en word)
    RET
GetRandomCard ENDP

; ------------------------------------------------------------
; MachineDecision - devuelve en AL 0=Stand, 1=Hit
; ------------------------------------------------------------
MachineDecision PROC
    MOV AH, 2Ch
    INT 21h
    MOV AL, DL
    AND AL, 1           ; usar bit menos significativo
    RET
MachineDecision ENDP

;check si el jugador se pasó de 21
CheckBustPlayer PROC
    MOV AX, playerScore
    CMP AX, 21
    JG PlayerBust
    RET
PlayerBust:
    MOV AH, 09h
    LEA DX, playerBustMsg
    INT 21h
    MOV AH, 4Ch
    MOV AL, 01         ; código de salida 1 = jugador perdió
    INT 21h
CheckBustPlayer ENDP

; check si la máquina se pasó de 21
CheckBustMachine PROC
    MOV AX, machineScore
    CMP AX, 21
    JG MachineBust
    RET
MachineBust:
    MOV AH, 09h
    LEA DX, machineBustMsg
    INT 21h
    MOV AH, 4Ch
    MOV AL, 00         ; código de salida 0 = máquina perdió -> jugador gana
    INT 21h
CheckBustMachine ENDP

;determinar ganador
DetermineWinner PROC
    MOV AX, playerScore
    MOV BX, machineScore

    ; empate si ambos puntajes son iguales
    CMP AX, BX
    JE ShowDraw

    ; Obtener distancia a 21 (abs(21 - score))
    ; CALC playerDiff = 21 - AX
    MOV CX, 21
    SUB CX, AX         ; CX = 21 - playerScore (puede ser negativo if >21, but busts handled before)
    ; CALC machineDiff = 21 - BX -> store in DX
    MOV DX, 21
    SUB DX, BX

    ; Ambos CX and DX are non-negative due to bust checks
    CMP CX, DX
    JB PlayerCloser   ; if playerDiff < machineDiff -> player closer
    JA MachineCloser
    JMP ShowDraw

PlayerCloser:
    MOV AH, 09h
    LEA DX, playerWinsMsg
    INT 21h
    RET

MachineCloser:
    MOV AH, 09h
    LEA DX, machineWinsMsg
    INT 21h
    RET

ShowDraw:
    MOV AH, 09h
    LEA DX, drawMsg
    INT 21h
    RET
DetermineWinner ENDP

; ------------------------------------------------------------
; PrintDec - imprime en base decimal el valor de AX (0..99+)
;           (manejo básico para valores pequeños)
; Entrada: AX = número
; Salida: imprime dígitos en pantalla (INT 21h AH=02h)
; ------------------------------------------------------------
PrintDec PROC
    PUSH BX
    PUSH CX
    PUSH DX

    MOV BX, 10
    XOR DX, DX
    ; Dividir AX / 10 -> quotient in AL, remainder in AH for DIV r8
    DIV BL         ; AX / BL -> AL=quotient, AH=remainder
    CMP AL, 0
    JZ PrintUnitOnly

    ; Imprimir decenas (AL)
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02h
    INT 21h

    ; Imprimir unidades (AH)
    MOV DL, AH
    ADD DL, '0'
    MOV AH, 02h
    INT 21h

    JMP PrintDecDone

PrintUnitOnly:
    ; remainder is in AH, quotient 0 -> AH holds original number
    MOV DL, AH
    ADD DL, '0'
    MOV AH, 02h
    INT 21h

PrintDecDone:
    POP DX
    POP CX
    POP BX
    RET
PrintDec ENDP

.DATA
    playerScore      DW 0
    machineScore     DW 0

    playerPrompt     DB 13,10, 'Presiona H para Hit o S para Stand: $',13,10,'$'
    newline          DB 13,10, '$'
    msgYouGot        DB 'Obtuviste: $'
    msgMachineGot    DB 'Maquina obtuvo: $'
    msgMachineStands DB 'La maquina se planta.$'
    msgPlayerStand   DB 'Te plantas. Turno de la maquina.$'
    msgPlayerScore   DB 'Puntos del jugador: $'
    msgMachineScore  DB 'Puntos de la maquina: $'
    msgFinalPlayer   DB 'Puntaje final jugador: $'
    msgFinalMachine  DB 'Puntaje final maquina: $'

    playerBustMsg    DB 13,10, 'Te pasaste de 21. Pierdes!$',13,10,'$'
    machineBustMsg   DB 13,10, 'La maquina se paso de 21. Ganas!$',13,10,'$'
    playerWinsMsg    DB 13,10, 'Ganaste!$',13,10,'$'
    machineWinsMsg   DB 13,10, 'Perdiste!$',13,10,'$'
    drawMsg          DB 13,10, 'Empate!$',13,10,'$'

END

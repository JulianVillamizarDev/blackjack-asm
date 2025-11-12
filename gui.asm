.model small
.stack 100h

.data
; Textos
msgHola      db 'Hola Mundo!',0
msgPantalla2 db 'Esto es una nueva pantalla',0

; Botones pantalla principal
msgBtn1 db '[0] Mostrar mensaje',0
msgBtn2 db '[2] Cambiar color',0
msgBtn3 db '[3] Nueva pantalla',0
msgSalir db '[ESC] Salir',0

; Botones pantalla secundaria
msgBtn1_P2 db '[1] Mostrar mensaje nuevo',0
msgBtn2_P2 db '[2] Volver a la pantalla principal',0

; Variable global
colorTexto db 1Eh        ; color inicial: amarillo sobre azul
pantallaActual db 1      ; 1 = principal, 2 = secundaria

.code
main proc
    mov ax, @data
    mov ds, ax

    ; Iniciar modo texto VGA
    mov ax, 0003h
    int 10h

    ; Puntero al segmento de video
    mov ax, 0B800h
    mov es, ax

    ; Dibujar interfaz inicial
    call DibujarPantallaPrincipal

PrincipalLoop:
    mov ah, 0
    int 16h              ; Leer tecla

    cmp al, 27           ; ESC -> salir
    je Salir

    mov bl, pantallaActual
    cmp bl, 1
    je PantallaPrincipalInput
    cmp bl, 2
    je PantallaSecundariaInput
    jmp PrincipalLoop

; --------------------------------------------------
; Entrada en la pantalla principal
; --------------------------------------------------
PantallaPrincipalInput:
    cmp ah, 0  
    int 16h
              ; (asegurar que usamos AL)
    cmp al, '0'
    je MostrarHola
    cmp al, '2'
    je CambiarColor
    cmp al, '3'
    je CambiarAPantalla2
    jmp PrincipalLoop

; --------------------------------------------------
; Entrada en la pantalla secundaria
; --------------------------------------------------
PantallaSecundariaInput:
    cmp ah, 0  
    int 16h
    
    cmp al, '1'
    je MostrarMensajePantalla2
    cmp al, '2'
    je VolverPantallaPrincipal
    jmp PrincipalLoop

; --------------------------------------------------
; Acciones de la pantalla principal
; --------------------------------------------------
MostrarHola:
    call MostrarMensajeHola
    jmp PrincipalLoop

CambiarColor:
    call AlternarColor
    call DibujarPantallaPrincipal
    jmp PrincipalLoop

CambiarAPantalla2:
    mov pantallaActual, 2
    call DibujarPantalla2
    jmp PrincipalLoop

; --------------------------------------------------
; Acciones de la pantalla secundaria
; --------------------------------------------------
MostrarMensajePantalla2:
    call MostrarMensajePantalla2Proc
    jmp PrincipalLoop

VolverPantallaPrincipal:
    mov pantallaActual, 1
    call DibujarPantallaPrincipal
    jmp PrincipalLoop

; --------------------------------------------------
; Salir del programa
; --------------------------------------------------
Salir:
    mov ah, 4Ch
    int 21h

; ==================================================
; ============ SUBRUTINAS ==========================
; ==================================================
main endp
; --- Pantalla Principal ---
DibujarPantallaPrincipal proc
    call LimpiarPantalla
    call EscribirBoton1
    call EscribirBoton2
    call EscribirBoton3
    call EscribirSalir
    ret
DibujarPantallaPrincipal endp

; --- Pantalla Secundaria ---
DibujarPantalla2 proc
    call LimpiarPantalla
    call EscribirBoton1_P2
    call EscribirBoton2_P2
    ret
DibujarPantalla2 endp

; --------------------------------------------------
; Subrutinas de botones
; --------------------------------------------------
EscribirBoton1 proc
    mov si, offset msgBtn1
    mov di, (10 * 160) + (30 * 2)
    call EscribirCadena
    ret
EscribirBoton1 endp

EscribirBoton2 proc
    mov si, offset msgBtn2
    mov di, (12 * 160) + (30 * 2)
    call EscribirCadena
    ret
EscribirBoton2 endp

EscribirBoton3 proc
    mov si, offset msgBtn3
    mov di, (14 * 160) + (30 * 2)
    call EscribirCadena
    ret
EscribirBoton3 endp

EscribirSalir proc
    mov si, offset msgSalir
    mov di, (16 * 160) + (30 * 2)
    call EscribirCadena
    ret
EscribirSalir endp

; --- Pantalla 2 botones ---
EscribirBoton1_P2 proc
    mov si, offset msgBtn1_P2
    mov di, (10 * 160) + (25 * 2)
    call EscribirCadena
    ret
EscribirBoton1_P2 endp

EscribirBoton2_P2 proc
    mov si, offset msgBtn2_P2
    mov di, (12 * 160) + (25 * 2)
    call EscribirCadena
    ret
EscribirBoton2_P2 endp

; --------------------------------------------------
; Subrutina: MostrarMensajeHola
; --------------------------------------------------
MostrarMensajeHola proc
    mov si, offset msgHola
    mov di, (8 * 160) + (33 * 2)
    call EscribirCadena
    ret
MostrarMensajeHola endp

; --------------------------------------------------
; Subrutina: MostrarMensajePantalla2Proc
; --------------------------------------------------
MostrarMensajePantalla2Proc proc
    mov si, offset msgPantalla2
    mov di, (8 * 160) + (28 * 2)
    call EscribirCadena
    ret
MostrarMensajePantalla2Proc endp

; --------------------------------------------------
; Subrutina: AlternarColor (rojo <-> azul)
; --------------------------------------------------
AlternarColor proc
    mov al, colorTexto
    cmp al, 1Eh      ; azul?
    je CambiarARojo
    cmp al, 0Ch      ; rojo?
    je CambiarAAzul

CambiarAAzul:
    mov byte ptr colorTexto, 1Eh
    ret
CambiarARojo:
    mov byte ptr colorTexto, 0Ch
    ret
AlternarColor endp

; --------------------------------------------------
; Subrutina: LimpiarPantalla
; --------------------------------------------------
LimpiarPantalla proc
    mov ax, 0B800h
    mov es, ax
    mov di, 0
    mov cx, 2000
    mov ax, 0720h       ; espacio blanco sobre negro
    rep stosw
    ret
LimpiarPantalla endp

; --------------------------------------------------
; Subrutina: EscribirCadena
; Entrada: DS:SI -> texto, ES:DI -> posición, colorTexto
; --------------------------------------------------
EscribirCadena proc
NextChar:
    lodsb
    cmp al, 0
    je Done
    mov ah, colorTexto
    stosw
    jmp NextChar
Done:
    ret
EscribirCadena endp

end main
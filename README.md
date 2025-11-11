# Blackjack

---

## Estructura del proyecto

```
Blackjack
│
├── main.asm 
├── ui.asm           ; Interfaz  (menú principal)
├── game_logic.asm   ; Lógica principal del juego
└── README.md        ; Guía de ejecución
```

---

## Requisitos

- **DOSBox**
- **MASM611**
- **VS code (O otro editor de código :P)**


## Ejecución

### 1. Compilar los archivos ASM

Ejecuta los siguientes comandos uno por uno:

```dos
ML **\main.asm
ML **\ui.asm
ML **\game_logic.asm
```

Esto generará tres archivos .OBJ y .EXE correspondientes a cada módulo.

---

### 2. Enlazar los archivos

```dos
LINK main.obj ui.obj game_logic.obj, blackjack.exe
```

Esto generará el archivo `BLACKJACK.EXE`.

---

### 3. Ejecutar el juego

```dos
blackjack.exe
```

## Autor
**Julian Eduardo Villamizar Cruz** 

;***********************************************************
; PONG! para MSX 1
; Version 0.7 Beta
; ASM Z80 MSX
; BOOT del programa
; (c) 2015 Cesar Rincon Nadal
; http://www.nightfoxandco.com
;***********************************************************





;***********************************************************
; Directivas para el compilador
;***********************************************************

; ----------------------------------------------------------
; Area de datos (Variables) [PAGE 3] $C000
; ----------------------------------------------------------

.INCLUDE "inc/variables.asm"



; ----------------------------------------------------------
; Otras directivas
; ----------------------------------------------------------

.PAGE 1					; Selecciona la pagina 1 [$4000] (Codigo del programa)
.BIOS					; Nombres de las llamadas a BIOS
.ROM					; Se creara el binario en formato ROM de hasta 32kb
.START PROGRAM_START_ADDRESS		; Indicale al compilador donde empieza el programa
.db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0	; 12 ceros para completar la cabecera de la ROM



;***********************************************************
; Programa
;***********************************************************

PROGRAM_START_ADDRESS:

	; ----------------------------------------------------------
	; Punto de incicio
	; ----------------------------------------------------------

	.SEARCH			; Busca un punto de inicio valido


	; ----------------------------------------------------------
	; Ejecuta el programa
	; ----------------------------------------------------------

	; Ejecuta el programa
	jp MAIN

	; Punto final del programa
	ret


	; ----------------------------------------------------------
	; Definiciones
	; ----------------------------------------------------------

	.INCLUDE "inc/defines.asm"


	; ----------------------------------------------------------
	; Codigo principal
	; ----------------------------------------------------------

	; Archivo principal
	.INCLUDE "inc/main.asm"

	; Motor del juego
	.INCLUDE "inc/pong_core.asm"

	; Gestion del Player A
	.INCLUDE "inc/pong_player_a.asm"

	; Gestion del Player 2 [Jugador]
	.INCLUDE "inc/pong_player_b.asm"

	; Gestion del Player 2 [CPU]
	.INCLUDE "inc/pong_player_cpu.asm"

	; Gestion de la Bola
	.INCLUDE "inc/pong_ball.asm"

	; Gestion de los Sprites
	.INCLUDE "inc/pong_sprites.asm"

	; Gestion del marcador
	.INCLUDE "inc/pong_score.asm"

	; Gestion de los sonidos
	.INCLUDE "inc/pong_sound.asm"

	; Game Over
	.INCLUDE "inc/pong_game_over.asm"


	; ----------------------------------------------------------
	; Subrutinas genericas
	; ----------------------------------------------------------

	; Inicializacion de variables
	.INCLUDE "inc/init_vars.asm"

	; Descompresion de datos RLE
	.INCLUDE "inc/rle.asm"

	; Gestion y acceso a las funciones graficas
	.INCLUDE "inc/screen.asm"

	; Gestion y acceso a las funciones del PSG
	.INCLUDE "inc/psg.asm"

	; Gestion y acceso a las funciones del teclado
	.INCLUDE "inc/keyboard.asm"

	; Gestion de carga de las imagenes
	.INCLUDE "inc/img_load.asm"

	; Gestion de carga de los sprites
	.INCLUDE "inc/spr_load.asm"



	; ----------------------------------------------------------
	; Datos del programa
	; ----------------------------------------------------------

	; Fondos

	; Imagen del Titulo [2332 bytes]
	.INCLUDE "data/title.asm"

	; Imagen de "como jugar" [1954 bytes]
	.INCLUDE "data/howto.asm"

	; Imagen de fondo "PONG" [218 bytes]
	.INCLUDE "data/pongbg.asm"

	; Player 1 Wins [2921 bytes]
	.INCLUDE "data/p1wins.asm"

	; Player 2 Wins [2905 bytes]
	.INCLUDE "data/p2wins.asm"

	; Cpu Wins [2662 bytes]
	.INCLUDE "data/cpuwins.asm"


	; Sprites

	; Sprites "PONG" [18 bytes]
	.INCLUDE "data/pongspr.asm"

	; Numeros
	.INCLUDE "data/pongnumbers.asm"






;***********************************************************
; FIN
;***********************************************************
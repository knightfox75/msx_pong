;***********************************************************
; Definicion de variables
; ASM Z80 MSX
;***********************************************************



; --------------------------------------------------------------
; Declara las variables	del sistema	[VARIABLE]	[BYTES]
; --------------------------------------------------------------

; Almacena las variables en la pagina 3 (Comentar si no es una ROM)
.PAGE 3


; -----------------------------------------------------------------------
;	Teclas
;	STATE	[TEMP]	[PRESS]	[HELD]
;	BIT	  2	   1	  0
; -----------------------------------------------------------------------

KB_ESC:		ds	1		; Tecla ESC
KB_SPACE:	ds	1		; Tecla ESPACIO
KB_UP:		ds	1		; Tecla UP
KB_DOWN:	ds	1		; Tecla DOWN
KB_LEFT:	ds	1		; Tecla LEFT
KB_RIGHT:	ds	1		; Tecla RIGHT
KB_Q:		ds	1		; Tecla Q
KB_A:		ds	1		; Tecla A
KB_1:		ds	1		; Tecla 1
KB_2:		ds	1		; Tecla 2



; -----------------------------------------------------------------------
;	Joysticks
;	STATE	[TEMP]	[PRESS]	[HELD]
;	BIT	  2	   1	  0
; -----------------------------------------------------------------------

JOY1_UP:	ds	1		; Joystick 1 Arriba
JOY1_DOWN:	ds	1		; Joystick 1 Abajo
JOY1_LEFT:	ds	1		; Joystick 1 Izquierda
JOY1_RIGHT:	ds	1		; Joystick 1 Derecha
JOY1_TG1:	ds	1		; Joystick 1 Tigger 1
JOY1_TG2:	ds	1		; Joystick 1 Tigger 2

JOY2_UP:	ds	1		; Joystick 2 Arriba
JOY2_DOWN:	ds	1		; Joystick 2 Abajo
JOY2_LEFT:	ds	1		; Joystick 2 Izquierda
JOY2_RIGHT:	ds	1		; Joystick 2 Derecha
JOY2_TG1:	ds	1		; Joystick 2 Tigger 1
JOY2_TG2:	ds	1		; Joystick 2 Tigger 2




; Gestion de la descompresion RLE
RLE_NORMAL_SIZE:	ds	2
RLE_COMPRESSED_SIZE:	ds	2
RLE_POINTER:		ds	2
; Buffer de RAM
RAM_BUFFER:	ds	2048




; --------------------------------------------------------------
; Declara las variables	del programa	[VARIABLE]	[BYTES]
; --------------------------------------------------------------

; Maquina de estados
ST:			ds	1	; Estado actual de la maquina de estado
NEXT_ST:		ds	1	; Siguiente estado de la maquina de estados

; Guarda los parametros del sprite
; Estructura
;	[INFO]    [SPR0]    [SPR1]    [SPR2]
;	2 bytes   4 bytes   4 bytes   4 bytes
;
;	[INFO] = [POS Y] [POS X]
;	[SPRx] = [POS Y] [POS X] [GFX nº] [COLOR]

SPR_PLAYER_A:		ds	18	; Sprite del player A [INFO + 4 sprites]
SPR_PLAYER_B:		ds	18	; Sprite del player B [INFO + 4 sprites]
SPR_BALL:		ds	4	; Sprite de la bola [INFO + 1 sprite]

; Variables de control
BALL_SPD_X:		ds	1	; Velocidad bola [x]
BALL_SPD_Y:		ds	1	; Velocidad bola [y]
BALL_P1_ZONE:		ds	1	; La bola esta entra las coordenadas del player A
BALL_P2_ZONE:		ds	1	; La bola esta entra las coordenadas del player B
SCORE_A:		ds	1	; Puntuacion player A
SCORE_B:		ds	1	; Puntuacion player B
PLAYER_SERVE:		ds	1	; Que jugador saca?
PLAYER_B_CONTROL:	ds	1	; Quien controla al player 2? (0 = IA, 1 = P2)
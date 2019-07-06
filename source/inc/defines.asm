;***********************************************************
; Definicion de constantes
; ASM Z80 MSX
;***********************************************************




; --------------------------------------------------------------
; Constantes del Sistema
; --------------------------------------------------------------

; ----------------------------------------------------------
; Definiciones para la VRAM
; ----------------------------------------------------------

CHRTBL		.EQU	$0000	; Tabla de caracteres (pattern)
NAMTBL		.EQU	$1800	; Tabla de nombres (mapa)
CLRTBL		.EQU	$2000	; Tabla del color de los caracteres (paleta)

SPRATR		.EQU	$1B00	; Tabla de los atributos de los sprites
SPRTBL		.EQU	$3800	; Tabla de Sprites

COLOR_ADDR	.EQU	$F3E9	; Direccion del Color






; --------------------------------------------------------------
; Declara las variables	del programa
; --------------------------------------------------------------

PLAYER_SPEED	.EQU	$0004		; Velocidad de desplazamiento del player
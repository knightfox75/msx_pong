;***********************************************************
; Inicializacion de variables
; ASM Z80 MSX
;***********************************************************



; ----------------------------------------------------------
; Inicializa las variables
; ----------------------------------------------------------

INIT_VARIABLES:

	; Fuerza a que A sea 0
	xor a

	; Teclas
	ld [KB_ESC], a
	ld [KB_SPACE], a
	ld [KB_UP], a
	ld [KB_DOWN], a
	ld [KB_LEFT], a
	ld [KB_RIGHT], a
	ld [KB_Q], a
	ld [KB_A], a
	ld [KB_1], a
	ld [KB_2], a

	; Joysticks
	ld [JOY1_UP], a
	ld [JOY1_DOWN], a
	ld [JOY1_LEFT], a
	ld [JOY1_RIGHT], a
	ld [JOY1_TG1], a
	ld [JOY1_TG2], a

	ld [JOY2_UP], a
	ld [JOY2_DOWN], a
	ld [JOY2_LEFT], a
	ld [JOY2_RIGHT], a
	ld [JOY2_TG1], a
	ld [JOY2_TG2], a

	

	ret
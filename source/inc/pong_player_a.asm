;***********************************************************
; PONG! para MSX 1
; ASM Z80 MSX
; Player A
; (c) 2015 Cesar Rincon Nadal
; http://www.nightfoxandco.com
;***********************************************************





; ----------------------------------------------------------
; Mueve al PLAYER A
; ----------------------------------------------------------

MOVE_PLAYER_A:

	; Si se pulsa arriba
	ld a, [KB_Q]			; Tecla Q
	and $01				; Detecta "KEY HELD"
	call nz, MOVE_PLAYER_A_UP	; Mueve el player "ARRIBA"

	ld a, [JOY1_UP]			; Joy 1 UP
	and $01				; Detecta "KEY HELD"
	call nz, MOVE_PLAYER_A_UP	; Mueve el player "ARRIBA"

	; Si se pulsa abajo
	ld a, [KB_A]			; Tecla A
	and $01				; Detecta "KEY HELD"
	call nz, MOVE_PLAYER_A_DOWN	; Mueve el player "ABAJO"

	; Si se pulsa abajo
	ld a, [JOY1_DOWN]		; Joy 1 DOWN
	and $01				; Detecta "KEY HELD"
	call nz, MOVE_PLAYER_A_DOWN	; Mueve el player "ABAJO"

	; Sal de la rutina
	ret



	; Mueve el player Arriba
	MOVE_PLAYER_A_UP:

		ld hl, SPR_PLAYER_A		; Datos del Sprite del player
		ld a, [hl]			; Coordenada Y
		sub a, PLAYER_SPEED		; resta a la coordenada
		ld b, a				; backup de la coordenada

		sub a, 8			; Verifica si has rebasado el limite superior			
		jr nc, PLAYER_A_UP_NOFIX	; Si no se ha superado el limite, continua

		ld b, 7				; Si se ha superado, ajusta la posicion

		PLAYER_A_UP_NOFIX:
			ld [hl], b		; y guardala
			ret


	; Mueve el player Arriba
	MOVE_PLAYER_A_DOWN:

		ld hl, SPR_PLAYER_A	; Datos del Sprite del player
		ld a, [hl]		; Coordenada Y
		add a, PLAYER_SPEED	; suma a la coordenada
		ld b, a			; backup de la coordenada

		add a, 104			; Verifica si has superado el limite inferior ((256 - 192) + 8 + 32)

		jr nc, PLAYER_A_DOWN_NOFIX	; Si no se ha superado el limite, continua

		ld b, 151			; Si se ha superado, ajusta la posicion (191 - 8 - 32)

		PLAYER_A_DOWN_NOFIX:
			ld [hl], b		; y guardala
			ret
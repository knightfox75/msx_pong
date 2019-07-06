;***********************************************************
; PONG! para MSX 1
; ASM Z80 MSX
; Player B [Jugador]
; (c) 2015 Cesar Rincon Nadal
; http://www.nightfoxandco.com
;***********************************************************





; ----------------------------------------------------------
; Mueve al PLAYER B
; ----------------------------------------------------------

MOVE_PLAYER_B:

	; Si se pulsa arriba
	ld a, [KB_UP]			; Tecla UP
	and $01				; Detecta "KEY HELD"
	call nz, MOVE_PLAYER_B_UP	; Mueve el player "ARRIBA"

	ld a, [JOY2_UP]			; Joy 2 UP
	and $01				; Detecta "KEY HELD"
	call nz, MOVE_PLAYER_B_UP	; Mueve el player "ARRIBA"

	; Si se pulsa abajo
	ld a, [KB_DOWN]			; Tecla DOWN
	and $01				; Detecta "KEY HELD"
	call nz, MOVE_PLAYER_B_DOWN	; Mueve el player "ABAJO"

	ld a, [JOY2_DOWN]		; Joy 2 DOWN
	and $01				; Detecta "KEY HELD"
	call nz, MOVE_PLAYER_B_DOWN	; Mueve el player "ABAJO"

	; Sal de la rutina
	ret


	; Mueve el player Arriba
	MOVE_PLAYER_B_UP:

		ld hl, SPR_PLAYER_B		; Datos del Sprite del player
		ld a, [hl]			; Coordenada Y
		sub a, PLAYER_SPEED		; resta a la coordenada
		ld b, a				; backup de la coordenada

		sub 8				; Verifica si has rebasado el limite superior			
		jr nc, PLAYER_B_UP_NOFIX	; Si no se ha superado el limite, continua

		ld b, 7				; Si se ha superado, ajusta la posicion

		PLAYER_B_UP_NOFIX:
			ld [hl], b		; y guardala
			ret


	; Mueve el player Arriba
	MOVE_PLAYER_B_DOWN:

		ld hl, SPR_PLAYER_B		; Datos del Sprite del player
		ld a, [hl]			; Coordenada Y
		add a, PLAYER_SPEED		; suma a la coordenada
		ld b, a				; backup de la coordenada

		add 104				; Verifica si has superado el limite inferior ((256 - 192) + 8 + 32)

		jr nc, PLAYER_B_DOWN_NOFIX	; Si no se ha superado el limite, continua

		ld b, 151			; Si se ha superado, ajusta la posicion (191 - 8 - 32)

		PLAYER_B_DOWN_NOFIX:
			ld [hl], b		; y guardala
			ret
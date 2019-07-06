;***********************************************************
; PONG! para MSX 1
; ASM Z80 MSX
; Player B [CPU]
; (c) 2015 Cesar Rincon Nadal
; http://www.nightfoxandco.com
;***********************************************************





; ----------------------------------------------------------
; Mueve al PLAYER B [CPU]
; ----------------------------------------------------------

MOVE_PLAYER_CPU:

	; Lee la velocidad X de la bola
	ld a, [BALL_SPD_X]		; Carga la velocidad
	and 128				; Obten el signo
	jp nz, MOVE_PLAYER_CPU_EXIT	; Si es NEGATIVO, salta

	; Ajusta la distancia de reaccion (posicion X de la bola)
	ld hl, SPR_BALL + 1
	ld a, [hl]
	cp 127		; Punto en el escenario en el que reaccionara la IA
	jp c, MOVE_PLAYER_CPU_EXIT
	jp z, MOVE_PLAYER_CPU_EXIT

	; Lee la posicion de la Bola [B]
	ld hl, SPR_BALL
	ld b, [hl]

	; Lee la posicion de la pala [C]
	ld hl, SPR_PLAYER_B
	ld c, [hl]

	; Calcula los centros de los sprites
	ld a, b
	add 4
	ld b, a
	ld a, c
	add 16
	ld c, a

	; Esta por encima, sube
	ld a, c
	sub a, b
	jr c, MOVE_PLAYER_CPU_NO_UP		; Si no esta por encima, salta (resultado negativo)
	cp 8					; Distancia para actuar
	jr c, MOVE_PLAYER_CPU_NO_UP		; Si no esta la distancia especificada por encima...
	jr z, MOVE_PLAYER_CPU_NO_UP
	call MOVE_PLAYER_CPU_UP
	jr MOVE_PLAYER_CPU_EXIT
	MOVE_PLAYER_CPU_NO_UP:

	; Esta por debajo, baja
	ld a, b
	sub a, c
	jr c, MOVE_PLAYER_CPU_NO_DOWN		; Si no esta por debajo, salta (resultado negativo)
	cp 8					; Distancia para actuar
	jr c, MOVE_PLAYER_CPU_NO_DOWN		; Si no esta la distancia especificada por encima...
	jr z, MOVE_PLAYER_CPU_NO_DOWN
	call MOVE_PLAYER_CPU_DOWN
	MOVE_PLAYER_CPU_NO_DOWN:

	; Sal de la rutina
	MOVE_PLAYER_CPU_EXIT:
	ret


	; Mueve el player Arriba
	MOVE_PLAYER_CPU_UP:

		ld hl, SPR_PLAYER_B		; Datos del Sprite del player
		ld a, [hl]			; Coordenada Y
		sub a, PLAYER_SPEED		; resta a la coordenada
		ld b, a				; backup de la coordenada

		sub 8				; Verifica si has rebasado el limite superior			
		jr nc, PLAYER_CPU_UP_NOFIX	; Si no se ha superado el limite, continua

		ld b, 7				; Si se ha superado, ajusta la posicion

		PLAYER_CPU_UP_NOFIX:
			ld [hl], b		; y guardala
			ret


	; Mueve el player Arriba
	MOVE_PLAYER_CPU_DOWN:

		ld hl, SPR_PLAYER_B		; Datos del Sprite del player
		ld a, [hl]			; Coordenada Y
		add a, PLAYER_SPEED		; suma a la coordenada
		ld b, a				; backup de la coordenada

		add 104				; Verifica si has superado el limite inferior ((256 - 192) + 8 + 32)
		jr nc, PLAYER_CPU_DOWN_NOFIX	; Si no se ha superado el limite, continua

		ld b, 151			; Si se ha superado, ajusta la posicion (191 - 8 - 32)

		PLAYER_CPU_DOWN_NOFIX:
			ld [hl], b		; y guardala
			ret
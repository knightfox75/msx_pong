;***********************************************************
; PONG! para MSX 1
; ASM Z80 MSX
; Ball
; (c) 2015 Cesar Rincon Nadal
; http://www.nightfoxandco.com
;***********************************************************





; ----------------------------------------------------------
; Mueve a la bola
; [BC]	Velocidades	B = SPD X	C = SPD Y
; [DE]	Posiciones	D = POS X	E = POS Y
; ----------------------------------------------------------

MOVE_BALL:

	; Verifica si la bola esta en zona de colision de los players
	call BALL_PLAYERS_COLLISIONS

	; Lee los parametros actuales
	ld a, [BALL_SPD_X]		; Velocidad X [B]
	ld b, a

	ld hl, SPR_BALL			; Sprite de la bola
	ld e, [hl]			; Posicion Y [E]
	inc hl
	ld d, [hl]			; Posicion X [D]

	; Desplazamiento sobre la X
	ld a, b				; Verifica si la velocidad es positiva o negativa
	and 128				; Mira el estado del ultimo bit
	jr z, MOVE_BALL_X_ADD
	jr MOVE_BALL_X_SUB

	; Suma al desplazamiento X
	MOVE_BALL_X_ADD:
		ld a, d				; Posicion X
		add a, b			; Suma
		jr c, MOVE_BALL_X_EXIT_RIGHT	; Si te has pasado de largo
		ld d, a				; Guarda la posicion calculada
		ld a, [BALL_P2_ZONE]		; Si no esta en zona de colision con el player
		cp 0
		jr z, MOVE_BALL_X_OUT_RIGHT	; Rutina de salida de la pantalla

		; Si la bola impacta con el player...
		MOVE_BALL_X_PLAYER_RIGHT:
			ld a, d				; Recupera de la posicion
			add 24				; Verifica si has superado el limite del player
			jr nc, MOVE_BALL_Y		; Si no es necesario el ajuste, continua
			ld d, 231			; Ajusta la posicion de la bola
			set 7, b			; Pon el signo de la velocidad a (-)

			; Si hay colision, calcula el angulo de rebote
			push de				; Guarda los registros DE
			ld hl, SPR_PLAYER_B		; Posicion del Player B
			ld a, [hl]
			ld d, a
			call BALL_NEW_Y_SPEED		; Calcula el nuevo angulo de la pelota
			pop de				; Recupera los registros DE

			call SOUND_PING			; Sonido de impacto
			jr MOVE_BALL_Y			; Y salta a la verificacion de la Y

		; Si la bola sale por el lado derecho
		MOVE_BALL_X_OUT_RIGHT:
			ld a, d				; Recupera de la posicion
			add 8				; Verifica si has alcanzado el limite derecho
			jr nc, MOVE_BALL_Y		; Si no es necesario el ajuste, continua

			; La bola se ha pasado de largo por el lado derecho
			MOVE_BALL_X_EXIT_RIGHT:
				ld d, 248			; Nueva posicion
				ld a, 2				; Indica que se le ha marcado un punto al jugador 2
				ld [PLAYER_SERVE], a
				ld [NEXT_ST], a			; Siguiente estado de la maquina [2]
				jr MOVE_BALL_Y			; Y salta a la verificacion de la Y

	; Resta al desplazamiento X
	MOVE_BALL_X_SUB:
		push bc				; Guarda las velocidades
		ld a, b
		and 127				; Quita el signo
		ld b, a
		ld a, d				; Posicion X
		sub a, b			; Resta
		pop bc				; Recupera las velocidades
		jr c, MOVE_BALL_X_EXIT_LEFT	; Si te has pasado de largo
		ld d, a				; Guarda la posicion calculada
		ld a, [BALL_P1_ZONE]		; Si esta en zona de colision con el player
		cp 0
		jr z, MOVE_BALL_X_OUT_LEFT	; Rutina de salida de la pantalla

		; Si la bola impacta con el player...
		MOVE_BALL_X_PLAYER_LEFT:
			ld a, d				; Recupera de la posicion
			sub 16				; Verifica si has superado el limite del player
			jr nc, MOVE_BALL_Y		; Si no es necesario el ajuste, continua
			ld d, 15			; Ajusta la posicion de la bola
			res 7, b			; Pon el signo de la velocidad a (+)

			; Si hay colision, calcula el angulo de rebote
			push de				; Guarda los registros DE
			ld hl, SPR_PLAYER_A		; Posicion del Player B
			ld a, [hl]
			ld d, a
			call BALL_NEW_Y_SPEED		; Calcula el nuevo angulo de la pelota
			pop de				; Recupera los registros DE

			call SOUND_PING			; Sonido de impacto
			jr MOVE_BALL_Y			; Y salta a la verificacion de la Y


		; Si la bola sale por el lado derecho
		MOVE_BALL_X_OUT_LEFT:
			ld a, d			; Recupera de la posicion
			sub 1			; Verifica si has alcanzado el limite derecho
			jr nc, MOVE_BALL_Y	; Si no es necesario el ajuste, continua

			; La bola se ha pasado de largo por el lado izquierda
			MOVE_BALL_X_EXIT_LEFT:
				ld d, 0			; Nueva posicion
				ld a, 1			; Indica que se le ha marcado un punto al jugador 1
				ld [PLAYER_SERVE], a
				ld a, 2
				ld [NEXT_ST], a		; Siguiente estado de la maquina [2]
			


	; Desplazamiento sobre la Y
	MOVE_BALL_Y:
	ld a, [BALL_SPD_Y]		; Lee la velocidad Y de la bola
	ld c, a
	and 128				; Mira el estado del ultimo bit
	jr z, MOVE_BALL_Y_ADD
	jr MOVE_BALL_Y_SUB

	; Suma al desplazamiento Y
	MOVE_BALL_Y_ADD:
		ld a, e				; Posicion Y
		add a, c			; Suma
		jr c, MOVE_BALL_ADJUST_BOTTOM	; Si te has pasado del limite...
		ld e, a				; Backup de la posicion
		add 80				; Verifica si has alcanzado el limite inferior
		jr nc, MOVE_BALL_UPDATE		; Si no es necesario el ajuste, continua
		
		; Ajusta la posicion Y abajo
		MOVE_BALL_ADJUST_BOTTOM:
			ld e, 175		; Nueva posicion
			set 7, c		; Pon el signo de la velocidad a (-)
			call SOUND_PONG		; Sonido de impacto
			jr MOVE_BALL_UPDATE	; Si no es necesario el ajuste, continua

	; Resta al desplazamiento Y
	MOVE_BALL_Y_SUB:
		push bc				; Guarda las velocidades
		ld a, c
		and 127				; Quita el signo
		ld c, a
		ld a, e				; Posicion Y
		sub a, c			; Resta
		pop bc				; Recupera las velocidades
		jr c, MOVE_BALL_ADJUST_TOP	; Si te has pasado del limite...
		ld e, a				; Backup de la posicion
		sub 8				; Verifica si has alcanzado el limite superior
		jr nc, MOVE_BALL_UPDATE		; Si no es necesario el ajuste, continua

		; Ajusta la posicion Y arriba
		MOVE_BALL_ADJUST_TOP:
			ld e, 7			; Nueva posicion
			res 7, c		; Pon el signo de la velocidad a (+)
			call SOUND_PONG		; Sonido de impacto


	; Actualiza los datos de la Bola
	MOVE_BALL_UPDATE:

		ld a, b				; Velocidad X [B]
		ld [BALL_SPD_X], a
		ld a, c				; Velocidad Y [C]
		ld [BALL_SPD_Y], a

		ld hl, SPR_BALL			; Sprite de la bola
		ld [hl], e			; Posicion Y [E]
		inc hl
		ld [hl], d			; Posicion X [D]


	; Sal de la rutina
	ret



; ----------------------------------------------------------
; Verifica si la bola esta entre alguna de las palas
; ----------------------------------------------------------

BALL_PLAYERS_COLLISIONS:

	; Lectura de datos
	ld hl, SPR_PLAYER_A		; Posicion Y del Player A
	ld a, [hl]
	ld b, a

	ld hl, SPR_PLAYER_B		; Posicion Y del Player B
	ld a, [hl]
	ld c, a

	ld hl, SPR_BALL			; Posicion Y de la Bola
	ld a, [hl]
	ld d, a

	; Verifica si la Y de la bola esta entre la Y del Player A y la Y + 32
	ld a, 0
	ld [BALL_P1_ZONE], a		; Sin colision

	ld a, d
	add 8				; Compensa el tamaño de la bola
	cp a, b				; if A > B
	jr c, PL1_OUT_ZONE		; C is RESET 
	jr z, PL1_OUT_ZONE		; Z is RESET

	ld a, b				; Sumale 32 a la coordenada del player
	add 32
	ld b, a
	ld a, d
	cp a, b				; if A < B
	jr nc, PL1_OUT_ZONE		; C is SET
	jr z, PL1_OUT_ZONE		; Z is RESET

	ld a, 255
	ld [BALL_P1_ZONE], a		; Registra la colision


	; No esta en la zona de colision del player 1
	PL1_OUT_ZONE:



	; Verifica si la Y de la bola esta entre la Y del Player B y la Y + 32
	ld a, 0
	ld [BALL_P2_ZONE], a		; Sin colision

	ld a, d
	add 8				; Compensa el tamaño de la bola
	cp a, c				; if A > B
	jr c, PL2_OUT_ZONE		; C is RESET 
	jr z, PL2_OUT_ZONE		; Z is RESET

	ld a, c				; Sumale 32 a la coordenada del player
	add 32
	ld c, a
	ld a, d
	cp a, c				; if A < B
	jr nc, PL2_OUT_ZONE		; C is SET
	jr z, PL2_OUT_ZONE		; Z is RESET

	ld a, 255
	ld [BALL_P2_ZONE], a

	; No esta en la zona de colision del player 1
	PL2_OUT_ZONE:

	; Sal de la rutina
	ret


; ----------------------------------------------------------
; Calcula el nuevo angulo de rebote
; [DE] Valores a comparar
; D = Y del player en el que ha impactado
; E = Y de la pelota
; ----------------------------------------------------------

BALL_NEW_Y_SPEED:

	; Primera verificacion (+24)
	ld a, d			; Carga la posicion del player
	add 24			; Suma 24 a la posicion del player
	ld d, a			; Guarda el punto a verificar
	ld a, 6			; Velocidad Y +6
	ld [BALL_SPD_Y], a 	; Guarda la velocidad
	ld a, e			; Lee la posicion de la pelota
	cp a, d			; if A > E
	jr c, BALL_NEW_Y_ST20	; C is RESET 
	jr z, BALL_NEW_Y_ST20	; Z is RESET
	ret			; si no, vuelve

	; Segunda verificacion (+20)
	BALL_NEW_Y_ST20:
	ld a, d			; Carga la posicion del player
	sub 4			; Suma 20 a la posicion del player (restando 4 a la posicion anterior)
	ld d, a			; Guarda el punto a verificar
	ld a, 4			; Velocidad Y +4
	ld [BALL_SPD_Y], a 	; Guarda la velocidad
	ld a, e			; Lee la posicion de la pelota
	cp a, d			; if A > E
	jr c, BALL_NEW_Y_ST16	; C is RESET 
	jr z, BALL_NEW_Y_ST16	; Z is RESET
	ret			; si no, vuelve

	; Tercera verificacion (+16)
	BALL_NEW_Y_ST16:
	ld a, d			; Carga la posicion del player
	sub 4			; Suma 16 a la posicion del player (restando 4 a la posicion anterior)
	ld d, a			; Guarda el punto a verificar
	ld a, 2			; Velocidad Y +2
	ld [BALL_SPD_Y], a 	; Guarda la velocidad
	ld a, e			; Lee la posicion de la pelota
	cp a, d			; if A > E
	jr c, BALL_NEW_Y_ST12	; C is RESET 
	jr z, BALL_NEW_Y_ST12	; Z is RESET
	ret			; si no, vuelve

	; Tercera verificacion (+12)
	BALL_NEW_Y_ST12:
	ld a, d			; Carga la posicion del player
	sub 4			; Suma 12 a la posicion del player (restando 4 a la posicion anterior)
	ld d, a			; Guarda el punto a verificar
	ld a, 1			; Velocidad Y +1
	ld [BALL_SPD_Y], a 	; Guarda la velocidad
	ld a, e			; Lee la posicion de la pelota
	cp a, d			; if A > E
	jr c, BALL_NEW_Y_ST8	; C is RESET 
	jr z, BALL_NEW_Y_ST8	; Z is RESET
	ret			; si no, vuelve

	; Tercera verificacion (+8)
	BALL_NEW_Y_ST8:
	ld a, d			; Carga la posicion del player
	sub 4			; Suma 8 a la posicion del player (restando 4 a la posicion anterior)
	ld d, a			; Guarda el punto a verificar
	ld a, 1			; Velocidad Y -1
	set 7, a		; Signo negativo
	ld [BALL_SPD_Y], a 	; Guarda la velocidad
	ld a, e			; Lee la posicion de la pelota
	cp a, d			; if A > E
	jr c, BALL_NEW_Y_ST4	; C is RESET 
	jr z, BALL_NEW_Y_ST4	; Z is RESET
	ret			; si no, vuelve

	; Cuarta verificacion (+4)
	BALL_NEW_Y_ST4:
	ld a, d			; Carga la posicion del player
	sub 4			; Suma 4 a la posicion del player (restando 4 a la posicion anterior)
	ld d, a			; Guarda el punto a verificar
	ld a, 2			; Velocidad Y -2
	set 7, a		; Signo negativo
	ld [BALL_SPD_Y], a 	; Guarda la velocidad
	ld a, e			; Lee la posicion de la pelota
	cp a, d			; if A > E
	jr c, BALL_NEW_Y_ST0	; C is RESET 
	jr z, BALL_NEW_Y_ST0	; Z is RESET
	ret			; si no, vuelve

	; Cuarta verificacion (+0)
	BALL_NEW_Y_ST0:
	ld a, d				; Carga la posicion del player
	sub 4				; Suma 0 a la posicion del player (restando 4 a la posicion anterior)
	ld d, a				; Guarda el punto a verificar
	ld a, 4				; Velocidad Y -4
	set 7, a			; Signo negativo
	ld [BALL_SPD_Y], a 		; Guarda la velocidad
	ld a, e				; Lee la posicion de la pelota
	cp a, d				; if A > E
	jr c, BALL_NEW_Y_STLAST	; C is RESET 
	jr z, BALL_NEW_Y_STLAST		; Z is RESET
	ret				; si no, vuelve

	; Si has llegado a este punto, es que has impactado con el extremo superior
	BALL_NEW_Y_STLAST:
	ld a, 6			; Velocidad Y -6
	set 7, a		; Signo negativo
	ld [BALL_SPD_Y], a 	; Guarda la velocidad
	ret			; Vuelve
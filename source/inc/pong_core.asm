;***********************************************************
; PONG! para MSX 1
; ASM Z80 MSX
; Nucleo del juego
; (c) 2015 Cesar Rincon Nadal
; http://www.nightfoxandco.com
;***********************************************************



; ----------------------------------------------------------
; Codigo principal del PONG
; ----------------------------------------------------------

PONG_CORE:

	call PONG_INIT		; Inicializa el programa


	; Loop principal
	PONG_CORE_LOOP:
		

		call READ_KEYS			; Lee el teclado

		call READ_JOY1			; Y los puertos de JoyStick
		call READ_JOY2


		; Maquina de estados
		ld a, [ST]

		; Si el estado es "PRESS SPACE"
		cp 0
		jp z, PONG_STATE_PRESS_SPACE

		; Si el estado es "GAMEPLAY"
		cp 1
		jp z, PONG_STATE_GAMEPLAY

		; Si el estado es "POINT"
		cp 2
		jp z, PONG_STATE_POINT

		; Si el estado es "NEXT POINT"
		cp 3
		jp z, PONG_STATE_NEXT_POINT



		; Update de la maquina de estados
		PONG_CORE_UPDATE:

		call SOUND_CHANNEL_A		; Actualiza el sonido

		call PONG_SPRITES_UPDATE	; Actualiza los sprites

		ld a, [NEXT_ST]			; Actualiza el estado
		ld [ST], a

		; Si se pulsa ESC, vuelve al titulo
		ld a, [KB_ESC]			; Tecla ESC
		and $02				; Detecta "KEY DOWN"
		jr nz, PONG_CORE_EXIT		; Vuelve al titulo

		halt				; Espera al sincronismo del VDP

		jp PONG_CORE_LOOP		; Ejecuta el bucle
	



	; Vuelve al menu
	PONG_CORE_EXIT:
		call SOUND_KILL_ALL	; Elimina cualquier sonido
		jp MAIN_TITLE		; Vuelvel al menu



; ----------------------------------------------------------
; Inicializa el codigo
; ----------------------------------------------------------

PONG_INIT:

	call INIT_SCREEN_MODE_2		; Inicializa el modo de pantalla

	; Inicializa las variables
	xor a					; A = 0

	ld [BALL_P1_ZONE], a			; Flag de verificacion de colision
	ld [BALL_P1_ZONE], a

	ld [SCORE_A], a				; Puntuacion
	ld [SCORE_B], a

	ld [ST], a				; Maquina de estados
	ld [NEXT_ST], a

	ld a, 1
	ld [PLAYER_SERVE], a			; Jugador que saca

	ld a, 4					; Velocidad de la bola
	ld [BALL_SPD_X], a
	ld a, 2
	ld [BALL_SPD_Y], a



	; Carga la imagen de fondo
	ld hl, PONGBG_IMAGE			; Apunta a la direccion de la imagen
	call LOAD_IMAGE_RLE			; Llama a la rutina de carga

	; Crea y posiciona los sprites
	call PONG_CREATE_SPRITES

	; Marcadores
	ld a, 1
	call SCORE_UPDATE
	ld a, 2
	call SCORE_UPDATE

	ret					; Sal de la subrutina



; ----------------------------------------------------------
; PONG! State:	PRESS SPACE
; ----------------------------------------------------------

PONG_STATE_PRESS_SPACE:

	; Mueve a los players
	call MOVE_PLAYER_A		; Mueve al jugador A

	; Control IA?
	ld a, [PLAYER_B_CONTROL]
	cp 0
	call z, MOVE_PLAYER_CPU
	
	; Control Jugador 2?
	ld a, [PLAYER_B_CONTROL]
	cp 1
	call z, MOVE_PLAYER_B



	; Mueve la bola delante del jugador que saca
	ld a, [PLAYER_SERVE]
	cp 1
	jp z, PLAYER_A_SERVE


	; Saca el jugador B
		ld a, 4					; Velocidad de la bola
		set 7, a
		ld [BALL_SPD_X], a
		ld a, 2
		ld [BALL_SPD_Y], a
		ld hl, SPR_PLAYER_B	; Coordenadas del player
		ld c, [hl]		; Y
		inc hl
		ld b, [hl]		; X
		ld hl, SPR_BALL		; Coordenada Y de la bola
		ld a, c			; Coge la Y del player y sumale 12
		add a, 12
		ld [hl], a		; Asignasela a la bola
		inc hl
		ld a, b			; Coordenada X de la bola y restale 24
		sub a, 24
		ld [hl], a		; Asignasela a la bola

		ld a, [JOY2_TG1]		; Si se pulsa el boton 1 del Joy 2, saca
		and $02				; Detecta "KEY DOWN"
		jp nz, SERVE_NOW		; Saca ya

		jp WAIT_FOR_PRESS_SPACE


	; Saca el jugador A
	PLAYER_A_SERVE:
		ld a, 4					; Velocidad de la bola
		ld [BALL_SPD_X], a
		ld a, 2
		ld [BALL_SPD_Y], a
		ld hl, SPR_PLAYER_A	; Coordenadas del player
		ld c, [hl]		; Y
		inc hl
		ld b, [hl]		; X
		ld hl, SPR_BALL		; Coordenada Y de la bola
		ld a, c			; Coge la Y del player y sumale 12
		add a, 12
		ld [hl], a		; Asignasela a la bola
		inc hl
		ld a, b			; Coordenada X de la bola y sumale 24
		add a, 24
		ld [hl], a		; Asignasela a la bola

		ld a, [JOY1_TG1]		; Si se pulsa el boton 1 del Joy 1, saca
		and $02				; Detecta "KEY DOWN"
		jp nz, SERVE_NOW		; Saca ya



	; Si se ha pulsado la tecla espacio...
	WAIT_FOR_PRESS_SPACE:
	ld a, [KB_SPACE]		; Tecla ESPACIO
	and $02				; Detecta "KEY DOWN"
	jp nz, SERVE_NOW		; Saca ya

	; Vuelve a la maquina de estados
	jp PONG_CORE_UPDATE

	; Si se ha pulsado espacio, cambia el estado a GAMEPLAY
	SERVE_NOW:
	ld a, 1
	ld [NEXT_ST], a
	jp PONG_CORE_UPDATE



; ----------------------------------------------------------
; PONG! State:	GAMEPLAY
; ----------------------------------------------------------

PONG_STATE_GAMEPLAY:

	; Mueve al jugador A
	call MOVE_PLAYER_A

	; Control IA?
	ld a, [PLAYER_B_CONTROL]
	cp 0
	call z, MOVE_PLAYER_CPU
	
	; Control Jugador 2?
	ld a, [PLAYER_B_CONTROL]
	cp 1
	call z, MOVE_PLAYER_B

	; Mueve la BOLA
	call MOVE_BALL

	; Vuelve al update de la maquina de estados
	jp PONG_CORE_UPDATE



; ----------------------------------------------------------
; PONG! State:	POINT
; ----------------------------------------------------------

PONG_STATE_POINT:

	; Actualiza los marcadores
	ld a, [PLAYER_SERVE]
	cp 1
	jp nz, PLAYER_ADD_POINT_A

	
	; Dale un punto al jugador B
	ld a, [SCORE_B]			; Lee la puntuacion actual
	inc a				; Suma 1
	ld [SCORE_B], a			; Guarda la puntuacion
	ld a, 2				; Y actualiza los graficos del marcador
	call SCORE_UPDATE
	jr PONG_STATE_POINT_EXIT


	; Dale un punto al jugador A
	PLAYER_ADD_POINT_A:
	ld a, [SCORE_A]			; Lee la puntuacion actual
	inc a				; Suma 1
	ld [SCORE_A], a			; Guarda la puntuacion
	ld a, 1				; Y actualiza los graficos del marcador
	call SCORE_UPDATE
	

	; Cambia el estado a NEXT POINT
	PONG_STATE_POINT_EXIT:
	ld a, 3
	ld [NEXT_ST], a
	jp PONG_CORE_UPDATE



; ----------------------------------------------------------
; PONG! State:	NEXT POINT
; ----------------------------------------------------------

PONG_STATE_NEXT_POINT:

	; Si se ha pulsado la tecla espacio...
	ld a, [KB_SPACE]		; Tecla ESPACIO
	and $02				; Detecta "KEY DOWN"
	jp nz, ANALYZE_POINT		; Analiza el punto
	; Si se ha pulsado el Boton 1 del Joy 1...
	ld a, [JOY1_TG1]		; Boton 1
	and $02				; Detecta "KEY DOWN"
	jp nz, ANALYZE_POINT		; Analiza el punto
	; Si se ha pulsado el Boton 1 del Joy 2...
	ld a, [JOY2_TG1]		; Boton 1
	and $02				; Detecta "KEY DOWN"
	jp nz, ANALYZE_POINT		; Analiza el punto


	; Vuelve a la maquina de estados
	jp PONG_CORE_UPDATE



	; Analisis del punto
	ANALYZE_POINT:

	; Analisis puntos Player A
	ld a, [SCORE_A]
	cp 9
	jp z, GAME_OVER			; Si se ha llegado a 9 puntos, pantalla de game over


	; Analisis puntos Player B
	ld a, [SCORE_B]
	cp 9
	jp z, GAME_OVER			; Si se ha llegado a 9 puntos, pantalla de game over


	; Si se ha pulsado espacio y nadie ha ganado...
	; reinicia la posicion de ambos players
	ld hl, SPR_PLAYER_A
	ld [hl], 80		; POS Y
	ld hl, SPR_PLAYER_B
	ld [hl], 80		; POS Y
	
	; Indica a la maquina de estados que debe volver al inicio
	ld a, 0
	ld [NEXT_ST], a
	jp PONG_CORE_UPDATE

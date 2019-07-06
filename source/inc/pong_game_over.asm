;***********************************************************
; PONG! para MSX 1
; ASM Z80 MSX
; Game Over
; (c) 2015 Cesar Rincon Nadal
; http://www.nightfoxandco.com
;***********************************************************



; ----------------------------------------------------------
; Muestra la pantalla de Game Over
; ----------------------------------------------------------

GAME_OVER:

	; Limpia la cola de sonidos
	call SOUND_KILL_ALL

	; Inicializa la pantalla
	call INIT_SCREEN_MODE_2

	; Si ha ganado el jugador 1
	ld a, [SCORE_A]
	cp 9
	jr nz, GAME_OVER_PLAYER_2

	; Apunta a la pantalla de victoria del player 1
	ld hl, P1WINS_IMAGE
	jr LOAD_GAME_OVER_SCREEN

	; Ha ganado el jugador 2
	GAME_OVER_PLAYER_2:
	ld a, [PLAYER_B_CONTROL]
	cp 1
	jr nz, GAME_OVER_CPU

	; Apunta a la pantalla de victoria del player 2
	ld hl, P2WINS_IMAGE
	jr LOAD_GAME_OVER_SCREEN

	; Ha ganado la CPU
	GAME_OVER_CPU:
	; Apunta a la pantalla de victoria de la CPU
	ld hl, CPUWINS_IMAGE

	; Carga la imagen correspondiente al ganador
	LOAD_GAME_OVER_SCREEN:
	call LOAD_IMAGE_RLE			; Llama a la rutina de carga


	; Bucle de espera a la salida a la pantalla del titulo
	GAME_OVER_LOOP:

		; Lee el teclado
		call READ_KEYS
		call READ_JOY1
		call READ_JOY2

		; Si se ha pulsado la tecla espacio...
		ld a, [KB_SPACE]	; Tecla ESPACIO
		and $02			; Detecta "KEY DOWN"
		jp nz, MAIN_TITLE	; Pantalla del titulo

		; Si se pulsa ESC...
		ld a, [KB_ESC]		; Tecla ESC
		and $02			; Detecta "KEY DOWN"
		jp nz, MAIN_TITLE	; Vuelve al titulo

		; Si se ha pulsado el Boton 1 del Joy 1...
		ld a, [JOY1_TG1]		; Boton 1
		and $02				; Detecta "KEY DOWN"
		jp nz, MAIN_TITLE	; Vuelve al titulo

		; Si se ha pulsado el Boton 1 del Joy 2...
		ld a, [JOY2_TG1]		; Boton 1
		and $02				; Detecta "KEY DOWN"
		jp nz, MAIN_TITLE	; Vuelve al titulo


		; Loop
		jp GAME_OVER_LOOP
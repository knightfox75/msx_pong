;***********************************************************
; PONG! para MSX 1
; ASM Z80 MSX
; Archivo principal del juego
; (c) 2015 Cesar Rincon Nadal
; http://www.nightfoxandco.com
;***********************************************************


; ----------------------------------------------------------
; Funcion principal
; ----------------------------------------------------------

MAIN:

	; Inicializaciones
	call INIT_ALL			; Parametros iniciales de programa


	; Titulo principal del juego
	MAIN_TITLE:

		call INIT_SCREEN_MODE_2		; Inicializa el modo de pantalla
		
		; Imagen del titulo
		ld hl, TITLE_IMAGE		; Apunta a la direccion de la imagen
		call LOAD_IMAGE_RLE		; Llama a la rutina de carga



	; Bucle principal
	MAIN_TITLE_LOOP:

		; Lee el teclado
		call READ_KEYS
		; Y los puertos de JoyStick
		call READ_JOY1
		call READ_JOY2

		; Si se ha pulsado la tecla espacio...
		ld a, [KB_SPACE]	; Tecla ESPACIO
		and $02			; Detecta "KEY DOWN"
		jp nz, HOW_TO_PLAY	; Pantalla de instrucciones

		; Si se ha pulsado el Boton A del Joystick 1
		ld a, [JOY1_TG1]	; Boton A
		and $02			; Detecta "KEY DOWN"
		jp nz, HOW_TO_PLAY	; Pantalla de instrucciones

		; Si se ha pulsado el Boton A del Joystick 2
		ld a, [JOY2_TG1]	; Boton A
		and $02			; Detecta "KEY DOWN"
		jp nz, HOW_TO_PLAY	; Pantalla de instrucciones

		; Si se pulsa ESC, reinicia el programa
		ld a, [KB_ESC]		; Tecla ESC
		and $02			; Detecta "KEY DOWN"
		jp nz, EXIT


		; Fin del bucle principal
		halt				; Espera a la interrupcion del VDP (VSYNC)
		jp MAIN_TITLE_LOOP		; Bucle



	; Fin del programa
	EXIT:
		; Reinicia el MSX en caso de que pase algo fuera de lo comun y se salga del programa (o se haya pulsado la tecla de salir)
		call $0000		; (CHKRAM)



; ----------------------------------------------------------
; Inicializa el programa
; ----------------------------------------------------------

INIT_ALL:


	; Inicializa las variables
	call INIT_VARIABLES

	; Inicializa el PSG
	call PSG_INIT

	; Deshabilita el sonido del teclado
	xor a			; Fuerza a que A sea 0
	ld [$F3DB], a		; [CLIKSW]

	; Sal de la rutina
	ret





; ----------------------------------------------------------
; Como jugar y seleccion de nº de jugadores
; ----------------------------------------------------------

HOW_TO_PLAY:

	; Carga la imagen del manual
	ld hl, HOWTO_IMAGE			; Apunta a la direccion de la imagen
	call LOAD_IMAGE_RLE			; Llama a la rutina de carga


	; Bucle
	HOW_TO_PLAY_LOOP:

		; Lee el teclado
		call READ_KEYS
		; Y los puertos de JoyStick
		call READ_JOY1
		call READ_JOY2


		; Por defecto, control del P2 por la IA (1 Player)
		ld a, 0
		ld [PLAYER_B_CONTROL], a

		; Si se ha pulsado la tecla 1...
		ld a, [KB_1]		; Tecla ESPACIO
		and $02			; Detecta "KEY DOWN"
		jp nz, PONG_CORE	; Inicia el juego
		; O el boton del Joystick 1
		ld a, [JOY1_TG1]	; Boton A
		and $02			; Detecta "KEY DOWN"
		jp nz, PONG_CORE	; Inicia el juego


		; Si no se ha pulsado la tecla 1, control del P2 por un jugador (2 Players)
		ld a, 1
		ld [PLAYER_B_CONTROL], a

		; Si se ha pulsado la tecla 2...
		ld a, [KB_2]		; Tecla ESPACIO
		and $02			; Detecta "KEY DOWN"
		jp nz, PONG_CORE	; Inicia el juego
		; O el boton del Joystick 2
		ld a, [JOY2_TG1]	; Boton A
		and $02			; Detecta "KEY DOWN"
		jp nz, PONG_CORE	; Inicia el juego


		; Si se pulsa ESC o los botones secundarios de algun Joystick, vuelve al titulo
		ld a, [KB_ESC]		; Tecla ESC
		and $02			; Detecta "KEY DOWN"
		jp nz, MAIN_TITLE	; Vuelve al titulo
		; Boton del Joystick 1
		ld a, [JOY1_TG2]	; Boton B
		and $02			; Detecta "KEY DOWN"
		jp nz, MAIN_TITLE	; Inicia el juego
		; Boton del Joystick 2
		ld a, [JOY2_TG2]	; Boton B
		and $02			; Detecta "KEY DOWN"
		jp nz, MAIN_TITLE	; Inicia el juego


		halt				; Espera a la interrupcion del VDP (VSYNC)
		jp HOW_TO_PLAY_LOOP		; Loop
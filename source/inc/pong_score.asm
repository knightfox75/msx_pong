;***********************************************************
; PONG! para MSX 1
; ASM Z80 MSX
; Marcador
; (c) 2015 Cesar Rincon Nadal
; http://www.nightfoxandco.com
;***********************************************************



	; Copia los datos a la VRAM
	; ----------------------------------------------------------
	; Address ... 0744H (from 005CH)
	; Name ...... LDIRVM (Load, Increment and Repeat to VRAM from Memory)
	; Input ..... BC=Length, DE=VRAM address, HL=RAM address
	; Exit ...... None
	; Modifies .. AF, BC, DE, HL, EI
	; ----------------------------------------------------------



; ----------------------------------------------------------
; Cambia un numero del marcador
; A = PLAYER 1 o 2
; ----------------------------------------------------------

SCORE_UPDATE:

	; Inicializa las variables necesarias
	ld bc, $0006		; nº de lineas de cada digito

	; Segun el jugador
	cp 1
	jr nz, UPDATE_SCORE_P2
	
	; Actualiza el SCORE del Player A
	ld de, NAMTBL + 71		; Posicion del marcador en VRAM
	ld a, [SCORE_A]			; Puntuacion
	jr UPDATE_SCORE_GET_NUMBER

	; Actualiza el SCORE del Player B
	UPDATE_SCORE_P2:
	ld de, NAMTBL + 84		; Posicion del marcador en VRAM
	ld a, [SCORE_B]			; Puntuacion

	; Ahora obten el numero a mostrar
	UPDATE_SCORE_GET_NUMBER:

		ld hl, SC_NUMBER_0		; 0
		cp 0
		jp z, SCORE_UPDATE_LOOP

		ld hl, SC_NUMBER_1		; 1
		cp 1
		jp z, SCORE_UPDATE_LOOP

		ld hl, SC_NUMBER_2		; 2
		cp 2
		jp z, SCORE_UPDATE_LOOP

		ld hl, SC_NUMBER_3		; 3
		cp 3
		jp z, SCORE_UPDATE_LOOP

		ld hl, SC_NUMBER_4		; 4
		cp 4
		jp z, SCORE_UPDATE_LOOP

		ld hl, SC_NUMBER_5		; 5
		cp 5
		jp z, SCORE_UPDATE_LOOP

		ld hl, SC_NUMBER_6		; 6
		cp 6
		jp z, SCORE_UPDATE_LOOP

		ld hl, SC_NUMBER_7		; 7
		cp 7
		jp z, SCORE_UPDATE_LOOP

		ld hl, SC_NUMBER_8		; 8
		cp 8
		jp z, SCORE_UPDATE_LOOP

		ld hl, SC_NUMBER_9		; 9



	; Rutina de dibujado
	SCORE_UPDATE_LOOP:
		
		; Guarda los registros
		push bc
		push hl
		push de

		; Manda la info a la VRAM
		ld bc, $0005
		call $005C	; Ejecuta la rutina [LDIRVM]

		; Incrementa el puntero de destino
		pop de
		ld h, d
		ld l, e
		ld bc, 32
		add hl, bc
		ld d, h
		ld e, l

		; Incrementa el puntero de origen
		pop hl
		ld bc, 5
		add hl, bc

		; Resta una fila
		pop bc
		dec bc
		ld a, b
		or c
		jp nz, SCORE_UPDATE_LOOP

	; Sal de la rutina
	ret
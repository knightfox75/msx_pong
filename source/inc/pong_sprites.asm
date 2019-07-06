;***********************************************************
; PONG! para MSX 1
; ASM Z80 MSX
; Gestion de Sprites
; (c) 2015 Cesar Rincon Nadal
; http://www.nightfoxandco.com
;***********************************************************






; ----------------------------------------------------------
; Crea los sprites
; ----------------------------------------------------------

PONG_CREATE_SPRITES:

	; Carga los graficos de los sprites
	ld hl, PONGSPR_SPRITE			; Direccion de los graficos
	ld de, SPRTBL				; Direccion de la posicion en la tabla
	call LOAD_SPRITE_DATA

	; Attributos del sprite "BALL" [SPR nº 0]
	ld hl, SPR_BALL
	ld [hl], 92		; POS Y
	inc hl
	ld [hl], 124		; POS X
	inc hl
	ld [hl], 0		; GFX nº
	inc hl
	ld [hl], 1		; Color
	; Actualiza los attributos en la VRAM
	call PONG_UPDATE_SPR_BALL

	; Attributos del sprite "PLAYER A" [INFO]
	ld hl, SPR_PLAYER_A
	ld [hl], 80		; POS Y
	inc hl
	ld [HL], 8		; POS X

	; Attributos del sprite "PLAYER A" [PART 1] [SPR nº 1]
	ld bc, $0003		; Salta a los parametros graficos (HL + 3)
	add hl, bc
	ld [hl], 1		; GFX nº
	inc hl
	ld [hl], 1		; Color
	; Attributos del sprite "PLAYER A" [PART 2] [SPR nº 2]
	add hl, bc		; Salta a los parametros graficos
	ld [hl], 1		; GFX nº
	inc hl
	ld [hl], 1		; Color
	; Attributos del sprite "PLAYER A" [PART 3] [SPR nº 3]
	add hl, bc		; Salta a los parametros graficos
	ld [hl], 1		; GFX nº
	inc hl
	ld [hl], 1		; Color
	; Attributos del sprite "PLAYER A" [PART 3] [SPR nº 4]
	add hl, bc		; Salta a los parametros graficos
	ld [hl], 1		; GFX nº
	inc hl
	ld [hl], 1		; Color
	; Actualiza los attributos en la VRAM
	call PONG_UPDATE_SPR_PLAYER_A


	; Attributos del sprite "PLAYER B" [INFO]
	ld hl, SPR_PLAYER_B
	ld [hl], 80		; POS Y
	inc hl
	ld [HL], 240		; POS X

	; Attributos del sprite "PLAYER B" [PART 1] [SPR nº 5]
	ld bc, $0003		; Salta a los parametros graficos (HL + 3)
	add hl, bc
	ld [hl], 1		; GFX nº
	inc hl
	ld [hl], 1		; Color
	; Attributos del sprite "PLAYER B" [PART 2] [SPR nº 6]
	add hl, bc		; Salta a los parametros graficos
	ld [hl], 1		; GFX nº
	inc hl
	ld [hl], 1		; Color
	; Attributos del sprite "PLAYER B" [PART 3] [SPR nº 7]
	add hl, bc		; Salta a los parametros graficos
	ld [hl], 1		; GFX nº
	inc hl
	ld [hl], 1		; Color
	; Attributos del sprite "PLAYER B" [PART 4] [SPR nº 8]
	add hl, bc		; Salta a los parametros graficos
	ld [hl], 1		; GFX nº
	inc hl
	ld [hl], 1		; Color
	; Actualiza los attributos en la VRAM
	call PONG_UPDATE_SPR_PLAYER_B

	; Fin de la rutina
	ret



; ----------------------------------------------------------
; Actualiza todos los Sprites
; ----------------------------------------------------------

PONG_SPRITES_UPDATE:

	call PONG_UPDATE_SPR_BALL
	call PONG_UPDATE_SPR_PLAYER_A
	call PONG_UPDATE_SPR_PLAYER_B
	ret



; ----------------------------------------------------------
; Actualiza el sprite de la bola
; ----------------------------------------------------------

PONG_UPDATE_SPR_BALL:

	ld hl, SPR_BALL		; Direccion de los atributos [HL]
	ld de, SPRATR		; Destino (+ nº de sprite x 4) [DE]
	ld bc, $0004		; Define la cantidad de datos a transferir (nº fragmentos del Sprites x 4) [BC]
	call $005C		; Ejecuta la rutina [LDIRVM]

	ret



; ----------------------------------------------------------
; Actualiza el sprite del PLAYER A [SPR nº 1]
; ----------------------------------------------------------

PONG_UPDATE_SPR_PLAYER_A:

	; Calcula las posiciones de los sprites (Y)
	ld hl, SPR_PLAYER_A		; Coordenada Y
	ld a, [hl]

	ld bc, $0002			; Muevete al siguiente atributo Y
	add hl, bc
	ld [hl], a			; Escribe el valor de Y (Parte 1)

	ld bc, $0004			; Muevete al siguiente atributo Y
	add hl, bc
	add 8				; Sumale 8 pixeles a la Y
	ld [hl], a			; Escribe el valor de Y (Parte 2)
	
	add hl, bc			; Muevete al siguiente atributo Y
	add 8				; Sumale 8 pixeles a la Y
	ld [hl], a			; Escribe el valor de Y (Parte 3)

	add hl, bc			; Muevete al siguiente atributo Y
	add 8				; Sumale 8 pixeles a la Y
	ld [hl], a			; Escribe el valor de Y (Parte 4)


	; Calcula las posiciones de los sprites (X)
	ld hl, SPR_PLAYER_A + 1		; Coordenada X
	ld a, [hl]

	ld bc, $0002			; Muevete al siguiente atributo X
	add hl, bc
	ld [hl], a			; Escribe el valor de X (Parte 1)

	ld bc, $0004			; Muevete al siguiente atributo X
	add hl, bc
	ld [hl], a			; Escribe el valor de X (Parte 2)

	add hl, bc			; Muevete al siguiente atributo X
	ld [hl], a			; Escribe el valor de X (Parte 3)
	
	add hl, bc			; Muevete al siguiente atributo X
	ld [hl], a			; Escribe el valor de X (Parte 4)

	; Actualiza los atributos en la VRAM
	ld hl, SPR_PLAYER_A + 2		; Direccion de los atributos [HL]
	ld de, SPRATR + 4		; Destino (+ nº de sprite x 4) [DE]
	ld bc, $0010			; Define la cantidad de datos a transferir (nº fragmentos del Sprites x 4) [BC]
	call $005C			; Ejecuta la rutina [LDIRVM]

	ret



; ----------------------------------------------------------
; Actualiza el sprite del PLAYER B [SPR nº 5]
; ----------------------------------------------------------

PONG_UPDATE_SPR_PLAYER_B:

	; Calcula las posiciones de los sprites (Y)
	ld hl, SPR_PLAYER_B		; Coordenada Y
	ld a, [hl]

	ld bc, $0002			; Muevete al siguiente atributo Y
	add hl, bc
	ld [hl], a			; Escribe el valor de Y (Parte 1)

	ld bc, $0004			; Muevete al siguiente atributo Y
	add hl, bc
	add 8				; Sumale 8 pixeles a la Y
	ld [hl], a			; Escribe el valor de Y (Parte 2)
	
	add hl, bc			; Muevete al siguiente atributo Y
	add 8				; Sumale 8 pixeles a la Y
	ld [hl], a			; Escribe el valor de Y (Parte 3)

	add hl, bc			; Muevete al siguiente atributo Y
	add 8				; Sumale 8 pixeles a la Y
	ld [hl], a			; Escribe el valor de Y (Parte 4)


	; Calcula las posiciones de los sprites (X)
	ld hl, SPR_PLAYER_B + 1		; Coordenada X
	ld a, [hl]

	ld bc, $0002			; Muevete al siguiente atributo X
	add hl, bc
	ld [hl], a			; Escribe el valor de X (Parte 1)

	ld bc, $0004			; Muevete al siguiente atributo X
	add hl, bc
	ld [hl], a			; Escribe el valor de X (Parte 2)

	add hl, bc			; Muevete al siguiente atributo X
	ld [hl], a			; Escribe el valor de X (Parte 3)

	add hl, bc			; Muevete al siguiente atributo X
	ld [hl], a			; Escribe el valor de X (Parte 4)
	

	; Actualiza los atributos en la VRAM
	ld hl, SPR_PLAYER_B + 2		; Direccion de los atributos [HL]
	ld de, SPRATR + 20		; Destino (+ nº de sprite x 4) [DE]
	ld bc, $0010			; Define la cantidad de datos a transferir (nº fragmentos del Sprites x 4) [BC]
	call $005C			; Ejecuta la rutina [LDIRVM]

	ret
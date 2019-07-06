;***********************************************************
; Rutinas de carga de las diferentes imagenes
; ASM Z80 MSX
;***********************************************************



; ----------------------------------------------------------
; Carga una imagen y muestrala a la pantalla
; HL = Direccion de la imagen (Origen de los datos)
; ----------------------------------------------------------

LOAD_IMAGE:

	; Guarda el puntero de los datos de la imagen
	push hl


	; Deshabilita la pantalla
	call $0041		; Ejecuta la rutina [DISSCR]


	; Borra la tabla de nombres (mapa) usando FILVRM
	; ----------------------------------------------------------
	; Address ... 0815H (from 0056H)
	; Name ...... FILVRM (Fill VRAM)
	; Input ..... A=Data byte, BC=Length, HL=VRAM address
	; Exit ...... None
	; Modifies .. AF, BC, EI
	; ----------------------------------------------------------
	
	ld hl, NAMTBL		; Apunta a la tabla de nombres
	ld bc, $300		; Longitud de 768 celdas
	xor a			; Pon A a 0
	call $0056		; Ejecuta la rutina [FILVRM]


	; Copia los datos a la VRAM
	; ----------------------------------------------------------
	; Address ... 0744H (from 005CH)
	; Name ...... LDIRVM (Load, Increment and Repeat to VRAM from Memory)
	; Input ..... BC=Length, DE=VRAM address, HL=RAM address
	; Exit ...... None
	; Modifies .. AF, BC, DE, HL, EI
	; ----------------------------------------------------------


	; Recupera el puntero a los datos de la imagen
	pop hl


	; Copia el banco 1 de patterns
	ld de, CHRTBL			; Destino de los datos
	call PUT_IMAGE_VRAM

	; Copia el banco 2 de patterns
	ld de, CHRTBL + 2048		; Destino de los datos
	call PUT_IMAGE_VRAM

	; Copia el banco 3 de patterns
	ld de, CHRTBL + 4096		; Destino de los datos
	call PUT_IMAGE_VRAM


	; Copia el banco 1 de colors
	ld de, CLRTBL			; Destino de los datos
	call PUT_IMAGE_VRAM

	; Copia el banco 2 de colors
	ld de, CLRTBL + 2048		; Destino de los datos
	call PUT_IMAGE_VRAM

	; Copia el banco 3 de colors
	ld de, CLRTBL + 4096		; Destino de los datos
	call PUT_IMAGE_VRAM


	; Copia el banco 1 de names
	ld de, NAMTBL			; Destino de los datos
	call PUT_IMAGE_VRAM

	; Copia el banco 2 de names
	ld de, NAMTBL + 256		; Destino de los datos
	call PUT_IMAGE_VRAM

	; Copia el banco 3 de names
	ld de, NAMTBL + 512		; Destino de los datos
	call PUT_IMAGE_VRAM


	; Habilita la pantalla
	call $0044		; Ejecuta la rutina [ENASCR]

	; Fin de la rutina de carga
	ret



	; Rutina de carga de datos en VRAM desde la ROM/RAM
	PUT_IMAGE_VRAM:

		ld b, [hl]			; Carga el tamaño de los datos
		inc hl
		ld c, [hl]
		inc hl
		push hl				; Guarda el puntero a los datos de la imagen
		push bc

		call $005C			; Ejecuta la rutina [LDIRVM]

		pop bc				; Recupera los parametros de la ultima imagen
		pop hl				
		add hl, bc			; Y actualiza el puntero

		ret				; Sal de la subrutina



; ----------------------------------------------------------
; Carga una imagen y muestrala a la pantalla
; HL = Direccion de la imagen (Origen de los datos)
; ----------------------------------------------------------

LOAD_IMAGE_RLE:

	; Guarda el puntero de los datos de la imagen
	push hl


	; Deshabilita la pantalla
	call $0041		; Ejecuta la rutina [DISSCR]


	; Borra la tabla de nombres (mapa) usando FILVRM
	; ----------------------------------------------------------
	; Address ... 0815H (from 0056H)
	; Name ...... FILVRM (Fill VRAM)
	; Input ..... A=Data byte, BC=Length, HL=VRAM address
	; Exit ...... None
	; Modifies .. AF, BC, EI
	; ----------------------------------------------------------
	
	ld hl, NAMTBL		; Apunta a la tabla de nombres
	ld bc, $300		; Longitud de 768 celdas
	xor a			; Pon A a 0
	call $0056		; Ejecuta la rutina [FILVRM]


	; Copia los datos a la VRAM
	; ----------------------------------------------------------
	; Address ... 0744H (from 005CH)
	; Name ...... LDIRVM (Load, Increment and Repeat to VRAM from Memory)
	; Input ..... BC=Length, DE=VRAM address, HL=RAM address
	; Exit ...... None
	; Modifies .. AF, BC, DE, HL, EI
	; ----------------------------------------------------------


	; Recupera el puntero a los datos de la imagen
	pop hl


	; Copia el banco 1 de patterns
	ld de, CHRTBL			; Destino de los datos
	call PUT_IMAGE_VRAM_RLE

	; Copia el banco 2 de patterns
	ld de, CHRTBL + 2048		; Destino de los datos
	call PUT_IMAGE_VRAM_RLE

	; Copia el banco 3 de patterns
	ld de, CHRTBL + 4096		; Destino de los datos
	call PUT_IMAGE_VRAM_RLE


	; Copia el banco 1 de colors
	ld de, CLRTBL			; Destino de los datos
	call PUT_IMAGE_VRAM_RLE

	; Copia el banco 2 de colors
	ld de, CLRTBL + 2048		; Destino de los datos
	call PUT_IMAGE_VRAM_RLE

	; Copia el banco 3 de colors
	ld de, CLRTBL + 4096		; Destino de los datos
	call PUT_IMAGE_VRAM_RLE


	; Copia el banco 1 de names
	ld de, NAMTBL			; Destino de los datos
	call PUT_IMAGE_VRAM_RLE

	; Copia el banco 2 de names
	ld de, NAMTBL + 256		; Destino de los datos
	call PUT_IMAGE_VRAM_RLE

	; Copia el banco 3 de names
	ld de, NAMTBL + 512		; Destino de los datos
	call PUT_IMAGE_VRAM_RLE


	; Habilita la pantalla
	call $0044		; Ejecuta la rutina [ENASCR]

	; Fin de la rutina de carga
	ret



	; Rutina de carga de datos en VRAM desde el RAM_BUFFER del RLE
	PUT_IMAGE_VRAM_RLE:

		push de				; Guarda la direccion de destino en VRAM

		ld de, RAM_BUFFER		; Destino de los datos RLE
		call RLE_DECOMPRESS		; Descomprime los datos

		ld hl, RLE_NORMAL_SIZE		; Recupera el tamaño de los datos descomprimidos
		ld b, [hl]
		inc hl
		ld c, [hl]

		ld hl, RAM_BUFFER		; Puntero a los datos
		pop de				; Destino de los datos
		call $005C			; Ejecuta la rutina [LDIRVM]

		ld hl, RLE_COMPRESSED_SIZE	; Recupera el tamaño de los datos comprimidos
		ld b, [hl]
		inc hl
		ld c, [hl]

		ld hl, RLE_POINTER		; Recupera el puntero
		ld d, [hl]
		inc hl
		ld e, [hl]
		ld h, d
		ld l, e

		add hl, bc			; Y sumale el tamaño de los datos comprimidos

		ret				; Sal de la subrutina
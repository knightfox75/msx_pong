;***********************************************************
; Descompresion de datos RLE
; ASM Z80 MSX
;***********************************************************



; ----------------------------------------------------------
; Descomprime datos RLE y colocalos en el buffer de RAM
; HL = Direccion de los datos comprimidos
; DE = Direccion de destino
; BC = Tamaño de los datos a descomprimir [AUTO]
; ----------------------------------------------------------

RLE_DECOMPRESS:

	; Lee la cabecera con la informacion sobre el
	; tamaño de los datos comprimidos y descomprimidos

	ld b, [hl]			; Lee el tamaño descomprimido
	inc hl
	ld c, [hl]
	inc hl
	push hl

	ld hl, RLE_NORMAL_SIZE		; Guarda el tamaño descomprimido
	ld [hl], b
	inc hl
	ld [hl], c
	pop hl
	
	ld b, [hl]			; Lee el tamaño comprimido
	inc hl
	ld c, [hl]
	inc hl
	push hl

	ld hl, RLE_COMPRESSED_SIZE	; Guarda el tamaño comprimido
	ld [hl], b
	inc hl
	ld [hl], c
	pop hl

	push hl				; Lee el puntero a los datos
	push de
	ld d, h
	ld e, l

	ld hl, RLE_POINTER		; Guarda el puntero a los datos
	ld [hl], d
	inc hl
	ld [hl], e
	pop de
	pop hl




	; Loop principal de la descompresion de datos
	RLE_MAIN_LOOP:

		ld a, [hl]			; Carga el dato
		and 192				; Si los BITS 6 y 7 estan a 1, es un dato comprimido
		cp 192
		jp z, RLE_COMPRESSED_DATA

		ld a, [hl]			; Los datos no estan comprimidos, escribelos tal cual
		ld [de], a
		inc hl				; Suma una posicion a los punteros de origen y destino
		inc de
		dec bc				; Resta una unidad al contador de datos
		ld a, b
		or c				; Y verifica si aun hay datos
		jp nz, RLE_MAIN_LOOP
		jp RLE_END			; Sal de la rutina si no quedan datos
	


	; Descompresion de los datos
	RLE_COMPRESSED_DATA:
	
		push bc				; Guarda el numero de datos restantes
		ld a, [hl]			; Ahora mira el numero de repeticiones
		and 63				; En base a los BITS 0 a 5
		ld b, a				; Guarda las repeticiones en B
		inc hl				; Muevete al siguiente byte
		ld a, [hl]			; lee el dato a repetir
		ld c, a				; y guardalo en C
		inc hl				; Y mueve el puntero de lectura

		; Escribe los datos RLE
		RLE_WRITE_LOOP:
			
			ld a, c			; Carga el dato a escribir
			ld [de], a		; Escribelo en el destino
			inc de			; Mueve el puntero
			dec b			; Resta una repeticion
			ld a, b			; Y verifica si hay que salir
			jp nz, RLE_WRITE_LOOP	; Si aun quedan repeticiones, repite

		; Si se ha terminado de escribir datos RLE
		pop bc				; Recupera los datos restantes
		dec bc				; Resta 2 bytes
		dec bc
		ld a, b
		or c				; Y verifica si aun hay datos
		jp nz, RLE_MAIN_LOOP



	; Fin de la descompresion RLE
	RLE_END:

		ret				; Fin de la rutina
;***********************************************************
; Rutinas de carga de los diferentes sprites
; ASM Z80 MSX
;***********************************************************


; ----------------------------------------------------------
; Carga los graficos de un Sprite en la VRAM
; HL = Direccion de los CHR del Sprite (Origen de los datos)
; DE = Direccion de destino
; ----------------------------------------------------------

LOAD_SPRITE_DATA:

	; Lee la cantidad de datos a transferir [BC]
	ld a, [hl]
	ld a, b
	inc hl
	ld a, [hl]
	ld c, a
	inc hl

	; Transfiere los datos a la VRAM (usando la BIOS)
	call $005C			; Ejecuta la rutina [LDIRVM]

	; Sal de la rutina
	ret
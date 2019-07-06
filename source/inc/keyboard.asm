;***********************************************************
; Rutinas de acceso al teclado
; ASM Z80 MSX
;***********************************************************





; ----------------------------------------------------------
; Lee las teclas definidas
; ----------------------------------------------------------

READ_KEYS:	; BC -> Fila y BIT	HL -> Direccion de la variable de la tecla

	ld bc, $0704			; Fila 7 (B = fila) y BIT 2 (C = n ^ 2)
	ld hl, KB_ESC			; Variable de la tecla
	call GET_KEY			; Obten el estado de la tecla

	ld bc, $0801			; Fila 8 (B = fila) y BIT 0 (C = n ^ 2)
	ld hl, KB_SPACE			; Variable de la tecla
	call GET_KEY			; Obten el estado de la tecla

	ld bc, $0820			; Fila 8 (B = fila) y BIT 5 (C = n ^ 2)
	ld hl, KB_UP			; Variable de la tecla
	call GET_KEY			; Obten el estado de la tecla

	ld bc, $0840			; Fila 8 (B = fila) y BIT 6 (C = n ^ 2)
	ld hl, KB_DOWN			; Variable de la tecla
	call GET_KEY			; Obten el estado de la tecla

	ld bc, $0880			; Fila 8 (B = fila) y BIT 7 (C = n ^ 2)
	ld hl, KB_RIGHT			; Variable de la tecla
	call GET_KEY			; Obten el estado de la tecla

	ld bc, $0810			; Fila 8 (B = fila) y BIT 4 (C = n ^ 2)
	ld hl, KB_LEFT			; Variable de la tecla
	call GET_KEY			; Obten el estado de la tecla

	ld bc, $0440			; Fila 4 (B = fila) y BIT 6 (C = n ^ 2)
	ld hl, KB_Q			; Variable de la tecla
	call GET_KEY			; Obten el estado de la tecla

	ld bc, $0240			; Fila 2 (B = fila) y BIT 6 (C = n ^ 2)
	ld hl, KB_A			; Variable de la tecla
	call GET_KEY			; Obten el estado de la tecla

	ld bc, $0002			; Fila 0 (B = fila) y BIT 1 (C = n ^ 2)
	ld hl, KB_1			; Variable de la tecla
	call GET_KEY			; Obten el estado de la tecla

	ld bc, $0004			; Fila 0 (B = fila) y BIT 2 (C = n ^ 2)
	ld hl, KB_2			; Variable de la tecla
	call GET_KEY			; Obten el estado de la tecla

	call $0156			; Limpia el buffer del teclado con la rutina de BIOS [KILBUF]

	ret				; Vuelve



; ----------------------------------------------------------
; Lee el estado de una tecla solicitada
; ----------------------------------------------------------

GET_KEY:	; Lee el estado de la tecla solicitada usando los puertos $A9 y $AA 
		; Usa el registro BC para pasar la fila (B) y el BIT (C)
		; Usa el registro HL para la direccion de la variable asignada a cada tecla

	in a, ($AA)			; Lee el contenido del selector de filas
	and $F0				; Manten los datos de los BITs 4 a 7 (resetea los bits 0 a 3)
	or b				; Indica la fila
	out ($AA), a			; y seleccionala
	in a, ($A9)			; Lee el contenido de la fila
	and c				; Lee el estado de la tecla segun el registro C

	jr z, KEY_HELD			; En caso de que se haya pulsado, salta
	
	; Si no se ha pulsado
	ld [hl], $00			; Todos los BITs a 0
	ret
	
	; Si se ha pulsado
	KEY_HELD:
	ld a, [hl]			; Carga el estado anterior
	and $04				; Si no estava pulsada...
	jr z, KEY_PRESS			; Salta a NEW PRESS
	ld [hl], $05			; Si ya estava pulsada, pon a 1 los BITS 0 (HELD) y 1 (TEMP) y a 0 el BIT 1 (PRESS)
	ret

	; Si era una nueva pulsacion
	KEY_PRESS:
	ld [hl], $07			; Todos los BITs a 1
	ret



; ----------------------------------------------------------
; Verifica si se ha pulsado alguna tecla para salir
; ----------------------------------------------------------

;EXIT_KEY:	; Lee las teclas para salir del programa

	;call READ_KEYS			; Lee el teclado

	;ld b, $00			; Vacia el registro

	;ld a, [KB_SPACE]		; Tecla ESPACIO
	;or b				; Acumula el resultado
	;ld b, a				; Y Guardalo

	;ld a, [KB_ESC]			; Tecla ESC
	;or b				; Acumula el resultado
	;ld b, a				; Y Guardalo

	;ret
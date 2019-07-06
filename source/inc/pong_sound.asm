;***********************************************************
; PONG! para MSX 1
; ASM Z80 MSX
; Sonidos del juego
; (c) 2015 Cesar Rincon Nadal
; http://www.nightfoxandco.com
;***********************************************************





; ----------------------------------------------------------
; PONG! Sound: Ping!
; ----------------------------------------------------------

SOUND_PING:

	; Tono en el Canal A:  111,861 Hz / 150 = 745 hz
	ld a, 0
	out ($A0), a
	ld a, 150
	out ($A1), a
	ld a, 1
	out ($A0), a
	ld a, 0
	out ($A1), a

	; Volumen a 15
	ld a, 8		; Volumen del canal A
	out ($A0), a
	ld a, 15	; Volumen a 15 (sin modulacion)
	out ($A1), a

	ret



; ----------------------------------------------------------
; PONG! Sound: Pong!
; ----------------------------------------------------------

SOUND_PONG:

	; Tono en el Canal A:  111,861 Hz / 255 = 438 hz
	ld a, 0
	out ($A0), a
	ld a, 255
	out ($A1), a
	ld a, 1
	out ($A0), a
	ld a, 0
	out ($A1), a

	; Volumen a 15
	ld a, 8		; Volumen del canal A
	out ($A0), a
	ld a, 15	; Volumen a 15 (sin modulacion)
	out ($A1), a

	ret



; ----------------------------------------------------------
; PONG! Sound: Manage Channel A
; ----------------------------------------------------------

SOUND_CHANNEL_A:

	ld a, 8		; Volumen del canal A
	out ($A0), a
	in a, ($A2)	; Volumen actual

	cp 0		; Si no hay volumen, sal
	ret z

	dec a
	out ($A1), a	; Nuevo volumen

	cp 0
	ret nz		; Si el volumen no es 0, vuelve

	ld a, 0		; Anula el tono
	out ($A0), a
	ld a, 0
	out ($A1), a
	ld a, 1
	out ($A0), a
	ld a, 0
	out ($A1), a

	ret		; Vuelve



; ----------------------------------------------------------
; PONG! Sound: Kill all sounds
; ----------------------------------------------------------

SOUND_KILL_ALL:

	; Canal A
	ld a, 0		; Anula el tono
	out ($A0), a
	ld a, 0
	out ($A1), a
	ld a, 1
	out ($A0), a
	ld a, 0
	out ($A1), a

	ld a, 8		; Volumen del canal A
	out ($A0), a
	ld a, 0
	out ($A1), a	; Nuevo volumen

	ret		; Vuelve
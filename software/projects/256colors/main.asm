		DEVICE 	ZXSPECTRUM128

		include "..\..\include\dss.inc"
		include "..\..\include\head.inc"

PALETTE_BASE = 0x9000

begin:		
		ld	hl,HelpString
		ld	c,pchars			; print text
		rst	0x10

		call	SetVideoMode
		call	SetPalettes
		call	InitScreen

.main_loop:	halt					; v'sync, maybe :)

.pal_base:	ld	hl,PALETTE_BASE
		ld	de,0x0000
		ld	bc,0xFFA4
		sub     a
		rst	0x08			; load palette by BIOS

		ld	hl,(.pal_base + 1)
		ld	de,0x0010
.col_count:	ld	bc,0x0A00/4
		add	hl,de
		dec	bc
		ld	a,b
		or	c
		jr	nz,.next
		ld	hl,PALETTE_BASE + 0x800
		ld	bc,0x0800/4
.next:		ld	(.pal_base + 1), hl
		ld	(.col_count + 1), bc

		ld	c,0x03			; test mouse button
		rst	0x30
		bit	0,a			; left button is pressed?
		jr	nz,.exit
		ld	c,scankey		; test keypress
		rst	0x10
		jr	z,.main_loop
		cp	0x1B			; ESC is pressed?
		jr	nz,.main_loop

.exit:		call	CrearVideoRam
		call	ResVideoMode

		ld	bc,0x0041		; c = quit cmd
		rst	0x10      		; exit to OS...

;[]=======================================================================[]
; set requist video mode 320x256x256
SetVideoMode:	ld	c,getvmode		; save previos vmode
		rst	0x10
		ld	(vmode + 1), a
		ld	a,b
		ld	(vscrn + 1), a
		sub	a
		call	CrearVideoRam
		ld	bc,0x0050		; set 320x256x256
		ld	a,_320p
		rst	0x10
		ret

;[]=======================================================================[]
; restore previos video mode
ResVideoMode:	sub	a
		call	CrearVideoRam
vscrn:		ld	b,0x00
vmode:		ld	a,0x00
		ld	c,setvmode
		rst	0x10			; set previos vmode
		ret

;[]=======================================================================[]
; generate palette
SetPalettes:	sub	a
		ld	hl,PALETTE_BASE
		ld	de,PALETTE_BASE + 1
		ld	bc,0x03FF
		ld	(hl),a
		ldir
		inc	hl

		ld	de,0x0000
.loop0:		ld	(hl),d
		inc	hl
		ld	(hl),e
		inc	hl
		ld	(hl),c
		inc	hl
		ld	(hl),a
		inc	hl
		inc	d
		djnz	.loop0
		ld	de,0xFF00
		ld	bc,0x0000
.loop1:		ld	(hl),d
		inc	hl
		ld	(hl),e
		inc	hl
		ld	(hl),c
		inc	hl
		ld	(hl),a
		inc	hl
		dec	d
		inc	c
		djnz	.loop1

		ld	de,0x0000
		ld	bc,0x00FF
.loop2:		ld	(hl),d
		inc	hl
		ld	(hl),e
		inc	hl
		ld	(hl),c
		inc	hl
		ld	(hl),a
		inc	hl
		inc	d
		inc	e
		dec	c
		djnz	.loop2

		ld	de,0xFFFF
		ld	bc,0x0000
.loop3:		ld	(hl),d
		inc	hl
		ld	(hl),e
		inc	hl
		ld	(hl),c
		inc	hl
		ld	(hl),a
		inc	hl
		dec	e
		inc	c
		djnz	.loop3

		ld	de,0xFF00
		ld	bc,0x00FF
.loop4:		ld	(hl),d
		inc	hl
		ld	(hl),e
		inc	hl
		ld	(hl),c
		inc	hl
		ld	(hl),a
		inc	hl
		dec	d
		inc	e
		djnz	.loop4

		ld	de,0x00FF
		ld	bc,0x00FF
.loop5:		ld	(hl),d
		inc	hl
		ld	(hl),e
		inc	hl
		ld	(hl),c
		inc	hl
		ld	(hl),a
		inc	hl
		inc	d
		dec	e
		dec	c
		djnz	.loop5

		ld	de,0xFF00
		ld	bc,0x0000
.loop6:		ld	(hl),d
		inc	hl
		ld	(hl),e
		inc	hl
		ld	(hl),c
		inc	hl
		ld	(hl),a
		inc	hl
		dec	d
		inc	e
		djnz	.loop6

		ld	de,0x00FF
		ld	bc,0x0000
.loop7:		ld	(hl),d
		inc	hl
		ld	(hl),e
		inc	hl
		ld	(hl),c
		inc	hl
		ld	(hl),a
		inc	hl
		dec	e
		inc	c
		djnz	.loop7

		ld	de,0x0000
		ld	bc,0x00FF
.loop8:		ld	(hl),d
		inc	hl
		ld	(hl),e
		inc	hl
		ld	(hl),c
		inc	hl
		ld	(hl),a
		inc	hl
		inc	d
		dec	c
		djnz	.loop8

		ld	de,0xFF00
		ld	bc,0x0000
.loop9:		ld	(hl),d
		inc	hl
		ld	(hl),e
		inc	hl
		ld	(hl),c
		inc	hl
		ld	(hl),a
		inc	hl
		dec	d
		inc	c
		djnz	.loop9
						; load fully black palette
		ld	hl,PALETTE_BASE
		ld	de,0x0000
		ld	bc,0xFFA4
		sub	a
		rst	0x08			; load palette by BIOS
		ret

;[]=======================================================================[]
InitScreen:	in	a,(port_y)		; save inflective ports
		ld	c,a
		in	a,(cpu_w1)
		ld	b,a
		push	bc
		ld	a,norm_scr		; set video page to 0x4000-0x7FFF
		out	(cpu_w1),a
						; now i'll generate 207 circuits
						; for first quadrange
						;  |
						; -+-
						;  |a
		ld	hl,207			; start radius 207, start color 0
.loop1:		push	hl
		ld	a,h
		call	QCircuit
		pop	hl
		inc	h
		dec	l
		jr	nz,.loop1
		ld	e,l			; SetPixel(0, 0)
		ld	c,e
		call	SetPixel
						; now i'll duplicate quadrange
						;  |
						; -+-
						; b|a
		ld	c,128
.loop2:		ld	hl,0x4000 + 160
		ld	de,0x4000 + 159
		ld	a,c
		out	(port_y),a
		ld	b,160
.loop3:		ld	a,(hl)
		ld	(de),a
		inc	hl
		dec	de
		djnz	.loop3
		inc	c
		jr	nz,.loop2
						; c|d
						; -+-
						; b|a
		ld	hl,0x4000
		ld	e,127
		ld	d,128
		di
		ld	d,d			; set accel lenght to 160
		ld	a,160
		ld	b,b
.loop4:		ld	a,d
		out	(port_y), a
		ld	l,l
		ld	a,(hl)
		ld	b,b
		ld	a,e
		out	(port_y), a
		ld	l,l
		ld	(hl),a
		ld	b,b
		dec	e
		inc	d
		jr	nz,.loop4
		ld	hl,0x4000 + 160
		ld	e,127
		ld	d,128
.loop5:		ld	a,d
		out	(port_y), a
		ld	l,l
		ld	a,(hl)
		ld	b,b
		ld	a,e
		out	(port_y), a
		ld	l,l
		ld	(hl),a
		ld	b,b
		dec	e
		inc	d
		jr	nz,.loop5
		ei

		pop	bc
		ld	a,b
		out	(cpu_w1),a
		ld	a,c
		out	(port_y),a		; restore ports
		ret


;[]=======================================================================[]
; Fast circuit generator for first quadrange
; Original implementation for z80 (c)2002, Enin Anton
; Procedure based on Horn-Doros algorithm for circuits
; Input:
;	l - radius
;	a  - color
; Output:
;	-

QCircuit:	exx				; center 160, 128
		ld	de,0x4000 + 160	; 'de - center screen on x-axis
		ld	c,a			; 'c - color
		exx
						; x = radius; y = 0; s = -radius;
		ld	e,l			; e - x
		ld	d,0x00
		ld	c,d
		ld	b,d			; c - y
		ld	a,l
		neg
		ld	l,a
		ld	h,0xFF			; hl - s
.loop1:
		call	SetPixel
		inc	hl
		add	hl,bc
		add	hl,bc			; s = s + 2*y + 1
		bit	7,h
		jr	nz,.nocorr1		; s >= 0 ?
		inc	hl
		inc	hl
		or	a
		sbc	hl,de
		or	a
		sbc	hl,de			; s = s - 2*x + 2
		dec	e			; x = x - 1
.nocorr1:	inc	c			; y = y + 1
		ld	a,e
		cp	c
		jr	nc,.loop1

		add	hl,de
		add	hl,de			; s = s + 2*x
		ld	a,c			; t = y
		ld	c,e			; y = x
		ld	e,a			; x = t
.loop2:
		inc	hl
		or	a
		sbc	hl,de
		or	a
		sbc	hl,de			; s = s - 2*x + 1
		jp	p,.nocorr2		; s < 0 ?
		inc	hl
		inc	hl
		add	hl,bc
		add	hl,bc			; s = s + 2*y + 2
		inc	c			; y = y + 1
.nocorr2:	dec	e			; x = x - 1
		call	SetPixel
		ld	a,e
		cp	-1
		jr	nz,.loop2
		ret

; SetPixel
; e - x, c - y
SetPixel:	ld	a,e			; clip pixel on x-axis
		cp	160
		ret	nc
		ld	a,c			; clip pixel on y-axis
		cp	128
		ret	nc
		add	a,128			; center screen on y-axis
		out	(port_y), a
		ld	a,e
		exx
		ld	l,a
		ld	h,0x00
		add	hl,de
		ld	(hl),c			; set 2 equal pixels
		inc	hl			; for disappear holes
		ld	(hl),c			; between circuits
		exx
		ret

;[]=======================================================================[]
; Clear video memory (first screen)
CrearVideoRam:	ld	hl,PALETTE_BASE	; load fully black palette
		ld	de,0x0000
		ld	bc,0xFFA4
		sub	a
		rst	0x08			; load palette by BIOS

		in	a,(port_y)		; store modify ports
		ld	c,a
		in	a,(cpu_w1)
		ld	b,a
		push	bc
		ld	a,norm_scr
		out	(cpu_w1),a
		ld	hl,0x4000
		ld	bc,320			; screen x size in bytes
		ld	e,l
		di
		ld	d,d
		ld	a,0x00			; set accel lenght to 256 bytes
.loop:		ld	e,e			; fill vertical lines
		ld	(hl),e
		ld	b,b
		inc	hl
		dec	bc
		ld	a,b
		or	c
		jr	nz,.loop
		ei
		pop	bc
		ld	a,b
		out	(cpu_w1),a
		ld	a, c
		out	(port_y), a		; restore modify ports
		ret

;[]=======================================================================[]
HelpString:
		db	cr,lf
		db	"The 256color! Mini demo for Sprinter.",cr,lf
		db	"Created by Enin Anton.",cr,lf,0

code_end:

		savebin "256color.exe",start_addr,code_end-start_addr
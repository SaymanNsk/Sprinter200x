
;universal color print to console procedure like printf()
;in: DE
cPrint:		ld iyh,d
		ld iyl,e
		ld l,(iy)		; at iy we have pointer to format string
		ld h,(iy+1)

loop:		ld a,(hl)
		inc hl
		or a
		jr z,nprtd
		cp '%'
		jr z,loc3
loc4:		call outch
		jp loop
nprtd:		ret

loc3:		ld a,(hl)
		inc hl
		cp '%'
		jr z,loc4
		dec hl
		call scan_length		; scan [-][0][0-9*][lL]
loop1:		ld a,(hl)
		inc hl

		cp 'd'
		jp z,prt_d
		cp 'D'
		jp z,prt_d			; signed decimal
		cp 'u'
		jp z,prt_u
		cp 'U'
		jp z,prt_u			; unsigned decimal
		cp 'l'
		jp z,prt_l
		cp 'L'
		jp z,prt_l
		cp 'x'
		jp z,prt_x1
		cp 'X'
		jp z,prt_x2			; hexadecimal
		cp 'c'
		jp z,prt_c
		cp 'C'
		jp z,prt_c			; print single character
		cp 'o'
		jp z,prt_o
		cp 'O'
		jp z,prt_o			; octal
		cp 's'
		jp z,prt_s
		cp 'S'
		jp z,prt_s			; string
		jp loop


; %l - long
prt_l:		ld (flong),a
		inc hl
		jp loop1

; %c  symbol
prt_c:		ld	a,(iy+2)
		call	outch
;		ld	de,(nprtd+1)
;		inc	de
;		ld	(nprtd+1),de
prt_q:		inc	iy
		inc	iy
		ld	a,(flong)
		or	a
		jp	z,loop			; false
		inc	iy
		inc	iy
		jp	loop

; %s  string
prt_s:
		ld	a,' '
		ld	(padch),a
		push	hl
		push	iy
		ld	l,(iy+2)
		ld	h,(iy+3)
fmt0:
		push	hl
		call	_strlen
		ex	de,hl
		ld	hl,(flen)
		ld a,h
		or l
		jr z, fmt01
;		call _pad
 ;		or	a
		sbc	hl,de
		ld	(flen),hl
		ld	a,(fladj)
		or	a
		call	z,_pad
fmt01:
		pop	hl
fmt1:		ld	a,(hl)
		inc	hl
		or	a
		jr	z,fmt21
		call	outch
;		ld	de,(nprtd+1)
;		inc	de
;		ld	(nprtd+1),de
		jp	fmt1

fmt2:
		ld	hl,(flen)
		ld	a,(fladj)
		or	a
		call	nz,_pad
fmt21:		pop	iy
		pop	hl
		jp	prt_q

; %u  unsigned decimal
prt_u:		push	hl
		push	iy
		call	getnum
		jr	fmt4

; %d  signed decimal
prt_d:		push	hl
		push	iy
		call	getnum
		ld	a,(flong)
		or	a
		jr	nz,fmt3			; true
		bit	7,h
		jr	z,fmt3
		ld	de,-1
fmt3:		bit	7,d
		jr	z,fmt4
		ld	a,'-'
		ld	(sign),a
		xor	a
		sub	l
		ld	l,a
		ld	a,0
		sbc	a,h
		ld	h,a
		ld	a,0
		sbc	a,e
		ld	e,a
		ld	a,0
		sbc	a,d
		ld	d,a
fmt4:		ld	a,10			; base
		ld	bc,char1
		call	mk_num
		jp	fmt0

; %o  octal
prt_o:		push	hl
		push	iy
		call	getnum
		ld	a,8			; base
		ld	bc,char1
		call	mk_num
		jp	fmt0

; %X  hex
prt_x2:		ld	bc,char1
prt_x:		push	hl
		push	iy
		call	getnum
		ld	a,16			; base
		call	mk_num
		jp	fmt0

; %x  hex
prt_x1:		ld	bc,char2
		jr	prt_x

;---------------------------------------
getnum:		xor	a
		ld	(sign),a
		ld	l,(iy+2)
		ld	h,(iy+3)
		ld	a,(flong)
		or	a
		jr	z,gnu1			; false
		ld	e,(iy+4)
		ld	d,(iy+5)
		ret
gnu1:		ld	de,0
		ret


mk_num:	ld	(mn0+1),a		; base
	ld	(chars+1),bc
	exx
	ld	hl,number
	exx
	call	mn0
	exx
	ld	(hl),0
	exx
	ld	hl,number
	ld	a,(sign)
	or	a
	ret	z
	dec	hl
	ret


mn0:	ld	bc,0x200a
	xor	a
mn1:	add	hl,hl
	rl	e
	rl	d
	rla
	cp	c
	jr	c,mn2
	sub	c
	inc	l
mn2:	djnz	mn1
; DEHL-quot; A-rem
	push	af
	ld	a,d
	or	e
	or	h
	or	l
	call	nz,mn0
	pop	af
	push	hl
chars:	ld	hl,char1		; save char1 or char2
	ld	c,a
	ld	b,0
	add	hl,bc
	ld	a,(hl)
	pop	hl
	exx
	ld	(hl),a
	inc	hl
	exx
	ret


scan_length:
	xor	a
	ld	(flong),a		; false
	ld	(fladj),a
	ld	(flen+0),a		; make length = 0
	ld	(flen+1),a
	ld	a,' '
	ld	(padch),a		; space padding by default
	ld	a,(hl)
	cp	'-'
	jr	nz,sl1
	ld	(fladj),a		; all will be LEFT adjusted, not right
	inc	hl
sl1:	ld	a,(hl)
	cp	'0'
	jr	nz,sl2
	ld	a,(fladj)
	or	a
	jr	nz,sl1a
	ld	a,'0'
	ld	(padch),a		; pad numbers with '0's, not spaces
sl1a:	inc	hl
sl2:	ld	de,0
sl2a:	ld	a,(hl)
	sub	'0'
	jr	c,sl3
	cp	9+1
	jr	nc,sl3
	ex	de,hl
	ld	c,l
	ld	b,h
	add	hl,hl
	add	hl,hl
	add	hl,bc
	add	hl,hl
	ld	b,0
	ld	c,a
	add	hl,bc
	ex	de,hl
	inc	hl
	jr	sl2a

sl3:	ld	(flen),de		; set explicit length
	ld	a,(hl)
	cp	'l'
	jr	z,sl4
	cp	'L'
	ret	nz
sl4:	ld	(flong),a		; true
	inc	hl
	ret


_pad:	dec	hl
	bit	7,h
	ret	nz
	push	hl
	ld	a,(padch)
	call	outch
	pop	hl
;	ld	de,(nprtd+1)
;	inc	de
;	ld	(nprtd+1),de
	jp	_pad


_strlen:	ex de,hl
		ld hl,0
.loop0:		ld a,(de)
		or a
		ret z
		inc hl
		inc de
		jr .loop0



;---------------------------------------
outch:
		push iy
		push hl
		cp cr
		jp z,.new_line
		cp lf
		jp z,.prtNullX
		cp tab
		jp z,.tabpr
		cp col_cmd
		jp z,.set_attr

.next0:		ex af,af
		ld de,(coords)
		ld a,(print_attr)
		ld b,a
		ex af,af'
		ld c,ESTEX_wrchar
		rst 0x10
		ld a,(coords)
		inc a
		cp 80				;координата по X 0..79 (итого 80)
		jr nc,.new_line			;на новую строку.
		ld (coords),a
.end_pr:	pop hl
		pop iy
		ret

.new_line:	ld a,(coords+1)			;Y
		cp 31
		jr c,.noscroll
		call .ScrollUP
		jr .prtNullX

.noscroll:	inc a
		ld (coords+1),a			;y

.prtNullX:	xor a
		ld (coords),a			;x
		jr .end_pr

.ScrollUP:	ld de,0
		ld hl,0x2050
		ld bc,0x0155
		xor a
		rst 0x10
		ret

.tabpr:		ld c,ESTEX_getcursor
		rst 0x10
		inc e				;x++
		ld a,e
		add a,8
		and 0x78
		ld e,a
		ld (coords),de
		ld c,ESTEX_setcursor
		rst 0x10
		jp .end_pr

;Set attribute
.set_attr:	ld a,(hl)
		ld (print_attr),a
		pop hl
		pop iy
		inc hl
		ret
;		jp .end_pr
				


char1:		db '0123456789ABCDEF'
char2:		db '0123456789abcdef'


flen:		dw	0
fladj:		db	0
flong:		db	0			; false/true
padch:		db	' '

sign:		db	0			; знак числа
number:		ds	16			; буфер числа

coords:		dw 0
print_attr:	db 7



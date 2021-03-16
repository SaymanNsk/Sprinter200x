;-------------------------------------------------------------------------------		
; DE = HLDE/BC, HL = HLDE%BC
;1456t
div32:
		ld a,10h
.div321:	sla e
		rl d
		adc hl,hl
		jr c, .div322
		sbc hl,bc
		jr nc, .div323
		add hl,bc
		dec a
		jr nz, .div321
		ret
.div322:	ccf
		sbc hl,bc
.div323:	inc de
		dec a
		jr nz, .div321
		ret
;-------------------------------------------------------------------------------
;hlde=hlde/512	;bc=остаток
div512:		ld c,e		;младшие 8 бит остатка
		ld b,0
		ld e,d
		ld d,l
		ld l,h
		ld h,b		;сдвинули делитель на 8 бит вправо
		srl l		;и ещё на 1
		rr d
		rr e
		rl b
		ret
;-------------------------------------------------------------------------------
;====================================
;	16 bit multiply
;====================================
;mul16:		ld hl,0
;mul_hlbc_de:	ld a,b
;		ld b,0x11
;		jr .mul16_3
;.mul16_1:	jr nc,.mul16_2
;		add hl,de
;.mul16_2:	rr h
;		rr l
;.mul16_3:	rra
;		rr c
;		djnz .mul16_1
;		ld b,a
;		ret

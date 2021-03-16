;Color settings
col_blue = 1
col_green = 2
col_violet = 3
col_red = 4
col_magenta = 5
col_brown = 6
col_white = 7

col_yellow = 10
col_white_light = 15

col_cmd = 16
		IFUSED ClearScr
ClearScr:	ld bc,0x0756			;c = ESTEX_clearscr
		ld de,0
		ld hl,0x2050
		ld a,space
		rst 0x10
		ld de,0
		SYS ESTEX_setcursor
		ld de,0
		ld (coords),DE
		ret
		ENDIF


;		IFUSED ScrBackup
;in:
;IX = buf addr
;ScrBackup:	ld de,0				;XY 0,0
;		ld hl,0x2050			;h,w: 32x80
;		ex af,af
;		in a,(mmu3)
;		ex af,af
;		SYS ESTEX_scrwincopy
;		ret
;		ENDIF
;
;
;		IFUSED ScrRestore
;;in:
;;IX = buf addr
;ScrRestore:	ld de,0				;XY 0,0
;		ld hl,0x2050			;h,w: 32x80
;		ex af,af
;		in a,(mmu3)
;		ex af,af
;		SYS ESTEX_scrwinrest

		IFUSED GetXY
GetXY:		SYS ESTEX_getcursor
		ld (coords),de
		ret
		ENDIF

		IFUSED SetXY
SetXY:		ld de,(coords)
		SYS ESTEX_setcursor
		ret
		ENDIF

		IFUSED Check_Vmode
;check for enabled TextMode
Check_Vmode:	SYS ESTEX_getvmode
		jr c,getvmodeErr
.next0:		ld (vmode),a			;current vmode
		ex af,af
		ld a,b
		ld (vmode.screen),a		;screen (0 or 1)
		ex af,af
		cp _VMODE._T80			;text 80x32 mode?
		jr nz,.set_t80_mode		;if no, then set it
		ret



.set_t80_mode:	ld a,_VMODE._T80
		ld b,0
		SYS ESTEX_setvmode
		jp c,setvmodeErr
		ret
		ENDIF


		IFUSED Return_Vmode
Return_Vmode:	ld a,(vmode)
		cp _VMODE._T80
		ret z
		ex af,af
		ld a,(vmode.screen)
		ld b,a
		ex af,af
		SYS ESTEX_setvmode
		jp c,setvmodeErr
		ret
		ENDIF


		IFUSED getvmodeErr
getvmodeErr:	PrintChars errGetvmodeMsg
		ld b,-1
		jp quit0
		ENDIF


		IFUSED setvmodeErr
setvmodeErr:	PrintChars errSetvmodeMsg
		ld b,-20
		jp quit0
		ENDIF

		IFUSED vmode
vmode:		db 0
.screen:	db 0
		ENDIF

;-------------------------------------------------------------
		IFUSED errGetvmodeMsg
errGetvmodeMsg:	db cr,lf
		db "ERROR: Failed to get video mode!",cr,lf
		db cr,lf,0
		ENDIF


		IFUSED errSetvmodeMsg
errSetvmodeMsg:	db cr,lf
		db "ERROR: Failed to set video mode!",cr,lf
		db cr,lf,0
		ENDIF
;-------------------------------------------------------------		

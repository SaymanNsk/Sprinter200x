;ฺออออออออออออออออออออออออออออออออออออออออออออออออฟ
;ณ FORMAT - Disk Format Utility for Sprinter      ณ
;ณ     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~             ณ
;ณ             by Sayman 2021		          ณ
;ภออออออออออออออออออออออออออออออออออออออออออออออออู
		DEVICE 	ZXSPECTRUM128

Start_addr = 0x8100
		include "..\..\include\estex_h.asm"
		include "..\..\include\head_short.inc"
		include "..\..\include\macro.s"
		include "build.inc"



LoaderStart:	jp main
;===================================================
		include "console.asm"
		include "printf.asm"
		include "muldiv.asm"
;===================================================

;[]=========================================================================[]
;[]       Converting latin symbols a...z to upper registry                  []
;[] IN: A  - symbol for convert                                             []
;[] OUT: A  - converted symbol                                              []
;[]=========================================================================[]
CapsLetter:	cp "a"                     ;<"a"
		jr c,.not_lat
		cp "z"+1                   ;>"z"
		jr nc,.not_lat
		and %11011111              ;set D5 for upper registry
		ret

.not_lat:	and a
		scf
		ret

;===================================================
main:		di
		push ix
		ld a,(ix-3)
		SYS ESTEX_fclose
		call Check_Vmode		;check text mode and (if not) set it
		call GetXY

		ld de,about_Msg.ptr
		call cPrint

		pop hl
		call ParseCL

		call confirmation
		ld de,Process_Msg.ptr
		call cPrint

		call prepare
		call calc_bpb
		call gen_serial

		ld bc,0x0105			;read 1 sector
		ld hl,0
		ld ix,0
		ld a,(FMTDISK)
		ld de,buff
		rst 0x18			;get start sector via read (drv)
		ld d,ixh			;this function return next sector
		ld e,ixl
		ld a,d
		or e
		jr nz,.next0
		dec hl
.next0:		dec de				;and correct it (-1)
		ld (BPB.hide_sectors+2),hl
		ld (BPB.hide_sectors),de
		ld hl,buff
		push hl
		ld de,buff+1
		ld bc,512
		xor a
		ld (hl),a
		ldir

		SYS ESTEX_getver
		push de
		ld a,d
		ld de,BPB.OEM+4
		call ConvNumTxt8
		pop de
		ld a,e
		ld de,BPB.OEM+6
		call ConvNumTxt8

;write boot sector, init first FAT sector, write it
;clear buff (zeroed), write other FAT sectors
;repeat for FAT copy
;write zeroed ROOT directory
		ld ix,0
		ld hl,0				;boot sector
		ld a,(FMTDISK)
		ld bc,0x0106			;save boot sector
		ld de,BPB
		rst 0x18

		call init_fat
		ld ix,(BPB.reserved_secs)
		ld hl,0
		push ix
		push hl
		call wr_fat0			;write first sector of FAT
		call clear_buff
		pop hl
		pop ix
		inc ix				;next FAT sector
		call wr_fat1			;write other FAT sectors
		call init_fat
		ld ix,(BPB.reserved_secs)	;low bits
		ld de,(BPB.fat_sectors)
		add ix,de
		ld hl,0
		push hl
		push ix
		call wr_fat0
		call clear_buff
		pop ix
		pop hl
		push hl
		push ix
		inc ix
		call wr_fat1
		pop ix
		pop hl
		ld de,(BPB.fat_sectors)
		add ix,de
		ld a,(BPB.root_size)
		ld b,a
		call wr_fat1.loop0

		ld de,ProcessOK_Msg.ptr
		call cPrint

		call showInfo


                call Return_Vmode
		xor a
		ld b,a
		jp quit0


wr_fat0:	ld a,(FMTDISK)
		ld bc,0x0106			;save FAT sector
		ld de,buff
		rst 0x18			;next sector not returned!!!
		ret


wr_fat1:	ld a,(BPB.fat_sectors)
		ld b,a
		dec b				;-first FAT sector
.loop0:		push bc
		push hl
		push ix
		ld bc,0x0106
		ld a,(FMTDISK)
		ld de,buff
		rst 0x18
		pop ix
		pop hl
		pop bc
		inc ix				;next sector (low)
		djnz .loop0
		ret



init_fat:	ld hl,buff
		ld (hl),0xf8			;init FAT
		inc hl
		ld (hl),0xff			;first 2 reserved clusters
		inc hl
		ld (hl),0xff
		inc hl
		ld a,(fat12_flg)
		ret nz
		ld (hl),0xff			;0xfff8, 0xffff for FAT16
		ret


clear_buff:	ld hl,buff
		ld de,buff+1
		ld bc,512
		xor a
		ld (hl),a
		ldir
		ret



showInfo:	ld hl,(sectors+2)
		ld de,(sectors)
		push hl
		push de
		ld (DskInfo_Msg.sectors),de
		ld (DskInfo_Msg.sectors+2),hl
		ld a,(BPB.cluster_size)
		rra
		ld b,0
		ld c,a
		jr nc,.next0
		ld bc,512
		ld a,"B"
		ld (DskInfo_Msg.u_sym),a
.next0:		ld (DskInfo_Msg.u_size),bc
		pop de
		pop hl
		ld c,e				;/256
		ld e,d
		ld d,l
		ld h,0
		ld b,h
		srl d				;/8
		rr e
		srl d
		rr e
		srl d
		rr e
		ld (DskInfo_Msg.mb),de
		ld hl,(BPB.serial_id)
		ld de,(BPB.serial_id+2)
		ld (DskInfo_Msg.serial),hl
		ld (DskInfo_Msg.serial+2),de
		ld a,(fat12_flg)
		or a
		jr z,.next1
		ld a,"2"
		ld (DskInfo_Msg.FS+20),a
.next1:		ld de,DskInfo_Msg.ptr
		call cPrint
;bugfix with last printed line with colors
;scrolling in console set color column...
		call GetXY			;get YX in DE
		ld hl,0x0150
		ld b,d
		ld c,e
		call winClearScr

		ret




;===================================================
;need to get the size of the disk in sectors and check for FAT12 limitation
prepare:	ld a,(FMTDISK)
		ld bc,0x0008			;B = subcommand, C = IOCTL func.
		ld de,0x55aa			;IOCTL requires Magic num
		rst 0x18			;HLDE = disk size in sectors
		ld (cfg),a
		ld a,c
		and 0x80
		ld (BPB.drv_code),a
		ex af,af
		ld a,h
		or l
		call testDskSize
		exx
		ld (BPB.sec_per_trk),bc
		ld (BPB.heads),de
		exx
		ret



;calculate boot sector (BPB) parameters
calc_bpb:	ld de,(BPB.root_size)
		ld b,5
.loop0:		rl d
		rl e
		djnz .loop0			;root_size (256) * 32 (element size)
		ld hl,0
		call div512			;root_size/512 (sector size)
		ld (rootSectors),de		;root size in sectors	
		ld hl,(sectors)
		ld de,(sectors+2)
		ld bc,(BPB.reserved_secs)
		sbc hl,bc
		ex de,hl
		ld bc,0
		sbc hl,bc
		ld bc,(clusters)
		push hl
		push de
		call div32			;(sectors-reserved_sectors) / max_clusters
		and a				;clear flags
		ld bc,0x0780			;max 64 sectors for cluster
		ld a,e
.loop1:		rlc c				;128 sectors (64kb) not supported
		cp c
		jr c,.next_calc0
		djnz .loop1
.next_calc0:	ld a,c
		ld (BPB.cluster_size),a		;cluster size in sectors
		pop de
		pop hl
		ld b,0
		call div32
		push de
		ld de,(BPB.reserved_secs)
		add hl,de			;+reserverd sectors
		ld (BPB.reserved_secs),hl
		pop de
		ld a,(fat12_flg)
		or a
		jr z,.calc_fat16
		ld h,d
		ld l,e
		add hl,hl
		add hl,de			;*3
		srl h
		rr l				;/2
		ex de,hl
		ld hl,0
		jr .next_calc1
.calc_fat16:	ld hl,0
		rl e
		rl d
		rl l
		rl h
.next_calc1:	call div512
		ld a,b
		or c
		jr z,.next_calc2
		inc de
.next_calc2:	ld (BPB.fat_sectors),de
		ex de,hl
		add hl,hl
		ld b,h
		ld c,l
		ex de,hl
		ld hl,(sectors)
		ld de,(sectors+2)
		sbc hl,bc
		ex de,hl
		ld bc,0
		sbc hl,bc
		ex de,hl
		ld bc,(BPB.reserved_secs)
		sbc hl,bc
		ex de,hl
		ld bc,0
		sbc hl,bc
		ex de,hl
		ld bc,(rootSectors)
		sbc hl,bc
		ld bc,0
		ex de,hl
		sbc hl,bc
		ld a,(BPB.cluster_size)
		ld b,0
		ld c,a
		call div32
		ld (DskInfo_Msg.units),de
		ld de,(BPB.reserved_secs)
		add hl,de
		ld (BPB.reserved_secs),hl
		ret
		
		
		
		





testDskSize:	ld (sectors),de
		ld (sectors+2),hl		;save temporary sectors
		jr nz,.bigdsk
		push hl
.tstsmall:	ld bc,0xf800+1			;else, check for fat16 <32M
		ld h,d				;save in DE small sectors
		ld l,e
		sbc hl,bc
		pop hl
		jr nc,.bigdsk			;>32M (set Flag)
		ld bc,0x7800+1			;else check for limit for fat12
		ex de,hl			;15M
		ld (BPB.small_sectors),hl
		sbc hl,bc
		ret nc				;>15M
		xor a
		inc a
		ld (fat12_flg),a
		ld a,'2'
		ld (BPB.fat_id+4),a
		ld bc,0x0fef
		ld (clusters),bc
		ret
.bigdsk:	ex af,af
		ld (BigDskFlg),a
		ld (BPB.big_sectors),de
		ld (BPB.big_sectors+2),hl
		ret
		





gen_serial:	call Randomize
		call GetRnd
		ld (BPB.serial_id),a		;first 8bit (2 bits sec. 6 bits min.)
		ld l,a
		call GetRnd
		ld h,a
		push hl
.year:		ld l,0
		ld a,r
		rra
		xor l
		ld (BPB.serial_id+1),a
		call Rand16
		pop bc
		add hl,bc
		ld (BPB.serial_id+2),hl
		ret




;<Vadim> from PQ-DOS formatter
Randomize:	SYS ESTEX_systime_get
		ld a,b			;seconds
		ld (rand1),a
		ld a,l			;minutes
		ld (rand2),a
		ld a,ixl
		ld (gen_serial.year+1),a
		ld a,r
		rra
		ld (rand3),a
		call GetRnd
		ld l,a
		call GetRnd
		ld h,a
		ld (seed),hl
		ret


GetRnd:		ld a,(rand1)
		ld d,a
		ld a,(rand2)
		ld (rand1),a
		add a,d
		ld d,a
		ld a,(rand3)
		ld (rand2),a
		add a,d
		rrca
		ld (rand3),a
		ret


Rand16:		ld de,(seed)	;Seed is usually 0
		ld a,d
		ld h,e
		ld l,253
		or a
		sbc hl,de
		sbc a,0
		sbc hl,de
		ld d,0
		sbc a,d
		ld e,a
		sbc hl,de
		jr nc,Rand
		inc hl
Rand:		ld (Rand16+1),hl
		ret


;</Vadim>	



ParseCL:	ld a,(hl)			;cmd line size
		or a				;0 = no params
		jp z,Usage			;goto help message
		inc hl
		inc hl				;first param
		ld a,(hl)
		ld c,a
		inc hl
		ld a,(hl)
		cp ':'				;must be dsk: (like C:)
		jp nz,Usage			;if not, goto help message
		ld a,c
		call CapsLetter
		jp c,Usage			;drive letter is not a letter
		or a				;no drive A (fdd)
		jp z,Usage
		dec a				;no drive B (fdd)
		jp z,Usage
		inc a
		ld (warn_Msg.dsk),a		;store it in messages
		ld (Process_Msg.dsk),a		;*
		sub 'A'
		ld (FMTDISK),a
.loop_x:	inc hl
		ld a,(hl)
		or a
		ret z
		cp space
		jr nz,.loop_x

.loop1:		cp "/"
		jr z,.next0
		cp "-"
		jr z,.next0
                jp Usage

.next0:		inc hl
		ld a,(hl)
		cp "?"
		jp z,Usage
		pop hl
		jp Usage



confirmation:	call GetXY
		ld de,warn_Msg.ptr
		call cPrint
		ei
		halt
		SYS ESTEX_waitkey
		di
		res 5,a
		cp "Y"
		ld a,0
		jp nz,quit0				;exit to DOS
		call PrintLF
		ret

PrintLF:	PrintChar cr
		PrintChar lf
		ret	

;---------------
;from FN
;Convert 8bit num to text
;IN:
;	A - 8 bit num
;	DE - buffer
;---------------
ConvNumTxt8:	PUSH	IX
		PUSH	BC
		LD	IX,ConvertFlg
		RES	7,(IX+#00)
		LD	C,100
		CALL	ConNumb8
		LD	C,10
		CALL	ConNumb8
		ADD	A,"0"
		LD	(DE),A
		INC	DE
		POP	BC
		POP	IX
		RET

ConNumb8:	LD	B,#2F
		INC	B
		SUB	C
		JR	NC,$-2
		ADD	A,C
		EX	AF,AF'
		LD	A,B
		CP	#30
		JR	Z,$+6
		SET	7,(IX+#00)
		BIT	7,(IX+#00)
		JR	Z,$+4
		LD	(DE),A
		INC	DE
		EX	AF,AF'
		RET

ConvertFlg:	db	#0
		

		

;-------------------------------------------------------------------------------
badClustErr:	PrintChars badClust_Msg
		ld b,-2
		jr quit0

Usage:		ld de,usage_Msg.ptr
		call cPrint
;		PrintChars usage_Msg
		ld b,-1

quit0:		SYS ESTEX_exit
		jp $
;===================================================
FMTDISK:	db 0				;formatting disk
BigDskFlg:	db 0				;big disk (>32Mb) flag
cfg:		db 0
rootSectors:	dw 0
sectors:	ds 4				;tmp value of sectors on the disk
clusters:	dw 0xffef
fat_sectors:	dw 0
system_sectors:	dw 0
fat12_flg:	db 0
serial:		dw 0,0				;Volume Serial Number

rand1:		db 0
rand2:		db 0
rand3:		db 0
seed:		db 0


		align 256

BPB:
.JMP:		db 0xeb, 0x3c, 0x90
;OEM:		db "MSDOS5.0"
.OEM:		db "DSS_ .  "
.sector_size:	dw 512		;+11		; sector size in bytes
.cluster_size:	db 0		;+13		; cluster size in sectors
.reserved_secs:	dw 5		;+14		; reserved sector
.fat_ncopy:	db 2		;+16		; # copy`s of FAT
.root_size:	dw 256		;+17		; root size (records on root)
.small_sectors:	dw 0		;+19		; # of sectors (<32Mb)
.media_id:	db 0xf8		;+21		; Media ID
.fat_sectors:	dw 0		;+22		; # sectors for one copy of FAT
.sec_per_trk:	dw 0		;+24		; sectors per track
.heads:		dw 0		;+26		; # of heads
; extended boot-record
.hide_sectors:	ds 4		;+28		; # of hidden sectors
.big_sectors:	ds 4		;+32		; # of sectors (>32Mb)
.drv_code:	dw 0x80		;+36		; drive code (0x80 for HDD)
.eboot_sig:	db 0x29		;+38		; extended boot signature (?)
.serial_id:	ds 4		;+39		; Volume serial
.vol_name::	db "NO NAME    "		; Volume label
.fat_id:	db "FAT16   "			; FAT id (FAT12 or FAT16)

BPBsize = $-BPB
		incbin "x86_boot.bin"
		




;===================================================
about_Msg:	db cr,lf,"Format utility version 0.3.",BUILD_COUNT_T," (",BUILD_DAY_T,".",BUILD_MONTH_T,".",BUILD_YEAR_T,")"
		db cr,lf,"by Miroshnichenko Alexander aka Sayman@SprinterTeam",cr,lf,0
.ptr:		dw about_Msg


usage_Msg:	db cr,lf,"Utility make a logical formatting and initialize the file system on the disks."
;		db cr,lf,"initialize the file system on the disks."
		db cr,lf,col_cmd, col_red, "WARNING!!!", col_cmd, col_white," This version is limited for ", col_cmd, col_green, "2GB", col_cmd, col_white," for FAT16 FS!"
		db cr,lf,cr,"usage:"
		db cr,lf,"FORMAT volume [key1] [key2] [keyN]"
		db cr,lf,"   keys are:"
		db cr,lf,tab,"in this version supported only /? key for help."
		db cr,lf,cr,lf,0
.ptr:		dw usage_Msg



warn_Msg:	db cr,lf,cr,lf, col_cmd, col_red, "WARNING: ALL DATA ON YOR HARD DISK DRIVE ", col_cmd, col_violet, "%c:", col_cmd, col_red," WILL BE LOST!", col_cmd, col_white,cr,lf
		db cr,lf,"Proceed with Format [Y/N]?",0
.ptr:		dw warn_Msg
.dsk:		db 0

Process_Msg:	db cr,lf
		db cr,lf,"Quick formatting disk %c:...",0
.ptr:		dw Process_Msg
.dsk:		db 0

ProcessOK_Msg:	db "Done.",cr,lf,cr,lf,0
.ptr:		dw ProcessOK_Msg


DskInfo_Msg:	db "Formatted disk parameters:",cr,lf
		db "Total sectors: ", tab, col_cmd, col_magenta, "%lu",col_cmd, col_white, cr,lf
		db "Total size: ", tab, col_cmd, col_magenta, "%uMb", col_cmd, col_white, cr,lf
		db "Units: ", tab,tab, col_cmd, col_magenta, "%u", col_cmd, col_white, cr,lf
		db "Unit size: ", tab, col_cmd, col_magenta, "%u%c", col_cmd, col_white, cr,lf
.FS:		db "File system: ", tab, col_cmd, col_magenta, "FAT16", col_cmd, col_white, cr,lf
		db "Serial: ", tab, col_cmd, col_magenta, "%02x-%02x", col_cmd, col_white, cr,lf
		db "Label: ", tab, tab, col_cmd, col_magenta, "NO LABEL", col_cmd, col_white, cr,lf,cr,lf,0
.ptr:		dw DskInfo_Msg
.sectors:	ds 4
.mb:		dw 0
.units:		dw 0
.u_size:	dw 0
.u_sym:		db "K",0
.serial:	ds 4






badClust_Msg:	db cr,lf,"Bad cluster size.",cr,lf,cr,lf,0

;WARNING: ALL DATA ON YOR HARD DISK DRIVE Z: WILL BE LOST!

		align 256
buff:
;		equ ($/80h)*80h+80h


		DISPLAY "programm size: ", $-EXEHeader
Loader_End:
		DISPLAY "last address: ", $
		savebin "format.exe",EXEHeader,$-EXEHeader

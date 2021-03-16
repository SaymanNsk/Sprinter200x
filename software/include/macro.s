;-------------------------------------------------------------------------------
	MACRO SYS func
		ld c,func
		rst 0x10
	ENDM

	MACRO PrintChars str_data_ptr		;указатель на строку с символами
		ld hl,str_data_ptr
		SYS ESTEX_pchars
	ENDM

	MACRO PrintChar char			;символ
		ld a,char
		SYS ESTEX_pchar
	ENDM

	macro BIOS function_code
		ld c,function_code
		rst 8	
	endm

;ACCELERATOR

	macro ACC_ON
		ld d,d
	endm

	macro ACC_OFF
		ld b,b
	endm

	macro ACC_FILL
		ld c,c
	endm

	macro ACC_FILL_GFX
		ld e,e
	endm

	macro ACC_COPY
		ld l,l
	endm

	macro ACC_COPY_GFX
		ld a,a
	endm


;	macro DSS_OpenFile mode, filename
;		ld hl,filename
;		ld b,mode
;		Estex fopen
;	endm

;	macro DSS_ReadFile dst, size
;		ld hl,dst
;		ld de,size
;		Estex fread
;	endm
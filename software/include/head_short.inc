		org Start_addr - (EXEHeader_end-EXEHeader)

EXEHeader:
		
		db "EXE"
		db 0
		dw LoaderStart-EXEHeader
		dw 0
		dw Loader_End-LoaderStart
		dw 0,0,0
		dw LoaderStart
		dw LoaderStart
		dw 0xbfff
EXEHeader_end:

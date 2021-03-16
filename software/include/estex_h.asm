;------------------------------
;Estex DOS system api codes
;!!!��� ������ ������� ���������� ����� ������� C!!!
;!!!���� ����� ������� ��������� �����, �� ���� ����� �������� � ��������!!!
;------------------------------

ESTEX_getver = 0x00			;�������� ������ ����

ESTEX_chdisk = 0x01			;����� �������� �����
ESTEX_curdisk = 0x02			;�������� ������� ����
ESTEX_diskinfo = 0x03			;���� � �����
ESTEX_DEVRESCAN = 0x08			;��������������� ��� ������� (�����).
ESTEX_bootdisk = 0x09			;�������� ��� ���������� ��������� ����

ESTEX_fcreate = 0x0a			;������� ���� (� ���������� �������)
ESTEX_fcreate_new = 0x0b		;������� ���� (� ������� ���� ������ ���� ����)
ESTEX_fdelete = 0x0e			;������� ����
ESTEX_frename = 0x10			;������������� ����
ESTEX_fopen = 0x11			;������� ����
ESTEX_fclose = 0x12			;������� ����
ESTEX_fread = 0x13			;��������� ������ �� �����
ESTEX_fwrite = 0x14			;�������� � ����
EXTEX_fmovefp = 0x15			;����������� ��������� � �����
ESTEX_fattribute = 0x16			;�������� �/��� �������� ��������
ESTEX_fget_dt = 0x17			;�������� ���� �����
ESTEX_fset_dt = 0x18			;���������� ���� �����
ESTEX_find_first = 0x19			;����� �������...
ESTEX_find_next = 0x1a			;����� ����������

ESTEX_mkdir = 0x1b			;������� �������
ESTEX_rmdir = 0x1c			;������� �������
ESTEX_chdir = 0x1d			;������� �������
ESTEX_curdir = 0x1e			;�������� ������� �������

ESTEX_systime_get = 0x21		;�������� ��������� �����
ESTEX_systime_set = 0x22		;���������� ��������� �����

ESTEX_setmemwin = 0x38			;����������� �������� ������
ESTEX_setmemwin1 = 0x39			;����������� �������� ������ � 1 ����
ESTEX_setmemwin2 = 0x3a			;����������� �������� ������ � 2 ����
ESTEX_setmemwin3 = 0x3b			;����������� �������� ������ � 3 ����
ESTEX_getmeminfo = 0x3c			;�������� ���������� � ������
ESTEX_getmem = 0x3d			;��������� (��������) ���� ������
ESTEX_freemem = 0x3e			;���������� ���� ������
ESTEX_setmem = 0x3a			;�������� ���� ������

ESTEX_waitkey = 0x30			;�������� ������� � ����������
ESTEX_scankey = 0x31			;����� ���������� ��� ��������
ESTEX_echokey = 0x32			;�������� ������� � ���������� � �������
ESTEX_keystat = 0x33			;�������� ��������� ����������
ESTEX_clearkey = 0x35			;�������� ����� ���������� � ��������� �������
ESTEX_keyset = 0x36			;���������� ����������� ����������
ESTEX_testkey = 0x37			;����� ������ ����������

ESTEX_exec = 0x40			;��������� ����
ESTEX_exit = 0x41			;���������� ���������
ESTEX_wait = 0x42			;�������� ��� ���������� ���������

ESTEX_cmd_getswitch = 0x43		;�������� �������� ��������� ������
ESTEX_cmd_dosname = 0x44		;������������� ��� �����
ESTEX_cmd_parse = 0x45			;������ ��������� ������

ESTEX_env = 0x46			;��������� ���������

ESTEX_appinfo = 0x47			;��������� ���������� ����������

ESTEX_setvmode = 0x50			;����� ������ ������
ESTEX_getvmode = 0x51			;�������� ������� ����� ������
ESTEX_setcursor = 0x52			;���������� ������� �������
ESTEX_getcursor = 0x53			;�������� ������� ������� �������
ESTEX_setscr = 0x54			;������� �������� �������� ������
ESTEX_scrollscr = 0x55			;��������� ����
ESTEX_clearscr = 0x56			;������� ����
ESTEX_rdchar = 0x57			;������� ������ � ������
ESTEX_wrchar = 0x58			;���������� ������ �� ������
ESTEX_scrwincopy = 0x59			;��������� ���� ������
ESTEX_scrwinrest = 0x5a			;������������ ���� ������
ESTEX_pchar = 0x5b			;���������� ������ � ������� ������� �������
ESTEX_pchars = 0x5c			;���������� ������ �������� � ������� ������� �������

;-------------------------------------------
_ENVIRONMENT:
._GET_SYS = 0				;�������� ��������� ���������
._GET_VAL = 1				;�������� ��������� ��������� ����������
._SET_ENV = 2				;���������� ����������

;-------------------------------------------
_CMD_PARSE:
._PARSE_CMD = 0				;��������� ������
._GET_DSK = 1				;�������� ��� �����
._GET_DIR = 2				;�������� ����������
._GET_FILENAME = 3			;�������� ��� �����
._GET_FILE_EXT = 4			;�������� ���������� �����
._GET_FULL_FILEPATH = 5			;�������� ��� �����, ���� � �����, ��� ����� � ���������� �����
._NOFUNC = 6				;���������������
._SELECT_ARG = 7			;�������� �������� ��������� ������
._CONV_TO_DOS = 8			;������������� �� 11 ����������� ������� � ������ ���
._CONF_FROM_DOS = 9			;������������� �� ������� ��� � 11 ���������� ������

;--------------------------------------------
_FOPEN:
._IORW = 0				;������� ��� ������ � ������
._IOREAD = 1				;������� ������ ��� ������
._IOWRITE = 2				;������� ��� ������

;--------------------------------------------
_MOVEFP:
._SEEK_SET = 0				;�� ������ �����
._SEEK_CUR = 1				;�� �������� �������� ���������
._SEEK_END = 2				;�� ����� �����

_VMODE:
._T40 = 0x02				;��������� ����� 40 ��������
._T80 = 0x03				;��������� ����� 80 �������
._320p = 0x81				;����������� ����� 320*256*8���
._640p = 0x81				;����������� ����� 640*256*4���
._SCREEN0 = 0x0				;�������� ������ 0
._SCREEN1 = 0x01			;�������� ������ 1

._normal = 0x50				;����� ������ - ������� (��� ������ � RAM � VRAM)
._transparent = 00001000b		;����� ������ � ���������� ������ (0xff ������������)
._spr = 00000100b			;����� ������� (������ �������� ������ � VRAM)

;--------------------------------------------
mmu0 = 0x82				;cpu window 0 = addr 0x0000
mmu1 = 0xa2				;... 1 = 0x4000
mmu2 = 0xc2				;... 2 = 0x8000
mmu3 = 0xe2				;... 3 = 0xc000

port_y = 0x89				;port for Y coord
rgmod = 0xc9				;����������� �������� ������
border = 0xfe				;������
rgscr = 0xe9
rgacc = 0xa9

;sys_port3c	equ 3ch
;sys_port7c	equ 7ch
sys_port_on = 0x7c
sys_port_off = 0x3c

d_tbon = 3				; ������ ��� ��������� turbo
d_tboff = 2				; ������ ��� ���������� turbo
d_rom16on = 1
d_rom16off = 0

cnf_page = 0x40				;������ �� ������ ����!!!

;com port
CTC_CHAN0 = 0x10
CTC:
._CHAN0 = 0x10
._CHAN1 = 0x11
._CHAN2 = 0x12
._CHAN3 = 0x13


SIO:
.DATA_REG_A = 0x18
.CONTROL_A = 0x19
.DATA_REG_B = 0x1a
.CONTROL_B = 0x1b

;lpt port
PIO:
.DATA_REG_A = 0x1c
.COMMAND_REG_A = 0x1d
.DATA_REG_B = 0x1e
.COMMAND_REG_B = 0x1f

;ISA-8
;-------------------------------------------------------------------------------
;If you want to interaction with ISA devices, you have to make following steps:
;1) send 10h value to port 1FFDh(system port);
;2) send control byte to port 0E2h(third memory window port);
;control byte:
;D7...should be 1
;D6...should be 1
;D5...should be 0
;D4...should be 1
;D3...should be 0
;D2...specify access mode (0 - ISA memory, 1 - ISA ports)
;D1...specify number of ISA slot
;D0...should be 0
;fixed bug with D2 and D1 bits (functional exchange, but not documented).

;The read/write signals are forming from read/write signals memory range 0C000h-0FFFFh.
;And the address lines A13...A0 has taken from processor data-BUS.
;The other ISA-signals such as RESET, AEN, A19...A14 can be set in port 9FBDh. And default value is 00h.
;port 9FBDh:
;D7...RESET, 1=reset, 0=normal
;D6...AEN, 1=
;D5...A19
;D4...A18
;D3...A17
;D2...A16
;D1...A15
;D0...A14
sc_port = 0x1ffd
ISA:
.DIR = 0x9fbd
.BASE_ADDR = 0xc000
.SLOT0_RAM = 0xd0
.SLOT1_RAM = 0xd2
.SLOT0_PORT = 0xd4
.SLOT1_PORT = 0xd6

;VMODE:
;._normal = 0x50			;����� ������ - ������� (��� ������ � RAM � VRAM)
;._transparent = 00001000b		;����� ������ � ���������� ������ (0xff ������������)
;._spr = 00000100b			;����� ������� (������ �������� ������ � VRAM)

cr = 0x0d				;������� �������
lf = 0x0a				;����� ������
space = 0x20				;������ �������
tab = 0x09				;������ ���������



;--------------------------------------------
;BIOS
BIOS_reset_drive = 0x51			; ����� ����������� � ��������� �� ����
BIOS_rd_sector = 0x55			; ������ (��������) � ����������.
BIOS_wr_sector = 0x56			; ������ (��������) �� ����������.
BIOS_get_drv_list = 0x5f		; �������� ������ �������� ���������
BIOS_get_cursor_coords = 0x8e		; �������� ������� ��������� (�������) ������ �� �����.
BIOS_get_mem_pg = 0xc4			; �������� ���. ����� ���. �����
BIOS_get_pg_tbl = 0xc5			; get pages table from handle (id_blk)
BIOS_clear_scr = 0x8d			; ������� ������, ��������� ������� ����������
BIOS_get_cursor = 0x8e			; ������ �����. �������
BIOS_set_cursor = 0x84			; ���. �����. �������
BIOS_print_chars = 0x82			; ����� �������� �� ����� � �������� ���������� ��� ���������
BIOS_screen_save = 0xb2			; ��������� �����...
BIOS_screen_restore = 0xb3		; ������������ �����...
BIOS_screen_get_char = 0xb4		; ��������� (�����) ������ � ������
BIOS_screen_set_char = 0xb5		; ���������� ������ �� ������
BIOS_screen_move = 0xb7			; ����������� ���� (������)

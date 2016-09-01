;-------------------------
;dss functions defines
;file functions
fopen		equ 11h
fclose		equ 12h
fread		equ 13h
fwrite		equ 14h
move_fp		equ 15h
fgetattr	equ 16h
fgetdt		equ 17h
fsetdt		equ 18h
fcreate		equ 0ah
fcreaten	equ 0bh
chdir		equ 1dh
curdir		equ 1eh
curdisk		equ 2

_IORW		equ 0
_IOREAD		equ 1
_IOWRITE	equ 2

;memory functions
setwin		equ 38h
setwin1         equ 39h
setwin2		equ 3ah
setwin3		equ 3bh
infomem		equ 3ch
getmem		equ 3dh
setmem		equ 3fh
freemem		equ 3eh
;keyb functions
waitkey		equ 30h
scankey		equ 31h
echokey		equ 32h
quit            equ 41h
getarg		equ 43h
;vmode functions
setvmode	equ 50h
getvmode	equ 51h
selvpage	equ 54h
;screen and text functions
pchar		equ 5bh
pchars		equ 5ch
;other
getver		equ 0
systime		equ 21h
;end dss defines
;-------------------------
;hardware defines
port_y		equ 89h		;port for Y coord
_320p		equ 81h		;320 pixels mode
rgmod		equ 0c9h
border		equ 0feh
rgscr		equ 0e9h
rgacc		equ 0a9h

norm_scr	equ 50h
;trans_scr	equ 54h
trans_scr	equ 00001000b
tmp_scr		equ 00000100b


e_cache		equ 0fbh
d_cache		equ 7bh
sys_port3c	equ 3ch
sys_port7c	equ 7ch

cpu_w0		equ 82h		;cpu window 0 = addr 0000h
cpu_w1		equ 0a2h	;... 1 = 4000h
cpu_w2		equ 0c2h	;... 2 = 8000h
cpu_w3		equ 0e2h	;... 3 = 0c000h
;end hardware defines
;-------------------------
;characters
cr		equ 0dh
lf		equ 0ah
tab		equ 9
space		equ 20h
;------------------------
sys_port_on	equ 0x7c
sys_port_off	equ 0x3c
d_tbon		equ 3		; данные для включения turbo
d_tboff		equ 2		; данные для включения turbo


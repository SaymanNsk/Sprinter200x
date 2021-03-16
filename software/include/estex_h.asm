;------------------------------
;Estex DOS system api codes
;!!!Все номера функция передаются через регистр C!!!
;!!!Если номер функции передаётся иначе, об этом будет сообщено в описании!!!
;------------------------------

ESTEX_getver = 0x00			;получить версию доса

ESTEX_chdisk = 0x01			;смена текущего диска
ESTEX_curdisk = 0x02			;получить текущий диск
ESTEX_diskinfo = 0x03			;инфа о диске
ESTEX_DEVRESCAN = 0x08			;пересканировать все девайсы (диски).
ESTEX_bootdisk = 0x09			;получить или установить системный диск

ESTEX_fcreate = 0x0a			;создать файл (с обнулением старого)
ESTEX_fcreate_new = 0x0b		;создать файл (с ошибкой если старый файл есть)
ESTEX_fdelete = 0x0e			;удалить файл
ESTEX_frename = 0x10			;переименовать файл
ESTEX_fopen = 0x11			;открыть файл
ESTEX_fclose = 0x12			;закрыть файл
ESTEX_fread = 0x13			;прочитать данные из файла
ESTEX_fwrite = 0x14			;записать в файл
EXTEX_fmovefp = 0x15			;переместить указатель в файле
ESTEX_fattribute = 0x16			;получить и/или изменить атрибуты
ESTEX_fget_dt = 0x17			;получить дату файла
ESTEX_fset_dt = 0x18			;установить дату файла
ESTEX_find_first = 0x19			;поиск первого...
ESTEX_find_next = 0x1a			;поиск следующего

ESTEX_mkdir = 0x1b			;создать каталог
ESTEX_rmdir = 0x1c			;удалить каталог
ESTEX_chdir = 0x1d			;сменить каталог
ESTEX_curdir = 0x1e			;получить текущий каталог

ESTEX_systime_get = 0x21		;получить системное время
ESTEX_systime_set = 0x22		;установить системное время

ESTEX_setmemwin = 0x38			;Подключение страницы памяти
ESTEX_setmemwin1 = 0x39			;Подключение страницы памяти в 1 окно
ESTEX_setmemwin2 = 0x3a			;Подключение страницы памяти в 2 окно
ESTEX_setmemwin3 = 0x3b			;Подключение страницы памяти в 3 окно
ESTEX_getmeminfo = 0x3c			;Получить информацию о памяти
ESTEX_getmem = 0x3d			;Запросить (получить) блок памяти
ESTEX_freemem = 0x3e			;Освободить блок памяти
ESTEX_setmem = 0x3a			;Изменить блок памяти

ESTEX_waitkey = 0x30			;Ожидание символа с клавиатуры
ESTEX_scankey = 0x31			;Опрос клавиатуры без ожидания
ESTEX_echokey = 0x32			;Ожидание символа с клавиатуры с печатью
ESTEX_keystat = 0x33			;Получить состояние клавиатуры
ESTEX_clearkey = 0x35			;Очистить буфер клавиатуры и выполнить функцию
ESTEX_keyset = 0x36			;Управление настройками клавиатуры
ESTEX_testkey = 0x37			;Опрос буфера клавиатуры

ESTEX_exec = 0x40			;Выполнить файл
ESTEX_exit = 0x41			;Завершение программы
ESTEX_wait = 0x42			;Получить код завершения программы

ESTEX_cmd_getswitch = 0x43		;Выделить параметр командной строки
ESTEX_cmd_dosname = 0x44		;Преобразовать имя файла
ESTEX_cmd_parse = 0x45			;Разбор командной строки

ESTEX_env = 0x46			;Системное окружение

ESTEX_appinfo = 0x47			;Получение информации приложения

ESTEX_setvmode = 0x50			;Выбор режима экрана
ESTEX_getvmode = 0x51			;Получить текущий режим экрана
ESTEX_setcursor = 0x52			;Установить позицию курсора
ESTEX_getcursor = 0x53			;Получить текущую позицию курсора
ESTEX_setscr = 0x54			;Выбрать активную страницу экрана
ESTEX_scrollscr = 0x55			;Прокрутка окна
ESTEX_clearscr = 0x56			;Очистка окна
ESTEX_rdchar = 0x57			;Считать символ с экрана
ESTEX_wrchar = 0x58			;Напечатать символ на экране
ESTEX_scrwincopy = 0x59			;Запомнить окно экрана
ESTEX_scrwinrest = 0x5a			;Восстановить окно экрана
ESTEX_pchar = 0x5b			;Напечатать символ в текущей позиции курсора
ESTEX_pchars = 0x5c			;Напечатать строку символов в текущей позиции курсора

;-------------------------------------------
_ENVIRONMENT:
._GET_SYS = 0				;получить системное окружение
._GET_VAL = 1				;получить параметры указанной переменной
._SET_ENV = 2				;установить переменную

;-------------------------------------------
_CMD_PARSE:
._PARSE_CMD = 0				;Разобрать строку
._GET_DSK = 1				;Выделить имя диска
._GET_DIR = 2				;Выделить директорию
._GET_FILENAME = 3			;Выделить имя файла
._GET_FILE_EXT = 4			;Выделить расширение файла
._GET_FULL_FILEPATH = 5			;Выделить имя диска, путь к файлу, имя файла и расширение файла
._NOFUNC = 6				;Зарезервирована
._SELECT_ARG = 7			;Выделить параметр командной строки
._CONV_TO_DOS = 8			;Преобразовать из 11 символьного формата в формат ДОС
._CONF_FROM_DOS = 9			;Преобразовать из формата ДОС в 11 символьный формат

;--------------------------------------------
_FOPEN:
._IORW = 0				;открыть для чтения и записи
._IOREAD = 1				;открыть только для чтения
._IOWRITE = 2				;открыть для записи

;--------------------------------------------
_MOVEFP:
._SEEK_SET = 0				;от начала файла
._SEEK_CUR = 1				;от текущего значения указателя
._SEEK_END = 2				;от конца файла

_VMODE:
._T40 = 0x02				;текстовый режим 40 символов
._T80 = 0x03				;тектосвый режим 80 символо
._320p = 0x81				;графический режим 320*256*8бит
._640p = 0x81				;графический режим 640*256*4бит
._SCREEN0 = 0x0				;страница режима 0
._SCREEN1 = 0x01			;страница режима 1

._normal = 0x50				;режим вывода - обычный (все данные в RAM и VRAM)
._transparent = 00001000b		;режим вывода с прозрачным цветом (0xff игнорируется)
._spr = 00000100b			;режим спрайта (данные попадают только в VRAM)

;--------------------------------------------
mmu0 = 0x82				;cpu window 0 = addr 0x0000
mmu1 = 0xa2				;... 1 = 0x4000
mmu2 = 0xc2				;... 2 = 0x8000
mmu3 = 0xe2				;... 3 = 0xc000

port_y = 0x89				;port for Y coord
rgmod = 0xc9				;переключает страницы режима
border = 0xfe				;бордюр
rgscr = 0xe9
rgacc = 0xa9

;sys_port3c	equ 3ch
;sys_port7c	equ 7ch
sys_port_on = 0x7c
sys_port_off = 0x3c

d_tbon = 3				; данные для включения turbo
d_tboff = 2				; данные для выключения turbo
d_rom16on = 1
d_rom16off = 0

cnf_page = 0x40				;запрет на запись сюда!!!

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
;._normal = 0x50			;режим вывода - обычный (все данные в RAM и VRAM)
;._transparent = 00001000b		;режим вывода с прозрачным цветом (0xff игнорируется)
;._spr = 00000100b			;режим спрайта (данные попадают только в VRAM)

cr = 0x0d				;возврат коретки
lf = 0x0a				;новая строка
space = 0x20				;символ пробела
tab = 0x09				;символ табуляции



;--------------------------------------------
;BIOS
BIOS_reset_drive = 0x51			; Сброс контроллера и настройка на диск
BIOS_rd_sector = 0x55			; Чтение (секторов) с устройства.
BIOS_wr_sector = 0x56			; Запись (секторов) на устройство.
BIOS_get_drv_list = 0x5f		; получить список дисковых устройств
BIOS_get_cursor_coords = 0x8e		; Получить текущее положение (курсора) вывода на экран.
BIOS_get_mem_pg = 0xc4			; получить физ. номер стр. блока
BIOS_get_pg_tbl = 0xc5			; get pages table from handle (id_blk)
BIOS_clear_scr = 0x8d			; очистка экрана, указанием символа заполнения
BIOS_get_cursor = 0x8e			; узнать полож. курсора
BIOS_set_cursor = 0x84			; уст. полож. курсора
BIOS_print_chars = 0x82			; вывод символов на экран с текущего знакоместа без атрибутов
BIOS_screen_save = 0xb2			; сохранить экран...
BIOS_screen_restore = 0xb3		; восстановить экран...
BIOS_screen_get_char = 0xb4		; прочитать (взять) символ с экрана
BIOS_screen_set_char = 0xb5		; установить символ на экране
BIOS_screen_move = 0xb7			; перемещение окна (экрана)

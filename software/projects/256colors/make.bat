@echo off
if EXIST 256color.exe (
	del 256color.exe
)
if EXIST 256color.lst (
	del 256color.lst
)

..\..\asm\sjasmplus.exe main.asm --lst=main.lst
if errorlevel 1 goto ERR
echo Ok!
goto END

:ERR
del 256color.exe
del 256color.lst
pause
echo ошибки компиляции...
goto END

:END
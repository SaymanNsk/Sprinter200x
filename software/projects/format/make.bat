@echo off
if EXIST format.exe (
	del format.exe
)
if EXIST format.lst (
	del format.lst
)

..\..\asm\build.exe
..\..\asm\sjasmplus.exe format.asm --lst=format.lst
if errorlevel 1 goto ERR
echo Ok!
goto END

:ERR
del format.exe
del format.lst
pause
echo �訡�� �������樨...
goto END

:END
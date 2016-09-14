echo OFF
echo Compiling all modules...
cd editor
call MAKE_feditor.bat
if errorlevel 1 goto ERR
cd ..\viewer
call MAKE_fviewer.bat
if errorlevel 1 goto ERR
cd ..
call MAKE_FN.bat
if errorlevel 1 goto ERR
echo Compiling loader, link all modules...
sjasmplus.exe --lst=fnloader.lst --lstlab fnloader.z80
if errorlevel 1 goto ERR
copy /Y bin\fnloader.exe /B + bin\fnmain.bin /B + bin\fnfunc.bin /B + bin\fnview.bin /B + bin\fnedit.bin /B + bin\fnhelp.bin /B + bin\fnfont.bin /B fn.exe /B
if errorlevel 1 goto ERR
goto END
:ERR
rem pause
echo Compilation ERRORs!!!
pause 0
exit
:END
echo Done!
pause 0
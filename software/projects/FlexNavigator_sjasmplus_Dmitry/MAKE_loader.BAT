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
echo Compressing modules...
del /Q bin\*.hst
tools\hrust.exe bin\fnmain.bin bin\fnmain.hst
tools\hrust.exe bin\fnfunc.bin bin\fnfunc.hst
tools\hrust.exe bin\fnview.bin bin\fnview.hst
tools\hrust.exe bin\fnedit.bin bin\fnedit.hst
tools\hrust.exe bin\fnhelp.bin bin\fnhelp.hst
tools\hrust.exe bin\fnfont.bin bin\fnfont.hst
echo Compiling loader, link all modules...
sjasmplus.exe --lst=fnloader.lst --lstlab fnloader.z80
if errorlevel 1 goto ERR
copy /Y bin\fnloader.exe /B + bin\fnmain.hst /B + bin\fnfunc.hst /B + bin\fnview.hst /B + bin\fnedit.hst /B + bin\fnhelp.hst /B + bin\fnfont.hst /B fn.exe /B
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
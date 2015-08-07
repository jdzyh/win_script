@echo off &setlocal enabledelayedexpansion

::作为参数传入:path_dst
ECHO [+] ----START----
:L_main_loop_start
set /p command=
if /i !command!==mod (
	call :L_get_splited_path

) else (
	echo [+]
)
goto L_main_loop_start
:L_main_loop_end

ECHO [+] Input dst_path:
set /p path_dst=
ECHO [+] !path_dst!

echo [+] Current Path :
echo [+]	"!path_all!" |find /i "!path_dst!" && set FindPath=true || set FindPath=false &echo [+]	!path_all!
echo [+]
echo [+] FindPath ? : !FindPath!

if /i !FindPath!==true (
	echo [+] Path Already Exists!

) else (
	echo [+] Sure To Add New Path ? [Y/N]
	set /p ans=
	
	if /i ans==Y (
		reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Environment" /v Path /t REG_EXPAND_SZ /d "%path_all%;%path_dst%" /f
		echo [+]New PATH : 
		path
	)
)
echo [+] EXIT
echo [+]	
echo [+]	
echo [+]	
echo [+]	
goto :eof

::-----------------------------------------
::Get Splited Path
::-----------------------------------------
:L_get_splited_path
for /f "tokens=1,2*" %%a in (
	'reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Environment" /v Path' 
) do (
	set path_all=%%c
)

ECHO [+] Show Splited Path

set path_split_right=%path_all%
set count=0
:L_loop_split_start
for /f "delims=; tokens=1*" %%c in ("%path_split_right%") do (
	echo [!count!]	%%c
	if %%d==nul (
		goto Loop_Split_End
	) else (
		set path_split_right=%%d
		set /a count+=1
		goto L_loop_split_start
	)
)
:L_loop_split_end
::) else (
::if /i %1==-p (
::ECHO [+] Show All Path
::ECHO [+] !path_all!
::)
::)

goto :eof
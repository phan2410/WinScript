@echo off
setlocal enabledelayedexpansion

:: Get the script name without extension
set "ScriptName=%~n0"

:: Initialize variables
set "BaseName="
set "Version="

:: Loop through each character in the script name
for /l %%i in (0,1,31) do (
    set "char=!ScriptName:~%%i,1!"
    if "!char!"=="" goto Done

    echo !char! | findstr /r "[0-9]" >nul
    if not errorlevel 1 (
        set "Version=!Version!!char!"
    ) else (
        set "BaseName=!BaseName!!char!"
    )
)

:Done

:: Debug information
echo Script Name: %ScriptName%
echo Base Name: !BaseName!
echo Version: !Version!

:: Check if the script name matches the expected pattern
if "%BaseName%%Version%" neq "%ScriptName%" (
    echo Rename this file to match the following syntax: {Words}{Version}. E.g. CCD152, CCD159
    powershell -command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Rename this file to match the following syntax: {Words}{Version}. E.g. CCD152, CCD159', 'Error', 'OK', 'Error')"
    exit /b 1
)

:: Example of going into the folder
set "TargetDir=I:\Windows\ProgramFiles"

:: Get list of versions from folders matching "City Car Driving \d+"
set "Versions="

for /d %%F in ("%TargetDir%\City Car Driving *") do (
    set "FolderName=%%~nxF"
    echo !FolderName! | findstr /r "City Car Driving [0-9][0-9]*" >nul
    if not errorlevel 1 (
        for /f "tokens=4 delims= " %%N in ("!FolderName!") do (
            set "Versions=!Versions! %%N"
        )
    )
)

:: Check if any valid folders were found
if "%Versions%"=="" (
    echo Please Install City Car Driving !!!
    powershell -command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Please Install City Car Driving !!!', 'Error', 'OK', 'Error')"
    exit /b 1
)

:: Debug information
echo Versions found: !Versions!

echo !Versions! | findstr /c:" %Version%" >nul
if errorlevel 1 (
    echo Not Found City Car Driving %Version% !!!
    powershell -command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Not Found City Car Driving %Version% !!!', 'Error', 'OK', 'Error')"
    exit /b 1
)

rem Removing leading spaces
for /f "tokens=* delims= " %%a in ("%Versions%") do set "Versions=%%a"

:: Check if the profile folder exists
set "ProfileDir=C:\Users\Admin\Documents\Forward Development\City Car Driving Steam"
if not exist "%ProfileDir%" (
    echo Not Found "%ProfileDir%" !
    powershell -command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Not Found \"%ProfileDir%\" !', 'Error', 'OK', 'Error')"
    exit /b 1
)

cd /d C:\Users\Admin\Documents\Forward Development

for %%V in (%Versions%) do (
	set "A=City Car Driving Steam %%V"
    if not exist "!A!" (
        if defined NonExistingFolder (
            echo More Than One Version Are Not Yet Backed Up. Cannot Determine Version Of The Current Profile. Please Resolve Yourself !!!
            powershell -command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('More Than One Version Are Not Yet Backed Up. Cannot Determine Version Of The Current Profile. Please Resolve Yourself !!!', 'Error', 'OK', 'Error')"
            exit /b 1
        )
        set "NonExistingFolder=!A!"
    )
)

if not defined NonExistingFolder (
    echo Found Profile Folders For All Versions. Cannot Determine Version Of The Current Profile. Please Resolve Manually !!!
    powershell -command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Found Profile Folders For All Versions. Cannot Determine Version Of The Current Profile. Please Resolve Manually !!!', 'Error', 'OK', 'Error')"
    exit /b 1
)

:: Rename the folder
ren "City Car Driving Steam" "!NonExistingFolder!"
set "NewFolderName=City Car Driving Steam %Version%"
if exist "!NewFolderName!" (
    ren "!NewFolderName!" "City Car Driving Steam"
) else (
    echo The folder "%NewFolderName%" does not exist. Exiting.
    powershell -command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('The folder \"%NewFolderName%\" does not exist. Exiting.', 'Error', 'OK', 'Error')"
    exit /b 1
)

:: Execute the program based on Version
if "%Version%"=="152" (
    powershell -command "Start-Process 'I:\Windows\ProgramFiles\City Car Driving 152\bin\win32\Starter.exe' -WorkingDirectory 'I:\Windows\ProgramFiles\City Car Driving 152\bin\win32' -Verb RunAs"
) else if "%Version%"=="159" (
    powershell -command "Start-Process 'I:\Windows\ProgramFiles\City Car Driving 159\LAUNCHER.exe' -WorkingDirectory 'I:\Windows\ProgramFiles\City Car Driving 159' -Verb RunAs"
)


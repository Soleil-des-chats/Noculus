@echo off
:: Developed By:
:: Titimousse

set version=v1.3.0

:::::::::::::::::::::
:::: FILE CHECKS ::::
:::::::::::::::::::::
if not exist ".\Requirements" goto noRequirements

if not exist ".\Requirements\curl.exe" (
	set missingFile=curl.exe
	goto missingFile
)

if not exist ".\Requirements\cmdmenusel.exe" (
	set missingFile=cmdmenusel.exe
	goto missingFile
)

if not exist ".\Requirements\adb.exe" (
	set missingFile=adb.exe
	goto missingFile
)

if not exist ".\Requirements\scrcpy.exe" (
	set missingFile=scrcpy.exe
	goto missingFile
)

if not exist ".\scrcpy\scrcpy.exe" (
	set missingFile=scrcpy.exe
	goto missingFile
)

if not exist ".\Requirements\ffmpeg.exe" (
	set missingFile=ffmpeg.exe
	goto missingFile
)

if not exist ".\Requirements\packages.bat" (
	set missingFile=packages.bat
	goto missingFile
)

if not exist ".\Requirements\wiredalvr.bat" (
	set missingFile=wiredalvr.bat
	goto missingFile
)

if not exist ".\Requirements\keepaliveReplay.bat" (
	set missingFile=keepaliveReplay.bat
	goto missingFile
)

if not exist ".\Requirements\AdbWinApi.dll" (
	set missingFile=AdbWinApi.dll
	goto missingFile
)

if not exist ".\Requirements\AdbWinUsbApi.dll" (
	set missingFile=AdbWinUsbApi.dll
	goto missingFile
)

if not exist ".\Requirements\avcodec-58.dll" (
	set missingFile=avcodec-58.dll
	goto missingFile
)

if not exist ".\Requirements\avformat-58.dll" (
	set missingFile=avformat-58.dll
	goto missingFile
)

if not exist ".\Requirements\avutil-56.dll" (
	set missingFile=avutil-56.dll
	goto missingFile
)

if not exist ".\Requirements\scrcpy-server" (
	set missingFile=The scrcpy-server file
	goto missingFile
)

if not exist ".\Requirements\SDL2.dll" (
	set missingFile=SDL2.dll
	goto missingFile
)

if not exist ".\Requirements\swresample-3.dll" (
	set missingFile=swresample-3.dll
	goto missingFile
)

if not exist ".\Requirements\swscale-5.dll" (
	set missingFile=swscale-5.dll
	goto missingFile
)

:continueSetup
:: Sets the window size
mode con: cols=72 lines=21 

cd Requirements

:MainMenu
cls
cd ..\Requirements
title Noculus Installer 
echo               [7mNoculus Installer[0m			      Version: [7m%version%[0m
echo ==========================================

:: Options
cmdMenuSel f870 "Install" "Sideload Discord" "Wired ALVR" "View Quest Screen" "Activate Noculus ExtraClock" "Change Refresh Rate" "Change Recording Res/FPS" "Sideload an APK" "Uninstall an App" "Keep Alive" "==========================================" "Credits"
if "%errorlevel%"=="1" goto installprompt
if "%errorlevel%"=="2" goto discordprompt
if "%errorlevel%"=="3" goto wiredALVR
if "%errorlevel%"=="4" goto mirrorScreen
if "%errorlevel%"=="5" goto extraclock
if "%errorlevel%"=="6" goto refreshrate
if "%errorlevel%"=="7" goto capture
if "%errorlevel%"=="8" goto sideloadPrompt
if "%errorlevel%"=="9" goto uninstallAPKPrompt
if "%errorlevel%"=="10" goto startkeepAlive
if "%errorlevel%"=="11" goto MainMenu
if "%errorlevel%"=="12" goto credit
goto MainMenu


:installprompt
cls
echo ==========================================
echo      [7mDo you want to install Noculus tools on your Headset ?[0m
echo ==========================================

:: Options
cmdMenuSel f870 "Yes" "No"
if "%errorlevel%"=="1" goto install
if "%errorlevel%"=="2" goto MainMenu
goto installPrompt

:install
cls
echo Installing Noculus.... Please wait
adb install ..\apps\Sidequest.apk
adb install ..\apps\HiddenSettings.apk
adb install ..\apps\TotalCommander.apk
adb install ..\apps\tcplugins_drive.apk
adb install ..\apps\tcplugin_wifi.apk
adb install ..\apps\tcplugin_lan.apk
adb install ..\apps\alvr.apk

if "%errorlevel%"=="1" goto noDevices

if "%errorlevel%"=="0" (
	cls
	echo Successfully Installed Noculus Tools!
	pause
	goto MainMenu
)

pause
goto MainMenu

:discordprompt
cls
echo ==========================================
echo      [7mDo you want to install Discord on your Headset ?[0m
echo ==========================================

:: Options
cmdMenuSel f870 "Yes" "No"
if "%errorlevel%"=="1" goto discord
if "%errorlevel%"=="2" goto MainMenu
goto discordPrompt

:discord
cls
echo Installing Vencord.... Please wait
adb install ..\apps\Vencord.apk

if "%errorlevel%"=="1" goto noDevices

if "%errorlevel%"=="0" (
	cls
	echo Successfully Installed Vencord!
	pause
	goto MainMenu
)

pause
goto MainMenu

:extraclock
cls
echo ==========================================
echo      [7mYour going to activate Noculus ExtraClock, battery will be drained faster and it will be hotter than usual. Are you sure ?[0m
echo ==========================================

:: Options
cmdMenuSel f870 "Yes" "No" "Restore Default Settings"
if "%errorlevel%"=="1" goto extraClockOn
if "%errorlevel%"=="2" goto MainMenu
if "%errorlevel%"=="3" goto extraClockOff
goto extraclock

:extraClockOn
cls
echo Activating Noculus ExtraClock
echo Please wait....
adb shell setprop debug.oculus.cpuLevel 4
adb shell setprop debug.oculus.gpuLevel 4

if "%errorlevel%"=="1" goto noDevices

if "%errorlevel%"=="0" (
	cls
	echo Successfully Activated ExtraClock!
	pause
	goto extraclockChoice
)

:extraClockOff
cls
echo Disabling ExtraClock...
TIMEOUT -T 2 /nobreak > null
del null /F

adb shell setprop debug.oculus.foveation.dynamic 1

if "%errorlevel%"=="1" goto noDevices

if "%errorlevel%"=="0" (
	cls
	echo Successfully Disabled Extra Clock!
	pause
	goto MainMenu
)

:extraclockChoice
cls
echo ==========================================
echo Oculus ExtraClock is on! What mode do you want?
echo Changes will remain active until you reboot your headset.
echo ==========================================

:: Options
cmdMenuSel f870 "Quality" "Performance"
if "%errorlevel%"=="1" goto extraClockq
if "%errorlevel%"=="2" goto extraClockp
goto extraclockChoice

:extraClockq
cls
echo Activating Quality Mode
echo Please wait....
adb shell setprop debug.oculus.foveation.dynamic 0
adb shell setprop debug.oculus.foveation.level 1
if "%errorlevel%"=="1" goto noDevices
if "%errorlevel%"=="0" (
	cls
	echo Successfully Activated Quality Mode!
)

:extraClockp
cls
echo Activating Performance Mode
echo Please wait....
adb shell setprop debug.oculus.foveation.dynamic 0
adb shell setprop debug.oculus.foveation.level 4
if "%errorlevel%"=="1" goto noDevices
if "%errorlevel%"=="0" (
	cls
	echo Successfully Activated Performance Mode!
)

pause
goto MainMenu


:capture
cls
echo            [7mChange Recording Res/FPS[0m
echo ==========================================
echo Which capture resolution do you want?
echo ==========================================

::Options
cmdMenuSel f870 "1920x1080 60fps (Widescreen)" "1280x1280 60fps (Square)" "1080x1920 60fps (Youtube Shorts)" "Custom res/fps" "==Back=="
if "%errorlevel%"=="1" goto wide
if "%errorlevel%"=="2" goto square
if "%errorlevel%"=="3" goto shorts
if "%errorlevel%"=="4" goto custom
if "%errorlevel%"=="5" goto MainMenu
goto capture

:wide
cls
adb shell setprop debug.oculus.capture.width 1920
adb shell setprop debug.oculus.capture.height 1080
adb shell setprop debug.oculus.capture.bitrate 10000000
adb shell setprop debug.oculus.foveation.level 0
adb shell setprop debug.oculus.capture.fps 60

if "%errorlevel%"=="-1" goto noDevices

if "%errorlevel%"=="0" (
	cls
	echo Successfully Changed Resolution and FPS!
	pause
	goto MainMenu
)

pause
goto MainMenu

:square
cls
adb shell setprop debug.oculus.capture.width 1280
adb shell setprop debug.oculus.capture.height 1280
adb shell setprop debug.oculus.capture.bitrate 10000000
adb shell setprop debug.oculus.foveation.level 0
adb shell setprop debug.oculus.capture.fps 60

if "%errorlevel%"=="-1" goto noDevices

if "%errorlevel%"=="0" (
	cls
	echo Successfully Changed Resolution and FPS!
	pause
	goto MainMenu
)

pause
goto MainMenu

:shorts
cls
adb shell setprop debug.oculus.capture.width 1080
adb shell setprop debug.oculus.capture.height 1920
adb shell setprop debug.oculus.capture.bitrate 10000000
adb shell setprop debug.oculus.foveation.level 0
adb shell setprop debug.oculus.capture.fps 60

if "%errorlevel%"=="-1" goto noDevices

if "%errorlevel%"=="0" (
	cls
	echo Successfully Changed Resolution and FPS!
	pause
	goto MainMenu
)

pause
goto MainMenu

:custom
cls

:: Clears all the variables
set width=
set height=
set fps=

:setWidth
cls
set /p width=Custom Width: 

if "%width%"=="" (
	cls
	echo Please enter a width!
	pause
	goto setWidth
)

goto setHeight

:setHeight
cls
set /p height=Custom Height: 

if "%height%"=="" (
	cls
	echo Please enter a height!
	pause
	goto setHeight
)

:setFPS
cls
echo [7mDue to oculus capping FPS, min is 30 and max is 90![0m
set /p fps=Custom FPS: 

if "%fps%"=="" (
	cls
	echo Please enter a fps!
	pause
	goto setFPS
)

adb shell setprop debug.oculus.capture.width %width%
adb shell setprop debug.oculus.capture.height %height%
adb shell setprop debug.oculus.capture.bitrate 10000000
adb shell setprop debug.oculus.foveation.level 0
adb shell setprop debug.oculus.capture.fps %fps%

if "%errorlevel%"=="-1" goto noDevices

if "%errorlevel%"=="0" (
	cls
	echo Successfully Changed Resolution and FPS!
	pause
	goto MainMenu
)

pause
goto MainMenu


:sideloadPrompt
cls
echo ==========================================
echo      [7mDo you want to sideload an APK?[0m
echo ==========================================

:: Options
cmdMenuSel f870 "Yes" "No"
if "%errorlevel%"=="1" goto sideload
if "%errorlevel%"=="2" goto MainMenu
goto sideloadPrompt

:sideload
cls
echo ==========================================
echo Type in the directory of the file (including file name)
echo [7mMake sure that the file and directory does not have a space in it![0m
echo ==========================================
echo [7mType "exit" to cancel.[0m
:: Resets the APK directory selected
set APKdir=
:: Input
set /p APKdir=Answer:
if /I "%APKdir%"=="exit" goto MainMenu
if "%APKdir%"=="" goto sideloadIncorrect
cls
echo Sideloading APK.... Please wait
adb install %APKdir%

if "%errorlevel%"=="1" goto noDevices

if "%errorlevel%"=="0" (
	cls
	echo Successfully Sideloaded APK!
	pause
	goto MainMenu
)

pause
goto MainMenu

:sideloadIncorrect
cls
echo Please Enter a directory
pause
goto sideload



:uninstallAPKPrompt
cls
echo ==========================================
echo [7mAre you sure you want to uninstall an App?[0m
echo ==========================================
cmdMenuSel f870 "Yes" "No"
if "%errorlevel%"=="1" goto uninstallAPK
if "%errorlevel%"=="2" goto MainMenu

:uninstallAPK
cls
echo ==========================================
echo [7mA new window will open with all the apps installed.[0m
echo ==========================================
pause
start packages.bat
goto uninstalling

:uninstalling
cls
echo ==========================================
echo Please Enter the package name of 
echo the app you would like to uninstall (Without the "package:")
echo ==========================================
echo [7mType "exit" to cancel.[0m
set APKuninst=
set /p APKuninst=Answer:
if "%APKuninst%"=="" goto wrongInputAPK
if /I "%APKuninst%"=="exit" goto MainMenu
cls
echo Uninstalling APK....
adb uninstall %APKuninst%

if "%errorlevel%"=="-1" goto noDevices

if "%errorlevel%"=="0" (
	echo Successfully Uninstalled APK!
	pause
	goto MainMenu
)

pause
goto MainMenu

:wrongInputAPK
cls
echo Please enter a package name!
pause
goto uninstalling



:startkeepAlive
cls
echo Starting keepAlive.bat...
start keepAlive.bat
goto MainMenu



:wiredALVR
cls
echo ==========================================
echo [7mA new window will open, do NOT close it 
echo otherwise wired ALVR will stop working.[0m
echo ==========================================
pause
echo Starting bat...
start wiredalvr.bat
goto MainMenu




:refreshrate
cls
echo               [7mRefresh Rate[0m
echo ==========================================
echo Which Refresh Rate do you want to use?
echo ==========================================

::Options
cmdMenuSel f870 "60Hz (Quest 1 Default)" "72Hz (Quest 2 Default)" "90Hz (Quest 2)" "120Hz (Quest 2)" "==Back=="
if "%errorlevel%"=="1" goto 60
if "%errorlevel%"=="2" goto 72
if "%errorlevel%"=="3" goto 90
if "%errorlevel%"=="4" goto 120
if "%errorlevel%"=="5" goto MainMenu
goto refreshrate

:60
cls
echo Updating Refresh Rate...
adb shell setprop debug.oculus.refreshRate 60

if "%errorlevel%"=="-1" goto noDevices

if "%errorlevel%"=="0" (
	cls
	echo Successfully Applied Refresh Rate!
	pause
	goto MainMenu
)

pause
goto MainMenu

:72
cls
echo Updating Refresh Rate...
adb shell setprop debug.oculus.refreshRate 72

if "%errorlevel%"=="-1" goto noDevices

if "%errorlevel%"=="0" (
	cls
	echo Successfully Applied Refresh Rate!
	pause
	goto MainMenu
)

pause
goto MainMenu

:90
cls
echo Updating Refresh Rate...
adb shell setprop debug.oculus.refreshRate 90

if "%errorlevel%"=="-1" goto noDevices

if "%errorlevel%"=="0" (
	cls
	echo Successfully Applied Refresh Rate!
	pause
	goto MainMenu
)

pause
goto MainMenu

:120
cls
echo Updating Refresh Rate...
adb shell setprop debug.oculus.refreshRate 120

if "%errorlevel%"=="-1" goto noDevices

if "%errorlevel%"=="0" (
	cls
	echo Successfully Applied Refresh Rate!
	pause
	goto MainMenu
)

pause
goto MainMenu

:credit
cls
echo ==========================================
echo Made By:
echo ==========================================

cmdMenuSel f870 "Titimousse" "==Back=="

if "%errorlevel%"=="1" (
	cls
	start https://github.com/Soleil-des-chats
	goto MainMenu
)

if "%errorlevel%"=="2" goto MainMenu


:mirrorScreen
cls
echo            [7mView Quest Screen[0m
echo ==========================================
echo Select your Oculus Quest Model :
echo ==========================================

::Options
cmdMenuSel f870 "Quest 1" "Quest 2" "==Back=="
if "%errorlevel%"=="1" goto Q1mirror
if "%errorlevel%"=="2" goto Q2mirror
if "%errorlevel%"=="3" goto MainMenu

:Q1mirror
cls
echo ==========================================
echo What FPS would you like the stream to be?
echo ==========================================
cmdMenuSel f870 "60 FPS" "30 FPS" "Custom" "==back=="
if "%errorlevel%"=="1" goto 60Q1
if "%errorlevel%"=="2" goto 30Q1
if "%errorlevel%"=="3" goto customQ2
if "%errorlevel%"=="4" goto mirrorScreen

:60Q1
:: Clears the FPS variable
set Q1streamFPS=
:: Sets the FPS of stream to 60
set Q1streamFPS=60
goto Q1streaming

:30Q1
:: Clears the FPS variable
set Q1streamFPS=
:: Sets the FPS of stream to 30
set Q1streamFPS=30
goto Q1streaming

:customQ1
cls
:: Clears the FPS variable
set Q1streamFPS=
:: Input for custom FPS
set /p Q1streamFPS=Custom FPS:
goto Q1streaming


:Q1streaming
cls
echo Starting preview at %Q1streamFPS% FPS....
:: Starts a stream to the quest at a custom fps and bitrate with a crop set
cd ..\scrcpy
scrcpy --max-fps %Q1streamFPS% --crop 1280:720:1500:350

if "%errorlevel%"=="1" goto noDevices

cd ..\Requirements

pause
goto MainMenu

:Q2mirror
cls
echo ==========================================
echo What FPS would you like the stream to be?
echo ==========================================

::Options
cmdMenuSel f870 "60 FPS" "30 FPS" "Custom" "==back=="
if "%errorlevel%"=="1" goto 60Q2
if "%errorlevel%"=="2" goto 30Q2
if "%errorlevel%"=="3" goto customQ2
if "%errorlevel%"=="4" goto mirrorScreen

:60Q2
:: Clears the FPS variable
set Q2streamFPS=
:: Sets the FPS of stream to 60
set Q2streamFPS=60
goto Q2streaming

:30Q2
:: Clears the FPS variable
set Q2streamFPS=
:: Sets the FPS of stream to 30
set Q2streamFPS=30
goto Q2streaming

:customQ2
cls
:: Clears the FPS variable
set Q2streamFPS=
:: Input for custom FPS
set /p Q2StreamFPS=Custom FPS:
goto Q2streaming


:Q2streaming
cls
echo Starting preview at %Q2streamFPS% FPS....
:: Starts a stream to the quest at a custom fps with a crop set
cd ..\scrcpy
scrcpy --max-fps %Q2streamFPS% --crop 1600:900:2017:510

if "%errorlevel%"=="1" goto noDevices

cd ..\Requirements

pause
goto MainMenu




::::::::::::::::::::::::::::::::::::::::
:::::::::::::ERROR MESSAGES:::::::::::::
::::::::::::::::::::::::::::::::::::::::

:noDevices
cls
cd ..\Requirements
echo [7mYou have either more than 1 or no Android devices connected!
echo Please disconnect any other devices or connect your Quest.[0m
pause
goto MainMenu

:noRequirements
cd ..\Requirements
mode con: cols=90 lines=20 
cls
echo [41mThe requirements folder does not exist, please redownload![0m
pause
start https://github.com/Soleil-des-chats/Noculus
exit

:missingFile
cd ..\Requirements
mode con: cols=90 lines=20 
cls
echo [41m%missingFile% was not found in the requirements folder. Please redownload![0m
pause
start https://github.com/Soleil-des-chats/Noculus
exit

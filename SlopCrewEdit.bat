@echo off
setlocal enabledelayedexpansion

:: Set the path to the config file and the executable
set "config_file=BepInEx\config\SlopCrew.Plugin.cfg"
set "game_executable=Bomb Rush Cyberfunk.exe"

:: Read the config file into variables
call :readConfig

:: Main menu
:menu
cls
echo ============================
echo  SlopCrew Plugin Config Editor
echo ============================
echo.
echo Current Configuration:
echo -------------------------
for /f "tokens=1,2 delims==" %%A in ('type "%config_file%" ^| find "="') do (
    echo %%A=%%B
)

echo.
echo ============================
echo Choose an option to edit:
echo 1. FixBikeGate (%FixBikeGate%)
echo 2. FixAmbientColors (%FixAmbientColors%)
echo 3. Username (%Username%)
echo 4. ShowConnectionInfo (%ShowConnectionInfo%)
echo 5. ShowPlayerNameplates (%ShowPlayerNameplates%)
echo 6. BillboardNameplates (%BillboardNameplates%)
echo 7. OutlineNameplates (%OutlineNameplates%)
echo 8. ShowPlayerMapPins (%ShowPlayerMapPins%)
echo 9. ShowQuickChat (%ShowQuickChat%)
echo 10. CharacterOverride (%CharacterOverride%)
echo 11. OutfitOverride (%OutfitOverride%)
echo 12. ReceiveNotifications (%ReceiveNotifications%)
echo 13. StartEncountersOnRequest (%StartEncountersOnRequest%)
echo 14. Host (%Host%)
echo 15. Port (%Port%)
echo 16. Key (%Key%)
echo.
echo 17. Save and quit
echo 18. Save and start Bomb Rush Cyberfunk
set /p choice=Enter your choice (1-18): 

if %choice% gtr 0 if %choice% lss 17 (
    call :editConfig %choice%
    goto menu
) else if "%choice%"=="17" (
    goto saveAndQuit
) else if "%choice%"=="18" (
    goto saveAndStart
) else (
    echo Invalid choice. Please try again.
    pause
    goto menu
)

:: Function to read the config file into variables
:readConfig
for /f "tokens=1,2 delims== " %%A in ('type "%config_file%" ^| find "="') do (
    set "%%A=%%B"
)
goto :eof

:: Function to edit a configuration key
:editConfig
cls
setlocal enabledelayedexpansion
set "key="
set "prompt="
if %1==1 set key=FixBikeGate & set prompt=Fix other players being able to start bike gate cutscenes (true/false)
if %1==2 set key=FixAmbientColors & set prompt=Fix other players being able to change color grading (true/false)
if %1==3 set key=Username & set prompt=Username to show to other players
if %1==4 set key=ShowConnectionInfo & set prompt=Show current connection status and player count (true/false)
if %1==5 set key=ShowPlayerNameplates & set prompt=Show players' names above their heads (true/false)
if %1==6 set key=BillboardNameplates & set prompt=Billboard nameplates (always face the camera) (true/false)
if %1==7 set key=OutlineNameplates & set prompt=Add a dark outline to nameplates for contrast (true/false)
if %1==8 set key=ShowPlayerMapPins & set prompt=Show players on the phone map (true/false)
if %1==9 set key=ShowQuickChat & set prompt=Show quick chat messages (true/false)
if %1==10 set key=CharacterOverride & set prompt=Force a certain character to appear at all times (e.g., Vinyl, Frank, Coil, etc.)
if %1==11 set key=OutfitOverride & set prompt=Force a certain outfit to appear at all times (values 0-3, only if CharacterOverride is set)
if %1==12 set key=ReceiveNotifications & set prompt=Receive notifications to start encounters from other players (true/false)
if %1==13 set key=StartEncountersOnRequest & set prompt=Start encounters when opening a notification (true/false)
if %1==14 set key=Host & set prompt=Host to connect to (IP address or domain name)
if %1==15 set key=Port & set prompt=Port to connect to
if %1==16 set key=Key & set prompt=Authentication key to link your Discord account to Slop Crew
if defined key (
    echo %prompt%
    set /p newValue=Enter new value for %key% (current: !%key%!): 
    set "!key!=!newValue!"
) else (
    echo Invalid option. Returning to menu.
    pause
)
goto :eof

:: Function to save the config file
:saveConfig
(
    for /f "tokens=*" %%A in ('type "%config_file%"') do (
        set "line=%%A"
        for /f "tokens=1,2 delims==" %%B in ("%%A") do (
            if "%%B"=="FixBikeGate" set "line=%%B=!FixBikeGate!"
            if "%%B"=="FixAmbientColors" set "line=%%B=!FixAmbientColors!"
            if "%%B"=="Username" set "line=%%B=!Username!"
            if "%%B"=="ShowConnectionInfo" set "line=%%B=!ShowConnectionInfo!"
            if "%%B"=="ShowPlayerNameplates" set "line=%%B=!ShowPlayerNameplates!"
            if "%%B"=="BillboardNameplates" set "line=%%B=!BillboardNameplates!"
            if "%%B"=="OutlineNameplates" set "line=%%B=!OutlineNameplates!"
            if "%%B"=="ShowPlayerMapPins" set "line=%%B=!ShowPlayerMapPins!"
            if "%%B"=="ShowQuickChat" set "line=%%B=!ShowQuickChat!"
            if "%%B"=="CharacterOverride" set "line=%%B=!CharacterOverride!"
            if "%%B"=="OutfitOverride" set "line=%%B=!OutfitOverride!"
            if "%%B"=="ReceiveNotifications" set "line=%%B=!ReceiveNotifications!"
            if "%%B"=="StartEncountersOnRequest" set "line=%%B=!StartEncountersOnRequest!"
            if "%%B"=="Host" set "line=%%B=!Host!"
            if "%%B"=="Port" set "line=%%B=!Port!"
            if "%%B"=="Key" set "line=%%B=!Key!"
        )
        echo !line!
    )
) > "%config_file%.tmp"
move /y "%config_file%.tmp" "%config_file%"
goto :eof

:saveAndQuit
call :saveConfig
echo Configuration saved.
pause
exit /b

:saveAndStart
call :saveConfig
echo Configuration saved. Starting game...
start "" "%game_executable%"
exit /b

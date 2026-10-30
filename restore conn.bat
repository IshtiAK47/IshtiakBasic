@echo off
:: Check for Administrator Privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Run this script as Administrator!
    pause
    exit /b
)

echo Resetting Group Policies and restoring Connections tab...

:: 1. Delete Group Policy cache files (undoes manual gpedit changes)
del /f /q "%SystemRoot%\System32\GroupPolicy\User\Registry.pol" >nul 2>&1
del /f /q "%SystemRoot%\System32\GroupPolicy\Machine\Registry.pol" >nul 2>&1

:: 2. Remove all IE Control Panel restrictions
reg delete "HKCU\Software\Policies\Microsoft\Internet Explorer\Control Panel" /f >nul 2>&1
reg delete "HKLM\Software\Policies\Microsoft\Internet Explorer\Control Panel" /f >nul 2>&1

:: 3. Disable Proxy and re-enable Auto-Detect
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyOverride /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v AutoDetect /t REG_DWORD /d 1 /f >nul

reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyOverride /f >nul 2>&1

:: 4. Force Group Policy Update
gpupdate /force

echo.
echo [SUCCESS] Connections tab and normal settings restored!
echo Close and reopen Control Panel -> Internet Options.
pause

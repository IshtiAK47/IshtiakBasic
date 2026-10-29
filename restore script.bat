@echo off
:: Check for Administrator Privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] You must run this script as Administrator!
    echo Right-click the file and select "Run as administrator".
    pause
    exit /b
)

echo ====================================================
echo Restoring Normal Internet Access...
echo ====================================================

:: 1. Disable Proxy
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyOverride /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v AutoDetect /t REG_DWORD /d 1 /f >nul

reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyOverride /f >nul 2>&1

:: 2. Remove Restrictions on Control Panel & Settings
reg delete "HKCU\Software\Policies\Microsoft\Internet Explorer\Control Panel" /v Proxy /f >nul 2>&1
reg delete "HKCU\Software\Policies\Microsoft\Internet Explorer\Control Panel" /v ConnectionsTab /f >nul 2>&1
reg delete "HKLM\Software\Policies\Microsoft\Internet Explorer\Control Panel" /v Proxy /f >nul 2>&1
reg delete "HKLM\Software\Policies\Microsoft\Internet Explorer\Control Panel" /v ConnectionsTab /f >nul 2>&1

:: 3. Flush DNS
ipconfig /flushdns >nul

echo.
echo [SUCCESS] All restrictions removed. Normal internet access restored!
echo.
pause

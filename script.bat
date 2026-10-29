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
echo Setting up ICPC Contest Restrictions...
echo ====================================================

set "EXCEPTIONS=*.bapsoj.org;bapsoj.org;www.bapsoj.org;*.storage.googleapis.com;storage.googleapis.com;*.amazonaws.com;*.digitaloceanspaces.com;*.github.com;github.com;*.githubusercontent.com;raw.githubusercontent.com"

:: 1. Apply Dummy Proxy (Current User)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d "127.0.0.1:80" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyOverride /t REG_SZ /d "%EXCEPTIONS%" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v AutoDetect /t REG_DWORD /d 0 /f >nul

:: 2. Apply Dummy Proxy (Local Machine / All Users)
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d "127.0.0.1:80" /f >nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyOverride /t REG_SZ /d "%EXCEPTIONS%" /f >nul

:: 3. Lock down settings so students cannot modify or disable proxy
:: Disables "Proxy Settings" button & disables the entire "Connections" tab
reg add "HKCU\Software\Policies\Microsoft\Internet Explorer\Control Panel" /v Proxy /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Policies\Microsoft\Internet Explorer\Control Panel" /v ConnectionsTab /t REG_DWORD /d 1 /f >nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Control Panel" /v Proxy /t REG_DWORD /d 1 /f >nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Control Panel" /v ConnectionsTab /t REG_DWORD /d 1 /f >nul

:: 4. Flush DNS
ipconfig /flushdns >nul

echo.
echo [SUCCESS] PC configured successfully:
echo - Allowed: BAPSOJ, Cloud Storage, and GitHub.
echo - All other internet traffic is blocked.
echo - Control Panel Connections tab and Proxy settings are locked.
echo.
pause

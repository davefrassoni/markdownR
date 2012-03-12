@ECHO off
%~d0
CD "%~dp0"

IF EXIST %WINDIR%\SysWow64 (
set powerShellDir=%WINDIR%\SysWow64\windowspowershell\v1.0
) ELSE (
set powerShellDir=%WINDIR%\system32\windowspowershell\v1.0
)

ECHO Setting the PowerShell Execution Policy to Unrestricted
CALL %powerShellDir%\powershell.exe -Command Set-ExecutionPolicy unrestricted
ECHO Setting common environment variables
CALL %powerShellDir%\powershell.exe -Command "& .\set_env_vars.markdownr.ps1"
IF EXIST set_env_vars.markdownr.prod.ps1 (
	ECHO Setting production environment variables
	CALL %powerShellDir%\powershell.exe -Command "& .\set_env_vars.markdownr.prod.ps1"
)

echo SUCCESS
exit /b 0

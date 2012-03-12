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
CALL %powerShellDir%\powershell.exe -Command "& .\set_azure_role_information.ps1"
IF EXIST set_azure_role_information.prod.ps1 (
	ECHO Setting production environment variables
	CALL %powerShellDir%\powershell.exe -Command "& .\set_azure_role_information.prod.ps1"
)

echo SUCCESS
exit /b 0

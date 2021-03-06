SET CONFIG=%1
xcopy /E /Y ..\src .\markdownr-web\
del .\markdownr-web\temp /S /F /Q
copy ..\package.json .\markdownr-web\
copy ..\npm-shrinkwrap.json .\markdownr-web\

IF EXIST Web.%CONFIG%.config (
	xcopy /Y Web.%CONFIG%.config .\markdownr-web\Web.cloud.config
)

xcopy /E /Y .\startup .\markdownr-web\bin\

@echo ****** The markdownr-web folder contains the azure-friendly version of the source code. You can either use the emulator (Start-AzureEmulator) or publish to Azure (Publish-AzureService) using PowerShell for Node.js ****

@PAUSE
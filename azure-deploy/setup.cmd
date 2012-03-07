xcopy /E ..\src .\markdown-worker\
copy ..\package.json .\markdown-worker\
xcopy /E .\startup .\markdown-worker\

@echo ****** The markdown-worker folder contains the azure-friendly version of the source code. You can either use the emulator (Start-AzureEmulator) or publish to Azure (Publish-AzureService) using PowerShell for Node.js ****

@PAUSE
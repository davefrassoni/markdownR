[Reflection.Assembly]::LoadWithPartialName("Microsoft.WindowsAzure.ServiceRuntime")
[Environment]::SetEnvironmentVariable("TEMP_STORE_PATH", [Microsoft.WindowsAzure.ServiceRuntime.RoleEnvironment]::GetLocalResource("tempStore").RootPath, "Machine")
write-host BLAH
#######################################################################
# CREATE A FILE set_env_vars.markdownr.prod.ps1 TO OVERRIDE THESE VALUES
#######################################################################

# [Environment]::SetEnvironmentVariable("AZURE_STORAGE_ACCOUNT", "...", "Machine")
# [Environment]::SetEnvironmentVariable("AZURE_STORAGE_ACCESS_KEY", "...", "Machine")
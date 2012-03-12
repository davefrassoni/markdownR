[Reflection.Assembly]::LoadWithPartialName("Microsoft.WindowsAzure.ServiceRuntime")
[Environment]::SetEnvironmentVariable("TEMP_STORE_PATH", [Microsoft.WindowsAzure.ServiceRuntime.RoleEnvironment]::GetLocalResource("tempStore").RootPath, "Machine")
write-host BLAH
#######################################################################
# CREATE A FILE set_azure_role_information.prod.ps1 TO OVERRIDE THESE VALUES
#######################################################################

# [Environment]::SetEnvironmentVariable("AZURE_STORAGE_ACCOUNT", "...", "Machine")
# [Environment]::SetEnvironmentVariable("AZURE_STORAGE_ACCESS_KEY", "...", "Machine")

# [Environment]::SetEnvironmentVariable("IDENTITY_PROVIDER_URL", "https://southworksinc.accesscontrol.windows.net/v2/wsfederation/", "Machine")
# [Environment]::SetEnvironmentVariable("HOMEREALM", "https://login.southworks.net/", "Machine")
# [Environment]::SetEnvironmentVariable("REALM", "urn:markdownr:81", "Machine")
# [Environment]::SetEnvironmentVariable("ACS_SIGNING_KEY", "aZHIxqQrfUuyt8fzK96aKO0BxKx7/MNm9CINr6dZ5yY=", "Machine")
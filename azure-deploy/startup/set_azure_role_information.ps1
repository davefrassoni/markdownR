[Reflection.Assembly]::LoadWithPartialName("Microsoft.WindowsAzure.ServiceRuntime")
[Environment]::SetEnvironmentVariable("TEMP_STORE_PATH", [Microsoft.WindowsAzure.ServiceRuntime.RoleEnvironment]::GetLocalResource("tempStore").RootPath, "Machine")

[Environment]::SetEnvironmentVariable("AZURE_STORAGE_ACCOUNT", "markdownr", "Machine")

[Environment]::SetEnvironmentVariable("AZURE_STORAGE_ACCESS_KEY", "HVhowU1mkpo+HyPQTKmChN22Ko5LOmxz8G7qyjSNOvEzCfHfkHGRcEdMi2lMpcCHhtzT1wYGiqyheZwfTdaglQ==", "Machine")
# MarkdownR 

#### Running MarkdownR in 60 Seconds (using Windows Azure PowerShell Console) ####

1. Make sure you've installed [Windows Azure SDK for Node JS](http://www.microsoft.com/web/gallery/install.aspx?appid=azurenodepowershell&clcid=0x40a).

2. Open Windows Azure PowerShell for Node.js Console.

3. CD to the project root folder.

4. Install the project modules by running `npm install` in the PowerShell console.

5. Set the `EMULATED` environment variable to true to use Windows Azure development storage. To set the value, type the following command in the PowerShell console:
    `[Environment]::SetEnvironmentVariable("EMULATED", "true", "User")`
    
6. CD to the `src` folder.

7. Start Windows Azure Storage emulator.

8. Start the application by running `node server.js`.

9. Browse to `http://localhost:8081` and start markdowning!


#### Deploying MarkdownR to Windows Azure ####
If you want to deploy to Windows Azure use `publish.cmd` on azure-deploy which will copy the src folder in there, generate a cspkg and publish to your account.

#### Runing MarkdownR without the Compute Emulator ####
If you are using a Mac or [Cloud9](http://c9.io) you might need to setup the storage URL pointing to a real Azure Blob Storage account. To do this you also need to set the following environment variables:

* AZURE_STORAGE_IMAGECONTAINER: This variable should store an Azure Blob Storage container name used for storing uploaded images when doing copy/paste in Chrome.

* AZURE_STORAGE_ACCOUNT: Name of the account.

* AZURE_STORAGE_ACCESS_KEY: Account key.
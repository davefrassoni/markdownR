# MarkdownR 

#### Running MarkdownR in 60 Seconds (using Windows Azure PowerShell for Node.js Console) ####

1. Make sure you've installed [Windows Azure SDK for Node JS](http://www.microsoft.com/web/gallery/install.aspx?appid=azurenodepowershell&clcid=0x40a).
2. Open Windows Azure PowerShell for Node.js Console.
3. CD to the project root folder.
4. Install the project modules by running `npm install` in the PowerShell console.
5. CD to the `src` folder.
6. Enable the Windows Azure development storage. For this, open the Web.config file, locate the **appSettings** tag and set the value of EMULATED to **true**.
7. Start the application by running `Start-AzureEmulator`.
8. Browse to `http://localhost:8081` and start markdowning!

#### Deploying MarkdownR to Windows Azure ####
If you want to deploy to Windows Azure, you need to:

1. Run the `setup.cmd` script to copy the src folder in the same folder as the azure service configuration files.
2. Open the Web.cloud.config file inside the markdownr-web folder, locate the **appSettings** tag and fill the placeholders (to enable couchdb, see below)
3. (Optional) It's highly recommended that you enable remote access the deployment (using the `Enable-AzureRemoteDesktop` cdmlet)
4. Lastly, run `Publish-AzureService -name [YOUR-HOSTED-SERVICE-NAME]`. 

#### Runing MarkdownR without the Compute Emulator ####
If you are using a Mac or [Cloud9](http://c9.io) you might need to setup the storage URL pointing to a real Azure Blob Storage account. To do this, you also need to fill the following settings in the Web.config file:

* AZURE_STORAGE_ACCOUNT: Name of the account.
* AZURE_STORAGE_ACCESS_KEY: Account key.

### Setting up persistence in MarkdownR ###

You can set up a couchdb service by following these steps:

1. Update the COUCHDB_SERVICE_URI setting in the Web.config file with the URI of your couchdb service (such as http://cloudant.com)
2. If you’re working with a fresh database:
	a. Open the \node_modules\share\bin\options.js file and uncomment the couchdb line. Now, fill the `uri` line right below with the same value you used in step 1.
	b. Open a command prompt and run the following command: `node share\bin\setup_couch`. This will create a _design/sharejs file inside your database.
# MarkdownR 

#### Prerequisites ####
* [Windows Azure SDK for Node JS](http://www.microsoft.com/web/gallery/install.aspx?appid=azurenodepowershell&clcid=0x40a)
* Windows 7 (not tested in Windows 8)

#### Setup Instructions ####

To run this application first install the modules by typing `npm install` in a console.

You will have to set the following env variables

* AZURE_STORAGE_IMAGECONTAINER: this is the container name in blob storage where images will be uploaded when doing copy paste in Chrome

By default the code will use the development storage but if you are on a Mac or Cloud9 you might need to setup the storage account pointing to a real blob storage

* AZURE_STORAGE_ACCOUNT: name of the account
* AZURE_STORAGE_ACCESS_KEY: key

If you want to deploy to Windows Azure use publish.cmd on azure-deploy which will copy the src folder in there and generate a cspkg and publish to your account.

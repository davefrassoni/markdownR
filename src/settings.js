/*
 * Settings file to configure MarkdownR
 * _ Sets the port (8081 by default)
 * _ Sets the db type (none by default)
 * _ Sets the azure storage account
*/

var fs = require('fs');

function Settings(){
	this.blobStoragePath = getBlobStorage();
	this.tempStorePath = getTempStore();
	this.options = getOptions();
	this.auth = getAuthConfiguration();
}

module.exports = Settings;

function getBlobStorage(){
	var blobPath = '';
	var blobStorageInfoMessage = '';
	
	if(process.env.EMULATED != undefined || !!process.env.EMULATED) {
		if(process.env.AZURE_STORAGE_ACCOUNT == undefined || process.env.AZURE_STORAGE_ACCESS_KEY == undefined) {
			var errorMessage = 'You must set up AZURE_STORAGE_ACCESS_KEY and AZURE_STORAGE_ACCOUNT environment variables in the web.config file';
			errorMessage += '.\nIf you want to run the application in the local emulator, set EMULATED to true in the web.config';
			console.log(errorMessage);
			throw new Error(errorMessage);
		}else{
			blobPath = 'http://' + process.env.AZURE_STORAGE_ACCOUNT + '.blob.core.windows.net/images/';
			blobStorageInfoMessage = 'http://' + process.env.AZURE_STORAGE_ACCOUNT + '.blob.core.windows.net';
		}
	}else{
		blobPath = 'http://127.0.0.1:10000/devstoreaccount1/images/'
		blobStorageInfoMessage = 'running in the local emulator';
	}
	
	console.log('\t- azure storage: ' + blobStorageInfoMessage);
	return blobPath;
}

function getTempStore(){
	var tempPath = process.env.TEMP_STORE_PATH || "TEMP/";
	
	// check if the folder exists. If not, I create it.
	fs.stat(tempPath, function(err){
		if (err){
			fs.mkdir(tempPath, function(err){
				if (err)
					console.log('Error creating the temp path: ' + err);
			});
		}
	});
	console.log('\t- temp path: initialized');
	return tempPath;
}

function getOptions(){
	var options = {};
	var port = process.env.PORT || 8081;
	var dbInfoMessage = '';
	
	if (process.env.COUCHDB_SERVICE_URI){
		options = { db: { type: 'couchdb', uri: process.env.COUCHDB_SERVICE_URI }, port: port };
		dbInfoMessage = 'running couchdb: ' + options.db.type + ' @' + options.db.uri;
	}else{
		options = { db: { type: 'none' }, port: port };
		dbInfoMessage = 'running in memory';
	}
	
	console.log('\t- db: ' + dbInfoMessage);
	console.log('\t- port: ' + options.port);
	return options;
}

function getAuthConfiguration(){
	var auth = {};

	auth.enabled = process.env.AUTHENTICATION_ENABLED === 'true';
	console.log('\t- auth.enabled: ' + auth.enabled);
	
	if (auth.enabled) {
		auth.identityProviderUrl = process.env.IDENTITY_PROVIDER_URL || 'https://southworksinc.accesscontrol.windows.net/v2/wsfederation/';
		auth.homeRealm = process.env.HOMEREALM;
		auth.realm = process.env.REALM 	|| 'urn:markdownr:8081';
		auth.signingKey = process.env.ACS_SIGNING_KEY || 'aZHIxqQrfUuyt8fzK96aKO0BxKx7/MNm9CINr6dZ5yY=';

		console.log('\t\t- auth.identityProviderUrl: ' + auth.identityProviderUrl);
		console.log('\t\t- auth.homeRealm: ' + auth.homeRealm);
		console.log('\t\t- auth.realm: ' + auth.realm);
		console.log('\t\t- auth.signingKey: ' + auth.signingKey);
	}
	
	return auth;
}

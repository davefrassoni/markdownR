var azure = require('azure');

module.exports = AzureBlobService;

function AzureBlobService(){
	process.env.EMULATED = true;
	this.blobService = azure.createBlobService();
}

function obtainPropertyValue(collection, propertyName){
	var names = [];
	for(var key in collection){
		var item = collection[key];
		if (item.hasOwnProperty(propertyName))
			names.push(item[propertyName]);
	}
	return names;
}

AzureBlobService.prototype = {

	getBlobToText: function(containerName, blobName, callback){
		var self = this;
		self.blobService.getBlobToText(containerName, blobName,  function(err, blob){
			callback(err, blob); 
		});
	},
	
	getAllContainerNames: function(callback){
		var self = this;
		self.blobService.listContainers(function(err, result){
			if(!err){
				var names = obtainPropertyValue(result, 'name');
				callback(null, names);
			}
			else
				callback(err, null);
		});
	},
	
	getAllBlobsNamesInContainer: function(containerName, callback){
		var self = this;
		self.blobService.listBlobs(containerName, function(err, result){
			if(!err){
				var names = obtainPropertyValue(result, 'name');
				callback(null, names);
			}
			else
				callback(err, null);
		});
	}
};
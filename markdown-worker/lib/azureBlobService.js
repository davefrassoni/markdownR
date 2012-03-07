var azure = require('azure');

module.exports = AzureBlobService;

function AzureBlobService(){
	this.blobService = azure.createBlobService(process.env.AZURE_STORAGE_ACCOUNT, process.env.AZURE_STORAGE_ACCESS_KEY);
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
	
	getContainerNames: function(callback){
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

	getBlobPath: function(containerName, blob, callback){
		var self = this;
		self.blobService.getBlobUrl(containerName, blob, function(err, result){
			if(!err){
				callback(null, result);
			}
			else
				callback(err, null);
		});
	},
	
	getBlobNames: function(containerName, prefix, delimiter, options, callback){
		var self = this;
		self.blobService.listBlobs(containerName,{ 'prefix': prefix, 'delimiter': delimiter} , function(err, result, resultCont, response){
			if(!err){
				
				var childs = [];
				
				// Folders (if BlobPrefix contains one folder is a simple JSON. Otherwise is an array of JSONs)
				if (response.body.Blobs.BlobPrefix && !response.body.Blobs.BlobPrefix.length)
					childs.push(response.body.Blobs.BlobPrefix['Name']);
				else
					childs = obtainPropertyValue(response.body.Blobs.BlobPrefix, 'Name')
				
				// Files
				if (options.showFiles){
					var files = obtainPropertyValue(result, 'name');
					childs = childs.concat(files);
				}
				
				callback(null, childs);
			}
			else
				callback(err, null);
		});
	},

	uploadImageToBlob: function(container, blob, stream, streamLength, callback) {
		var self = this;
		self.blobService.createBlockBlobFromStream(container, blob, stream, streamLength, function(err, result){
			if(!err)
				callback(null, result);
			else
				callback(err, null);
		});
	},
	
	uploadTextToBlob: function(container, blob, text, callback){
		var self = this;
		self.blobService.createBlockBlobFromText(container, blob, text, function(err, result){
			if(!err)
				callback(null, result);
			else
				callback(err, null);
		});
	}
};
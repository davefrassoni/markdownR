var Showdown = require('../public/markdown/showdown').converter,
	Mustache = require('mustache'),
	fs = require('fs'),
	AzureBlobService = require('../lib/azureBlobService');

module.exports = Editor;

var imageNumber = 0;
var template = fs.readFileSync("views/editor.html.mu", 'utf8');
var defaultContent = function(name) {
		return "# " + name + " page\n\nThis editor page is currently empty.\n\nYou can put some content in it with the editor on the right. As you do so, the document will update live on the left, and live for everyone else editing at the same time as you. Isn't that cool?\n\nThe text on the left is being rendered with markdown, so you can do all the usual markdown stuff like:\n\n- Bullet\n  - Points\n\n[links](http://google.com)\n\n[Go back to the main page](Main)";
    };


function Editor(tempPath){
	this.blobService = new AzureBlobService();
	this.tempPath = tempPath;
}

function getChildsPath(fullPath){
	fullPath.shift();
	return fullPath.toString().replace(/,/g, '/');
}

function addRootInPath(root, collection){
	for(var key in collection){
		var path = root + '/' + collection[key];
		collection[key] = path;
	}
	return collection;
}

Editor.prototype = {

	setUser: function(userName) {
		this.userName = userName;	
	},

	render: function(content, docName, res) {
		var markdown = (new Showdown()).makeHtml(content);
		var data = {
			content: content,
			markdown: markdown,
			docName: docName,
			user: this.userName,
			isUserSet: this.userName !== undefined
		}
		var html = Mustache.to_html(template, data);
		res.writeHead(200, {'content-type': 'text/html'});
		res.end(html);
	},
	
	// open a document stored in the server
	openDocument: function(docName, model, res) {
		var self = this;
		return model.getSnapshot(docName, function(error, data) {
			if (error === 'Document does not exist') {
			  return model.create(docName, 'text', function() {
				var content = defaultContent(docName);
				return model.applyOp(docName, { op: [ { i: content, p: 0 } ], v: 0 }, function() {
					return self.render(content, docName, res);
				});
			  });
			} else {
				return self.render(data.snapshot, docName, res);
			}
		});
	},
	
	// open a file and save it as a new document
	openFile: function(filePath, model, req, res) {
		var self = this;
		var content = fs.readFileSync(filePath, 'utf8');
		docName = req.files.openFileInput.name.split('.')[0];
		model.create(docName, 'text', function(err, result) {
			if (!err){
				model.applyOp(docName, { op: [ { i: content, p: 0 } ], v: 0 }, function() {
					res.redirect('/' + docName);
				});
			}
			else
				console.log(err);
		});
	},

	// open a blob and save it as a new document
	openBlob: function(containerName, blobName, model, res) {
		var self = this;
		self.blobService.getBlobToText(containerName, blobName,  function(err, blob){
			if(!err){
				docName = blobName.split('/')[blobName.split('/').length - 1].split('.')[0];
				var data = {url: '/' + docName };
				model.create(docName, 'text', function(err, result) {
					if (!err){
						model.applyOp(docName, { op: [ { i: blob, p: 0 } ], v: 0 }, function() {
							res.json(data);
						});	
					}
					else{
						res.json(data);
					}
				});
			}
		});
	},
	
	saveDocumentToFile: function(docName, model, res){
		var self = this;
		return model.getSnapshot(docName, function(error, data) {
			if (!error){
				var tempPath = self.tempPath + 'temp.markdown';
				fs.open(tempPath,'w', function(){
					fs.writeFileSync(tempPath, data.snapshot);
					res.download(tempPath, docName + '.markdown');
				});
			}
		});
	},
	
	saveDocumentToBlob: function(docName, container, blobPath, model, res) {
		var self = this;
		model.getSnapshot(docName, function(err, data){
			if (!err){
				self.blobService.uploadTextToBlob(container, blobPath, data.snapshot, function(err, result){
					if(!err)
						res.redirect(docName);
					else
						console.log(err);
						
				});
			}
			else
				console.log(err);
		});
	},
	
	preview: function(docName, model, res){
		var self = this;
		return model.getSnapshot(docName, function(error, data) {
			if (!error){
				var markdown = (new Showdown()).makeHtml(data.snapshot);
				var htmlData = { markdown: markdown, docName: docName };
				previewHtml = fs.readFileSync("views/preview.html.mu", 'utf8');
				var html = Mustache.to_html(previewHtml, htmlData);
				res.writeHead(200, {'content-type': 'text/html'});
				res.end(html);
			}
		});
	},
	
	listBlobStructure: function(directory, req, res, options){
		var self = this;
		options = options || { 'showFiles': true };
		
		if (!directory){
			self.blobService.getContainerNames(function(err, result){
				if (!err){
					res.send(result);
				}
				else
					console.log(err);
			});
		}
		else{
			var path = directory.split('/');
			var containerName = path[0];
			var prefix = getChildsPath(path);
			var delimiter = '/';
			
			self.blobService.getBlobNames(containerName, prefix, delimiter, options, function(err, result){
				if (!err){
					addRootInPath(containerName, result);
					res.send(result);
				}
				else
					console.log(err);
			});	
		}
	},

	saveStreamToBlob: function(fileName, dataURL, model, res) {
		var self = this;
		var container = 'images';
		var filePath = self.tempPath + fileName;
		fs.writeFile(filePath, dataURL, 'base64', function (err) {
			if (err) {
				return console.log(err);
			}
			else {
				self.blobService.createContainerIfNotExists(container, function(err){
					if(err){
						console.log(err);
					}
				});
				var readStream = fs.createReadStream(filePath);
				var stat = fs.statSync(filePath);
				self.blobService.uploadImageToBlob(container, fileName, readStream, stat.size, function(err, result){
					if(err) {
						console.log(err);
					}
					else {
						fs.unlink(filePath);
						res.send(result);
					}
				});
			}
		});
	}
};
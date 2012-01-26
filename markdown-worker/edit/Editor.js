var Showdown = require('../lib/markdown/showdown').converter;
var Mustache = require('mustache');
var fs = require('fs');

var template = fs.readFileSync("./edit/editor.html.mu", 'utf8');
var defaultContent = function(name) {
  return "# " + name + " page\n\nThis editor page is currently empty.\n\nYou can put some content in it with the editor on the right. As you do so, the document will update live on the left, and live for everyone else editing at the same time as you. Isn't that cool?\n\nThe text on the left is being rendered with markdown, so you can do all the usual markdown stuff like:\n\n- Bullet\n  - Points\n\n[links](http://google.com)\n\n[Go back to the main page](Main)";
};

module.exports = Editor;

function Editor(blobClient){
	this.blobClient = blobClient;
}

Editor.prototype = {

	render: function(content, docName, res) {
		var markdown = (new Showdown()).makeHtml(content);
		var data = {
			content: content,
			markdown: markdown,
			docName: docName
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
	
	// open the file and save it as a new document
	openFile: function(filePath, docName, model, res) {
		var self = this;
		var content = fs.readFileSync(filePath, 'utf8');
		model.create(docName, 'text', function() {
			model.applyOp(docName, { op: [ { i: content, p: 0 } ], v: 0 }, function() {
				res.redirect('/' + docName);
			});
		});
	},

	// open the blob and saveit as a new document
	openBlob: function(containerName, blobName, model, res) {
		var self = this;
		var content = self.blobClient.getBlobToText(containerName, blobName,  function(err, blob){
			if (!err){
				model.create(blobName, 'text', function() {
					model.applyOp(blobName, { op: [ { i: blob, p: 0 } ], v: 0 }, function() {
						res.redirect('/' + blobName);
					});
				});
			}
			else
				console.log(err);
		});
	},
	
	saveFile: function(docName, model, res){
		var self = this;
		return model.getSnapshot(docName, function(error, data) {
			if (!error){
				var tempPath = 'temp.markdown';
				fs.writeFileSync(tempPath, data.snapshot);
				res.download(tempPath, docName + '.markdown');
			}
		});
	},
	
	preview: function(docName, model, res){
		var self = this;
		return model.getSnapshot(docName, function(error, data) {
			if (!error){
				var markdown = (new Showdown()).makeHtml(data.snapshot);
				var htmlData = { markdown: markdown, docName: docName };
				previewHtml = fs.readFileSync("./edit/preview.html.mu", 'utf8');
				var html = Mustache.to_html(previewHtml, htmlData);
				res.writeHead(200, {'content-type': 'text/html'});
				res.end(html);
			}
		});
	},

	saveBlob: function(blobName, model, res) {
		var self = this;
		var content = self.blobClient.getBlobToText(self.containerName, blobName,  function(err, blob){
			if (!err){
				model.create(blobName, 'text', function() {
					model.applyOp(blobName, { op: [ { i: blob, p: 0 } ], v: 0 }, function() {
						res.redirect('/' + blobName);
					});
				});
			}
			else
				console.log(err);
		});
	},
	
	listAllContainers: function(callback){
		var self = this;
		self.blobClient.listContainers(function(err, result){
			if(!err){
				var names = [];
				for(var key in result){
					names.push(result[key].name);
				}
				callback(null, names);
			}
			else
				callback(err, null);
		});
	},
	
	listAllBlobs: function(containerName, callback){
		var self = this;
		
		
		self.blobClient.listBlobs(containerName, function(err, result){
			if(!err){
				var blobs = [];
				for(var key in result){
					var filePath = result[key].name;
					var folders = result[key].name.split('/');
					var relativePath = '';
					for(var i = 0; i < folders.length - 1; i++){
						var folderPath = relativePath + folders[i];
						relativePath += folders[i] + '/';
						var add = true;
						//check if it's in the array
						for (var j = 0; i < blobs.length; i++){
							if (blobs[j].path == folderPath){
								add = false;
								break;
							}
						}
						if (add){
							var folderName = folderPath.split('/')[folderPath.split('/').length - 1];
							blobs.push({ 'path': folderPath, 'name': folderName ,'type': 'folder'});
						}
					}
					var fileName = filePath.split('/')[filePath.split('/').length - 1];
					blobs.push({ 'path': filePath, 'name': fileName, 'type': 'file'});
				}
				// create the html
				var result = "<ul class='jqueryFileTree' style='display: none;'>";
				
				for(var key in blobs){
					if (blobs[key].type = 'folder'){
						result += "<li class='directory collapsed'><a href='#' rel='/"+ blobs[key].path +"/'>" + blobs[key].name + "</a></li>";
					}
					else
						result += "<li class='file ext_css'><a href='#' rel='" + blobs[key].path + "'>" + blobs[key].name + "</a></li>";
				}
				result += "</ul>";
				callback(null, result);
			}
			else
				console.log(err, null);
		});
	},
	
	listBlobStructure: function(directory, res){
		var self = this;
		var directoryName = directory.replace(/\//g,'').trim();
		if (!directoryName){
			self.listAllContainers(function(err, result){
				if (!err){
					var html = "<ul class='jqueryFileTree' style='display: none;'>";
					for(var key in result){
						html += "<li class='directory collapsed'><a href='#' rel='/" + result[key] + "/'>" + result[key] + "</a></li>";
					}
					res.send(html);
				}
				else
					console.log(err);
			});
		}
		else{
			self.listAllBlobs(directoryName,function(err, result){
				if (!err){
					res.send(result);
				}
				else
					console.log(err);
			});
		}
	},
};
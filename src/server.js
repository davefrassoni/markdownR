var express = require('express'),
	sharejs = require('share'),
	Editor = require('./controllers/Editor.js'),
	fs = require('fs'),
	Settings = require('./settings.js');
	
var app = express.createServer();	
var settings = new Settings();

// Configuration

app.configure(function(){
  app.set('views', __dirname + '/views');
  app.use(express.static(__dirname + '/public'));
  app.use(express.static(__dirname + '/'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser());
  app.use(express.session({ secret: "markdownr editor" }));
  app.use(app.router);
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true })); 
});

app.configure('production', function(){
  app.use(express.errorHandler()); 
});

// Routes
var editor = new Editor(settings.tempStorePath);

app.get('/?', function(req, res, next) {
	res.redirect('/new');
});

app.get('/getBlobStoragePath', function(req, res, next) {
	res.json({ blobPath: settings.blobStoragePath });
});

app.get('/:docName', function(req, res, next) {
	var docName = req.params.docName;
	editor.openDocument(docName, app.model, res, next);
});

app.post('/openFile', function(req, res) {
	var path = req.files.openFileInput.path;
	editor.openFile(path, app.model, req, res);
});

app.post('/openBlob', function(req, res) {
	var containerName = req.body.blobSelected.split('/')[0];
	var blobArray = req.body.blobSelected.split('/');
	blobArray.shift();
	var blobName = blobArray.toString().replace(/,/g,'/');
	editor.openBlob(containerName, blobName, app.model, res);
});

app.get('/saveFile/:docName', function(req, res) {
	var docName = req.params.docName;
	editor.saveDocumentToFile(docName, app.model, res);
});

app.get('/preview/:docName', function(req, res) {
	var docName = req.params.docName;
	editor.preview(docName, app.model, res);
});

app.post('/saveToBlob', function(req, res) {
	var saveInfo = JSON.parse(req.body.saveToBlobInfo);
	editor.saveDocumentToBlob(saveInfo.documentName, saveInfo.container, saveInfo.blobName, app.model, res);
});	

app.post('/listBlobStructure', function(req, res) {
	var directory = unescape(req.body.dir);
	editor.listBlobStructure(directory, req, res);
});

app.post('/listBlobFolderStructure', function(req, res) {
	var directory = unescape(req.body.dir);
	editor.listBlobStructure(directory, req, res, { 'showFiles': false });
});

app.post('/pasteimage', function(req, res) {
    var fileName = req.body.fileName;
	var dataURL = req.body.dataURL;
    editor.saveStreamToBlob(fileName, dataURL, app.model, res);
});

// Start sharejs and the app
var options = { db: { type: 'none'}, port: 8081};
sharejs.server.attach(app, settings.options);
app.listen(settings.options.port);

process.title = 'markdownr'
process.on('uncaughtException', function (err) {
  console.error(err.stack);
});

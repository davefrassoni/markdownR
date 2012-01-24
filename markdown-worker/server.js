var express = require('express'),
	sharejs = require('share'),
	Editor = require('./edit/Editor.js'),
	azure = require('azure');

var app = express.createServer();	

// Configuration

app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(__dirname + '/'));
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true })); 
});

app.configure('production', function(){
  app.use(express.errorHandler()); 
});


// Routes

process.env.EMULATED = true;
var blobService = azure.createBlobService();
var editor = new Editor(blobService);

app.get('/?', function(req, res, next) {
	res.redirect('/new');
});

app.get('/:docName', function(req, res, next) {
	var docName = req.params.docName;
	editor.openDocument(docName, app.model, res, next);
});

app.post('/openFile', function(req, res, next) {
	var path = req.files.openFileInput.path;
	var docName = req.files.openFileInput.name.split('.')[0];
	editor.openFile(path, docName, app.model, res);
});

app.post('/openBlob', function(req, res) {
	var containerName = req.body.containerSelect;
	var blobName = req.body.blobSelect;
	editor.openBlob(containerName, blobName, app.model, res);
});

app.get('/saveFile/:docName', function(req, res, next) {
	var docName = req.params['docName'];
	editor.saveFile(docName, app.model, res, next);
});

app.post('/saveBlob/:blobName', function(req, res, next) {
	var blobName = req.params.blobName;
	editor.saveBlob(blobName, app.model, res);
});	

app.post('/listAllContainers', function(req, res) {
	editor.listAllContainers(res);
});

app.post('/listAllBlobs', function(req, res) {
	var containerName = req.body.containerName;
	editor.listAllBlobs(containerName, res);
});

var options = {
  db: {type: 'none'},
  port: 8081
};

sharejs.server.attach(app, options);

app.listen(options.port);
console.log("Demos running at http://localhost:" + options.port);

process.title = 'markdownr'
process.on('uncaughtException', function (err) {
  console.error(err.stack);
});

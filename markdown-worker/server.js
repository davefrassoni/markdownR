var express = require('express'),
	sharejs = require('share'),
	Editor = require('./edit/Editor.js'),
	formidable = require('formidable');

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

var editor = new Editor();

app.get('/?', function(req, res, next) {
	res.writeHead(301, {location: '/new'});
	res.end();
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

app.post('/openBlob/:docName', function(req, res, next) {
	var docName;
	editor.openBlob(docName, app.model, res, next);
});

app.get('/saveFile/:docName', function(req, res, next) {
	var docName = req.params['docName'];
	editor.saveFile(docName, app.model, res, next);
});

app.post('/saveBlob/:docName', function(req, res, next) {
	var docName;
	editor.saveBlob(docName, app.model, res, next);
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

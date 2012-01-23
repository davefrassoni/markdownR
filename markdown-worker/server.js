var connect = require('connect'),
	sharejs = require('share'),
	Editor = require('./edit/Editor.js'),
	formidable = require('formidable');

var server = connect(
	connect.favicon(),
	connect.static(__dirname + '/'),
	connect.router(function (app) {
		
		var editor = new Editor();
		
		app.get('/?', function(req, res, next) {
			res.writeHead(301, {location: '/new'});
			res.end();
		});
		
		app.get('/:docName', function(req, res, next) {
			var docName;
			docName = req.params.docName;
			editor.openDocument(docName, server.model, res, next);
		});

		app.post('/openFile', function(req, res, next) {
			var form = new formidable.IncomingForm();
			form.parse(req, function(err, fields, files) {
				editor.openFile(files.openFileInput.path, files.openFileInput.name, server.model, res, next);
			});
		});

		app.post('/openBlob/:docName', function(req, res, next) {
			var docName;
			editor.openBlob(docName, server.model, res, next);
		});

		app.post('/saveToFile/:docName', function(req, res, next) {
			var docName;
			editor.saveDocument(docName, server.model, res, next);
		});

		app.post('/saveToBlob/:docName', function(req, res, next) {
			var docName;
			editor.saveToBlob(docName, server.model, res, next);
		});	
	})
);

var options = {
  db: {type: 'none'},
  port: 8081
};

sharejs.server.attach(server, options);

server.listen(options.port);
console.log("Demos running at http://localhost:" + options.port);

process.title = 'markdownr'
process.on('uncaughtException', function (err) {
  console.error(err.stack);
});

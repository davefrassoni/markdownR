require('coffee-script'); 
var connect = require('connect'),
	sharejs = require('share');

var server = connect(
	connect.favicon(),
	connect.static(__dirname + '/'),
	connect.router(function (app) {
		var editor = require('./edit');
		app.get('/?', function(req, res, next) {
			res.writeHead(301, {location: '/editor/new'});
			res.end();
		});

		app.get('/editor/:docName', function(req, res, next) {
			var docName;
			docName = req.params.docName;
			editor(docName, server.model, res, next);
		});
	})
);

var options = {
  db: {type: 'none'},
  auth: function(client, action) {
		// This auth handler rejects any ops bound for docs starting with 'readonly'.
    if (action.name === 'submit op' && action.docName.match(/^readonly/)) {
      action.reject();
    } else {
      action.accept();
    }
  }
};

console.log("ShareJS example server v" + sharejs.version);
console.log("Options: ", options);

var port = 8081;

sharejs.server.attach(server, options);

server.listen(port);
console.log("Demos running at http://localhost:" + port);

process.title = 'markdownr'
process.on('uncaughtException', function (err) {
  console.error(err.stack);
});

var Showdown = require('../lib/markdown/showdown').converter;
var Mustache = require('mustache');
var fs = require('fs');

var template = fs.readFileSync("./edit/editor.html.mu", 'utf8');
var defaultContent = function(name) {
  return "# " + name + " page\n\nThis editor page is currently empty.\n\nYou can put some content in it with the editor on the right. As you do so, the document will update live on the left, and live for everyone else editing at the same time as you. Isn't that cool?\n\nThe text on the left is being rendered with markdown, so you can do all the usual markdown stuff like:\n\n- Bullet\n  - Points\n\n[links](http://google.com)\n\n[Go back to the main page](Main)";
};

module.exports = Editor;

function Editor(){
	// do nothing
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
	
	// file in DB
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
	
	// file in client file system
	openFile: function(filePath, fileName, model, res) {
		var self = this;
		var content = fs.readFileSync(filePath, 'utf8');
		return model.create(fileName, 'text', function() {
			return model.applyOp(fileName, { op: [ { i: content, p: 0 } ], v: 0 }, function() {
				return self.render(content, fileName, res);
			});
		});
	}
};
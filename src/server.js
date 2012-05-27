var express = require('express'),
	sharejs = require('share'),
	Editor = require('./controllers/Editor.js'),
	fs = require('fs'),
	Settings = require('./settings.js');

var settings = new Settings();
	
if (settings.auth.enabled) {
	var everyauth = require('everyauth');

	everyauth.debug = false;  // true= if you want to see the output of the steps

	everyauth.azureacs
	  .identityProviderUrl(settings.auth.identityProviderUrl)
	  .entryPath('/auth/azureacs')
	  .callbackPath('/auth/azureacs/callback')
	  .signingKey(settings.auth.signingKey)
	  .realm(settings.auth.realm)
	  .homeRealm(settings.auth.homeRealm || '') // if you want to use a default idp (like google/liveid)
	  .tokenFormat('swt')  // only swt supported for now
	  .findOrCreateUser( function (session, acsUser) {
	     // you could enrich the "user" entity by storing/fetching the user from a db
	    return null;
	  })
	  .redirectPath('/');

	everyauth.everymodule.logoutRedirectPath('/bye');
}

var app = express.createServer();	

// Configuration

app.configure(function(){
  app.set('views', __dirname + '/views');
  app.use(express.static(__dirname + '/public'));
  app.use(express.static(__dirname + '/'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser());
  app.use(express.session({ secret: "markdownr editor" }));
  
  if (settings.auth.enabled) {
	app.use(everyauth.middleware());
	app.use(denyAnonymous(['/bye']));  // deny anonymous users to all routes
	everyauth.helpExpress(app);
  }

  app.use(app.router);
});


app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true })); 
});

app.configure('production', function(){
  app.use(express.errorHandler()); 
});

// deny anonymous middleware
function denyAnonymous(exclude) {
	return function(req, res, next) {
	    if (exclude && exclude.indexOf(req.url) >= 0)
	    	next();
	    else {
	    	if (typeof(req.session.auth) == 'undefined' || !req.session.auth.loggedIn) {
		    	req.session.originalurl = req.url;
		    	res.redirect('/auth/azureacs');
		    	res.end();
		    } else {
		    	var originalUrl = req.session.originalurl;
		    	if (originalUrl !== null && originalUrl !== '') {
		    		req.session.originalurl = '';
		    		res.redirect(originalUrl);
		    	} else {
		    		next();	    		
		    	}
		    }	
	    } 
  	}
}

// Routes
var editor = new Editor(settings.tempStorePath);

app.get('/?', function(req, res, next) {
	res.redirect('/new');
});

app.get('/bye', function(req, res, next) {
	res.writeHead(200, {'Content-Type': 'text/plain' });
	res.end('Thanks for using MarkdownR.');
});

app.get('/getBlobStoragePath', function(req, res, next) {
	res.json({ blobPath: settings.blobStoragePath });
});

app.get('/:docName', function(req, res, next) {
	if (settings.auth.enabled) {
		var userName = req.session.auth.azureacs.user.azureacs['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name'];
		console.log(userName)
		editor.setUser(userName);
	}

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
sharejs.server.attach(app, settings.options);
app.listen(settings.options.port);

process.title = 'markdownr'
process.on('uncaughtException', function (err) {
  console.error(err.stack);
});

// tinyChat App Section
var io = require('socket.io').listen(app, { log: false });
	sanitizer = require('sanitizer'),
	users = [];

io.sockets.on('connection', function (socket) {
	var myNick = 'guest',
		myColor = rndColor();
	users.push({ id: socket.id, nick: myNick, color: myColor });
	
	io.sockets.emit('userJoined', { nick: myNick, color: myColor });
	io.sockets.emit('users', users);
	
	socket.on('message', function (msg) {
		var sanitizedMsg = sanitizer.sanitize(msg.text);
		if(sanitizedMsg != msg.text) {
			console.log('(!) Possible attack detected from ' + socket.id + ' (' + myNick + ') : ' + msg.text);
		}
		if(!sanitizedMsg || sanitizedMsg.length>256) {
			return;
		}
		
		io.sockets.emit('message', { text: sanitizedMsg, color: myColor, nick: myNick });
	});
	
	socket.on('nickChange', function (user) {
		var sanitizedNick = sanitizer.sanitize(user.nick);
		if(sanitizedNick != user.nick) {
			console.log('(!) Possible attack detected from ' + socket.id + ' (' + myNick + ') : ' + user.nick);
		}
		if(!sanitizedNick || myNick == sanitizedNick || sanitizedNick.length>32) {
			return;
		}
		
		io.sockets.emit('nickChange', { newNick:sanitizedNick, oldNick: myNick, color: myColor });
		myNick = sanitizedNick;
		
		for(var i = 0; i<users.length; i++) {
			if(users[i].id == socket.id) {
				users[i].nick = myNick;
				break;
			}
		}
		
		io.sockets.emit('users', users);
	});
	
	socket.on('disconnect', function () {
		io.sockets.emit('userLeft', { nick: myNick, color: myColor });
		for(var i = 0; i<users.length; i++) {
			if(users[i].id == socket.id) {
				users.splice(i,1);
				break;
			}
		}
		
		io.sockets.emit('users', users);
	});
	
	function rndColor() {
		var color = '#'+(0x1000000+(Math.random())*0xffffff).toString(16).substr(1,6);
		return color;
	};
});
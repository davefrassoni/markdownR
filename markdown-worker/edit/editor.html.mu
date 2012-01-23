<html>
  <head>
    <title>MarkdownR {{name}}</title>
    <link href="/edit/style.css" rel="stylesheet" type="text/css">
    <link rel="stylesheet" href="http://twitter.github.com/bootstrap/1.4.0/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"></script>
    <script src="http://twitter.github.com/bootstrap/1.4.0/bootstrap-modal.js" type="text/javascript"></script>
    <script src="http://twitter.github.com/bootstrap/1.4.0/bootstrap-dropdown.js"></script>
  </head>

  <body>
	  <div id="modal-open" class="modal hide fade">
		<div class="modal-header">
		  <a href="#" class="close">&times;</a>
		  <h3>Open File</h3>
		</div>
  <form id="openForm" action="../openFile" method="post" enctype="multipart/form-data">
		<div class="modal-body">
		  <p>Open from File System</p>
		  <input id="openFileInput" name="openFileInput" type="file" />
		</div>
		<div class="modal-footer">
		  <input id="openFileButton" class="btn primary" type="submit" value="Ok" />
		  <button id="closeFileButton" class="btn secondary">Close</button>
		</div>
	  </form>

	  </div>
    <div id="modal-export" class="modal hide fade">
    <div class="modal-header">
      <a href="#" class="close">&times;</a>
      <h3>Export to...</h3>
    </div>
    <div class="modal-body">
      <p>Exporting to...</p>
    </div>
    <div class="modal-footer">
      <button id="openExportButton" class="btn primary">Ok</button>
      <button id="closeExportButton" class="btn secondary">Cancel</button>
    </div>
  </div>
    <div id="modal-settings" class="modal hide fade">
    <div class="modal-header">
      <a href="#" class="close">&times;</a>
      <h3>Settings</h3>
    </div>
    <div class="modal-body">
      <p>Settings</p>
    </div>
    <div class="modal-footer">
      <button id="openSettingsButton" class="btn primary">Ok</button>
      <button id="closeSettingsButton" class="btn secondary">Cancel</button>
    </div>
  </div>
  <div id="modal-contact" class="modal hide fade">
    <div class="modal-header">
      <a href="#" class="close">&times;</a>
      <h3>Contact us:</h3>
    </div>
    <div class="modal-body">
    <form>
      <fieldset>
      <div class="clearfix">
        <label for="name">Name:</label>
        <div class="input">
          <input id="name" class="span5" type="text" />
        </div>
      </div>
      <div class="clearfix">
        <label for="email">Email:</label>
        <div class="input">
          <input id="email" class="span5" type="text" />
        </div>
      </div>
      <div class="clearfix">
        <label for="message">Message:</label>
        <div class="input">
          <textarea cols=20 rows=10 class="span5" id="message"></textarea>
        </div>
      </div>
    </fieldset>
    </form>
    </div>
    <div class="modal-footer">
      <button id="openContactButton" class="btn primary">Ok</button>
      <button id="closeContactButton" class="btn secondary">Cancel</button>
    </div>
  </div>
    <div class="topbar-wrapper">
      <div class="topbar">
        <div class="topbar-inner">
          <div class="container" style="width:100%">
            <ul class="nav" style="float:right;">
              <li class="dropdown" data-dropdown="dropdown" >
                <a href="#" class="dropdown-toggle">Open</a>
                <ul class="dropdown-menu">
                  <li><a href="#" data-controls-modal="modal-open" data-backdrop="true" data-keyboard="true">From File System</a></li>
                  <li><a href="#">From GitHub</a></li>
                  <li class="divider"></li>
                  <li><a href="#">From Other Location</a></li>
                </ul>
              </li>
              <li><a href="#">Save</a></li>
              <li><a href="#" data-controls-modal="modal-export" data-backdrop="true" data-keyboard="true">Export</a></li>
              <li><a href="#" data-controls-modal="modal-settings" data-backdrop="true" data-keyboard="true">Settings</a></li>
              <li><a href="#" data-controls-modal="modal-contact" data-backdrop="true" data-keyboard="true">Contact Us</a></li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    <div class="container-fluid">
    <div id="viewer" class="sidebar">
      <div id="view">{{{markdown}}}</div>
    </div>
    <div id="editor" class="content">{{{content}}}</div>
    </div>

    <script src="../lib/markdown/showdown.js" type="text/javascript"></script>
    <script src="../lib/ace/ace.js" type="text/javascript" charset="utf-8"></script>
    <script src="/socket.io/socket.io.js"></script>
    <script src="/share/share.js"></script>
    <script src="/share/ace.js"></script>
    <script>
		window.onload = function() {
		  var converter = new Showdown.converter();
		  var view = document.getElementById('view');

			  var editor = ace.edit("editor");
		  editor.setReadOnly(true);
		  editor.session.setUseWrapMode(true);
		  editor.setShowPrintMargin(false);

		  // This could instead be written simply as:
		  // sharejs.open('{{{docName}}}', function(doc, error) {
		  //   ...

		  var connection = new sharejs.Connection('http://' + window.location.hostname + ':' + 8081 + '/sjs');

		  connection.open('{{{docName}}}', function(error, doc) {
			if (error) {
			  console.error(error);
			  return;
			}
			doc.attach_ace(editor);
			editor.setReadOnly(false);

			var render = function() {
			  view.innerHTML = converter.makeHtml(doc.snapshot);
			};

			window.doc = doc;

			render();
			doc.on('change', render);
		  });
		};

		$('#openFileButton').click(function() {
		  $('#modal-open').modal('hide');  
		});
		
		$('#openSaveButton').click(function() {
		  $('#modal-save').modal('hide');
		});
		$('#openExportButton').click(function() {
		  $('#modal-export').modal('hide');
		});
		$('#openSettingsButton').click(function() {
		  $('#modal-settings').modal('hide');
		});
		$('#openContactButton').click(function() {
		  $('#modal-contact').modal('hide');
		});

		$('#closeFileButton').click(function() {
		  $('#modal-open').modal('hide');
		});
		$('#closeSaveButton').click(function() {
		  $('#modal-save').modal('hide');
		});
		$('#closeExportButton').click(function() {
		  $('#modal-export').modal('hide');
		});
		$('#closeSettingsButton').click(function() {
		  $('#modal-settings').modal('hide');
		});
		$('#closeContactButton').click(function() {
		  $('#modal-contact').modal('hide');
		});
    </script>
  </body>
</html>  


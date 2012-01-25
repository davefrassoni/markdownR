<html>
  <head>
    <title>MarkdownR {{name}}</title>
    <link rel="stylesheet" type="text/css" href="/edit/style.css">
    <link rel="stylesheet" type="text/css" href="/lib/bootstrap.min.css">
    <script type="text/javascript" src="/lib/jquery-1.6.4.min.js"></script>
    <script type="text/javascript" src="/lib/bootstrap-modal.js"></script>
    <script type="text/javascript" src="/lib/bootstrap-dropdown.js"></script>
    <script type="text/javascript" src="http://jqueryjs.googlecode.com/files/jquery-1.3.2.js"></script>
  </head>
  <body>
	  <div id="modal-openFromFile" class="modal hide fade">
  		<div class="modal-header">
  		  <a href="#" class="close">&times;</a>
  		  <h3>Open from File System</h3>
  		</div>
      <form id="openFileForm" action="../openFile" method="post" enctype="multipart/form-data">
    		<div class="modal-body">
    		  <p>Select the File</p>
    		  <input id="openFileInput" name="openFileInput" type="file" accept="text" size="70" />
    		</div>
    		<div class="modal-footer">
    		  <input id="openFileButton" class="btn primary" type="submit" value="Ok" />
    		  <button id="closeFileButton" class="btn secondary">Close</button>
    		</div>
  	  </form>
  	</div>
    <div id="modal-openFromBlob" class="modal hide fade">
      <div class="modal-header">
        <a href="#" class="close">&times;</a>
        <h3>Open from Blob</h3>
      </div>
	  <form id="openBlobForm" action="../openBlob" method="post">
		  <div class="modal-body span5">
			<p>Select one of the following blobs:</p>
			<select id="containerSelect" name="containerSelect" class="medium" size="10" style="height:80px; width:150px">
				<option value=""></option>
			</select>
			<select id="blobSelect" name="blobSelect" class="medium" size="10" style="height:80px; width:150px">
				<option value=""></option>
			</select>
		</div>
		  <div class="modal-footer">
			<input id="openBlobButton" class="btn primary" type="submit" value="Ok" />
			<button id="closeBlobButton" class="btn secondary">Close</button>
		  </div>
	  </form>
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
  </div>
    <div class="topbar-wrapper">
      <div class="topbar">
        <div class="topbar-inner">
          <div class="container" style="width:100%">
            <ul class="nav" style="float:right;">
              <li class="dropdown" data-dropdown="dropdown" >
                <a href="#" class="dropdown-toggle">Open</a>
                <ul class="dropdown-menu">
                  <li><a href="#" data-controls-modal="modal-openFromFile" data-backdrop="true" data-keyboard="true">From File System</a></li>
                  <li><a href="#" data-controls-modal="modal-openFromBlob" data-backdrop="true" data-keyboard="true">From Blob Storage</a></li>
                  <li class="divider"></li>
                  <li><a href="#">From GitHub</a></li>
                </ul>
              </li>
              <li><a id='openSaveButton' href='../saveFile/{{{docName}}}'>Save</a></li>
              <li><a id='openPreviewButton' href='../preview/{{{docName}}}'>Preview</a></li>
              <li><a href="#" data-controls-modal="modal-settings" data-backdrop="true" data-keyboard="true">Settings</a></li>
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
	
		$(document).ready(function() {
		  var converter = new Showdown.converter();
		  var view = document.getElementById('view');

		  var editor = ace.edit("editor");
		  editor.setReadOnly(true);
		  editor.session.setUseWrapMode(true);
		  editor.setShowPrintMargin(false);

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
		
			// bindings
			$('#modal-openFromBlob').bind('show', function(){
				$.post('../listAllContainers', function(data) {
					$("#containerSelect").empty();
					$.each(data.containerNames, function(index, value){
						$("#containerSelect").append(new Option(value,value));
					});
				});
			});
		});

		$('#containerSelect').change(function(){
			$("#blobSelect").empty();
			$.post('../listAllBlobs',{ 'containerName': $(this).val()  },function(data) {
				$.each(data.blobNames, function(index, value){
					$("#blobSelect").append(new Option(value,value));
				});
			});
		});
		
		$('#openFileButton').click(function() {
		  $('#modal-openFromFile').modal('hide');  
		});
		$('#openBlobButton').click(function() {
		  $('#modal-openFromBlob').modal('hide');  
		});
		$('#openSettingsButton').click(function() {
		  $('#modal-settings').modal('hide');
		});
		$('#closeFileButton').click(function() {
		  $('#modal-openFromFile').modal('hide');
		});
		$('#closeBlobButton').click(function() {
		  $('#modal-openFromBlob').modal('hide');
		});
		$('#closeSettingsButton').click(function() {
		  $('#modal-settings').modal('hide');
		});
    </script>
  </body>
</html>  


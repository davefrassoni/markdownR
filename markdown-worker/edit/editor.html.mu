<html>
  <head>
    <title>MarkdownR {{name}}</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <script type="text/javascript" src="jquery/jquery-1.6.4.min.js"></script>
    
	<!-- bootstrap  -->
	<link rel="stylesheet" type="text/css" href="bootstrap/bootstrap.min.css">
	<script type="text/javascript" src="bootstrap/bootstrap-modal.js"></script>
    <script type="text/javascript" src="bootstrap/bootstrap-dropdown.js"></script>
	
	<!-- validation -->
	<script type="text/javascript" src="jquery/jquery.validate-1.9.min.js"></script>

	<!-- tree file -->
	<script type="text/javascript" src="jqueryFileTree/jqueryFileTree.js"></script>
	<link rel="stylesheet" type="text/css" href="/jqueryFileTree/jqueryFileTree.css">

	<!-- editor -->
	<script src="markdown/showdown.js" type="text/javascript"></script>
    <script src="ace/ace.js" type="text/javascript" charset="utf-8"></script>
    <script src="/socket.io/socket.io.js"></script>
    <script src="/share/share.js"></script>
    <script src="/share/ace.js"></script>
	
  </head>
  <body>
	  <div id="modal-openFromFile" class="modal hide fade">
  		<div class="modal-header">
  		  <a href="#" class="close">&times;</a>
  		  <h3>Open File</h3>
  		</div>
      <form id="openFileForm" action="../openFile" method="post" enctype="multipart/form-data">
    		<div class="modal-body">
			  <p>Select the File:</p>
				<input id="openFileInput" name="openFileInput" type="file" size="50" />
			  
    		</div>
    		<div class="modal-footer">
    		  <input id="openFileButton" class="btn primary submit" type="submit" value="Ok" />
    		  <button id="closeFileButton" class="btn secondary">Close</button>
    		</div>
  	  </form>
  	</div>
    <div id="modal-openFromBlob" class="modal hide fade">
      <div class="modal-header">
        <a href="#" class="close">&times;</a>
        <h3>Open Blob</h3>
      </div>
	  <form id="openBlobForm" action="../openBlob" method="post">
		  <div class="modal-body span5">
			<div id="header" style="width:800px; height:30px">
				<label style="width:170px; text-align:left">Select the blob:</label>
				<input type="text" id="blobSelected" name="blobSelected" class="required" style="width:200px; height:25px" />
			</div>
			<div id="openBlobTreeContainer" style="width:250px; height:200px; border: solid 1px silver; overflow: scroll;" >Loading..</div>
		</div>
		  <div class="modal-footer">
			<input id="openBlobButton" class="btn primary submit" type="submit" value="Ok" />
			<button id="closeBlobButton" class="btn secondary">Close</button>
		  </div>
	  </form>
    </div>
	<div id="modal-saveToBlob" class="modal hide fade">
      <div class="modal-header">
        <a href="#" class="close">&times;</a>
        <h3>Save Blob</h3>
      </div>
	  <form id="saveToBlobForm" action="../saveToBlob" method="post">
		  <div class="modal-body span5">
			<div id="header" style="width:800px; height:30px">
				<label style="width:170px; text-align:left">Select the folder:</label>
				<input type="text" id="saveInfo" name="saveInfo" class="required" style="width:200px; height:25px" />
			</div>
			<div id="saveToBlobTreeContainer" style="width:250px; height:200px; border: solid 1px silver; overflow: scroll;" >Loading..</div>
		</div>
		  <div class="modal-footer">
			<input id="saveToBlobButton" class="btn primary submit" type="submit" value="Ok" />
			<button id="closeSaveToBlobButton" class="btn secondary">Close</button>
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
			  <li class="dropdown" data-dropdown="dropdown" >
                <a href="#" class="dropdown-toggle">Save</a>
                <ul class="dropdown-menu">
                  <li><a id='saveToFileButton' href='../saveFile/{{{docName}}}'>To your local disk</a></li>
                  <li><a href="#" data-controls-modal="modal-saveToBlob" data-backdrop="true" data-keyboard="true">To Blob Storage</a></li>
                  <li class="divider"></li>
                  <li><a href="#">To GitHub</a></li>
                </ul>
              </li>
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
		
			// forms validation
			$('#openFileForm').validate({
				rules:{
					openFileInput: {
					  required: true,
					  accept: "markdown|md"
					}
				}
			});
			
			$('#openBlobForm').validate({
				rules:{
					blobSelected: {
					  required: true
					}
				}
			});
			
			$('#saveToBlobForm').validate({
				rules:{
					saveInfo: {
					  required: true
					}
				}
			});
			
			// click events
			$('#openFileButton').click(function() {
			  if ($('#openFileForm').valid())
				$('#modal-openFromFile').modal('hide');  
			});
			$('#openBlobButton').click(function() {
			  if ($('#openBlobForm').valid()) 
				$('#modal-openFromBlob').modal('hide');  
			});
			$('#saveToBlobButton').click(function() {
			  if ($('#saveToBlobForm').valid()) 
				$('#modal-saveToBlob').modal('hide');  
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
			
			// bindings
			$('#modal-openFromBlob').bind('show', function(){
				$('#openBlobTreeContainer').fileTree({ root: '', script: '../listBlobStructure', multiFolder: false, select: 'files' }, function(file) {
					$("#blobSelected").val(file);
				});
			});
			$('#modal-saveToBlob').bind('show', function(){
				$('#saveToBlobTreeContainer').fileTree({ root: '', script: '../listBlobFolderStructure', multiFolder: false, select: 'folders' }, function(file) {
					var fullPathArray = file.split('/');
					var container = fullPathArray.shift();
					var blobName = fullPathArray.toString().replace(/,/g,'/');
					saveInfo = { 'documentName': '{{{docName}}}', 'container': container, 'blobName': blobName + '{{{docName}}}' };
					$("#saveInfo").val(JSON.stringify(saveInfo));
				});
			});
		});
    </script>
  </body>
</html>  


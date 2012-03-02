<html>
  <head>
    <title>MarkdownR {{name}}</title>
    <script type="text/javascript" src="jquery/jquery-1.6.4.min.js"></script>
    
	<!-- bootstrap  -->
	<link rel="stylesheet" type="text/css" href="bootstrap/bootstrap.min.css">
	<script type="text/javascript" src="bootstrap/bootstrap-modal.js"></script>
    <script type="text/javascript" src="bootstrap/bootstrap-dropdown.js"></script>
	
	<!-- validation -->
	<script type="text/javascript" src="jquery/jquery.validate-1.9.min.js"></script>

	<!-- tree file -->
	<link rel="stylesheet" type="text/css" href="jqueryFileTree/jqueryFileTree.css">
	<script type="text/javascript" src="jqueryFileTree/fileTreeHelper.js"></script>
	<script type="text/javascript" src="jqueryFileTree/jqueryFileTree.js"></script>
	
	<!-- editor -->
	<script type="text/javascript" src="markdown/showdown.js"></script>
    <script type="text/javascript" src="ace/ace.js"></script>
    <script type="text/javascript" src="socket.io/socket.io.js"></script>
    <script type="text/javascript" src="share/share.js"></script>
    <script type="text/javascript" src="share/ace.js"></script>
    <script type="text/javascript" src="ace/theme-textmate.js"></script>
    <script type="text/javascript" src="ace/mode-markdown.js"></script>
	
	<script type="text/javascript" src="http://malsup.github.com/jquery.form.js"></script>
	
	<!-- markdown -->
	<link rel="stylesheet" type="text/css" href="Site.css">
  </head>
  <body>
	  <div id="modal-openFromFile" class="modal hide fade">
  		<div class="modal-header">
  		  <a href="#" class="close">&times;</a>
  		  <h3>Open File</h3>
  		</div>
		<form id="openFileForm" action="../openFile" method="post" enctype="multipart/form-data">
			<div id="openFileContainer" class="modal-body">
			  <p>Select a File:</p>
				<input id="openFileInput" name="openFileInput" type="file" />
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
		  <div id="openBlobContainer" class="modal-body">
			<p>Select a blob:</p>
			<div id="openBlobTreeContainer" class="treeContainer" >Loading..</div>
			<input type="text" id="blobSelected" name="blobSelected" class="required" style="visibility:hidden;height:0px; padding: 0;" />
		  </div>
		  <div class="modal-footer">
			<input id="openBlobButton" class="btn primary submit" type="submit" value="Ok" />
			<button id="closeOpenBlobButton" class="btn secondary">Close</button>
		  </div>
	  </form>
    </div>
	<div id="modal-openFromGithub" class="modal hide fade">
      <div class="modal-header">
        <a href="#" class="close">&times;</a>
        <h3>Open from github</h3>
      </div>
	  <form id="openGithubForm" action="../openBlob" method="post">
		  <div id="openGithubContainer" class="modal-body">
			<p>Select a file:</p>
			<div id="openGithubTreeContainer" class="treeContainer" >Loading..</div>
			<input type="text" id="githubFileSelected" name="githubFileSelected" class="required" style="visibility:hidden;height:0px; padding: 0;" />
		  </div>
		  <div class="modal-footer">
			<input id="openGithubButton" class="btn primary submit" type="submit" value="Ok" />
			<button id="closeOpenGithubButton" class="btn secondary">Close</button>
		  </div>
	  </form>
    </div>
	<div id="modal-saveToBlob" class="modal hide fade">
      <div class="modal-header">
        <a href="#" class="close">&times;</a>
        <h3>Save Blob</h3>
      </div>
	  <form id="saveToBlobForm" action="../saveToBlob" method="post">
		<div id="saveToBlobContainer" class="modal-body">
			<p>Select a folder:</p>
			<div id="saveToBlobTreeContainer" class="treeContainer" >Loading..</div>
			<input type="text" id="saveInfo" name="saveInfo" class="required" style="visibility:hidden;height:0px; padding: 0;" />
		</div>
		<div class="modal-footer">
			<input id="saveToBlobButton" class="btn primary submit" type="submit" value="Ok" />
			<button id="closeSaveToBlobButton" class="btn secondary">Close</button>
	    </div>
	  </form>
    </div>
	<div id="modal-saveToGithub" class="modal hide fade">
      <div class="modal-header">
        <a href="#" class="close">&times;</a>
        <h3>Save File</h3>
      </div>
	  <form id="saveToGithubForm" action="../saveToGithub" method="post">
		<div id="saveToGithubContainer" class="modal-body">
			<p>Select a folder:</p>
			<div id="saveToGithubTreeContainer" class="treeContainer" >Loading..</div>
			<input type="text" id="saveInfo" name="saveInfo" class="required" style="visibility:hidden;height:0px; padding: 0;" />
		</div>
		<div class="modal-footer">
			<input id="saveToGithubButton" class="btn primary submit" type="submit" value="Ok" />
			<button id="closeSaveToGithubButton" class="btn secondary">Close</button>
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
                  <li><a href="#" data-controls-modal="modal-openFromGithub" data-backdrop="true" data-keyboard="true">From Github</a></li>
                </ul>
              </li>
			  <li class="dropdown" data-dropdown="dropdown" >
                <a href="#" class="dropdown-toggle">Save</a>
                <ul class="dropdown-menu">
                  <li><a id='saveToFileButton' href='../saveFile/{{{docName}}}'>To your local disk</a></li>
                  <li><a href="#" data-controls-modal="modal-saveToBlob" data-backdrop="true" data-keyboard="true">To Blob Storage</a></li>
                  <li><a href="#" data-controls-modal="modal-saveToGithub" data-backdrop="true" data-keyboard="true">To Github</a></li>
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
</td>
    
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
				editor.setTheme("ace/theme/textmate");
      	  		editor.getSession().setMode(new (require("ace/mode/markdown").Mode)());
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
					  accept: 'markdown|md'
					}
				},
				messages: {
					openFileInput: {
						required: "You have to select a file from your local disk",
						accept: "You can open only .markdown and .md files"
				}
			   }
			});
			
			$('#openBlobForm').validate({
				rules:{
					blobSelected: {
					  required: true
					}
				},
				messages: {
					blobSelected: {
						required: "You have to select a blob"
					}
				}
			});
			
			$('#saveToBlobForm').validate({
				rules:{
					saveInfo: {
					  required: true
					}
				},
				messages: {
					saveInfo: {
						required: "You have to select a folder"
					}
				}
			});
			
			$('#openGithubForm').validate({
				rules:{
					githubFileSelected: {
					  required: true
					}
				},
				messages: {
					githubFileSelected: {
						required: "You have to select a file"
					}
				}
			});
			
			$('#saveToGithubForm').validate({
				rules:{
					saveInfo: {
					  required: true
					}
				},
				messages: {
					saveInfo: {
						required: "You have to select a folder"
					}
				}
			});
			
			// click events
			$('#openFileButton').click(function() {
			  if ($('#openFileForm').valid())
				$('#modal-openFromFile').modal('hide');  
			});
			$('#closeFileButton').click(function() {
			  $('#modal-openFromFile').modal('hide');
			});
			$('#openBlobButton').click(function() {
			  if ($('#openBlobForm').valid()) 
				$('#modal-openFromBlob').modal('hide');  
			});
			$('#closeOpenBlobButton').click(function() {
			  $('#modal-openFromBlob').modal('hide');
			});
			$('#saveToBlobButton').click(function() {
			  if ($('#saveToBlobForm').valid()) 
				$('#modal-saveToBlob').modal('hide');  
			});
			$('#closeSaveToBlobButton').click(function() {
			  $('#modal-openFromBlob').modal('hide');
			});
			$('#openGithubButton').click(function() {
			  if ($('#openGithubForm').valid()) 
				$('#modal-openFromGithub').modal('hide');  
			});
			$('#closeOpenGithubButton').click(function() {
			  $('#modal-openFromGithub').modal('hide');
			});
			$('#saveToGithubButton').click(function() {
			  if ($('#saveToBlobForm').valid()) 
				$('#modal-saveToGithub').modal('hide');  
			});
			$('#closeSaveToGithubButton').click(function() {
			  $('#modal-saveToGithub').modal('hide');
			});
			$('#openSettingsButton').click(function() {
			  $('#modal-settings').modal('hide');
			});
			$('#closeSettingsButton').click(function() {
			  $('#modal-settings').modal('hide');
			});
			
			// bindings
			$('#modal-openFromBlob').bind('show', function(){
				$('#openBlobTreeContainer').fileTree({ root: '', script: '../listBlobStructure', multiFolder: false, type: 'file', showSelection: true }, function(file) {
					$("#blobSelected").val(file);
				});
			});
			$('#modal-saveToBlob').bind('show', function(){
				$('#saveToBlobTreeContainer').fileTree({ root: '', script: '../listBlobFolderStructure', multiFolder: false, type: 'folder', showSelection: true }, function(file) {
					var fullPathArray = file.split('/');
					var container = fullPathArray.shift();
					var blobName = fullPathArray.toString().replace(/,/g,'/') + '{{{docName}}}'  + '.markdown';
					saveInfo = { 'documentName': '{{{docName}}}', 'container': container, 'blobName': blobName  };
					$("#saveInfo").val(JSON.stringify(saveInfo));
				});
			});
			
			$('#modal-openFromGithub').bind('show', function(){
				$('#openGithubTreeContainer').fileTree({ root: '', script: '../listGithubStructure', multiFolder: false, type: 'file', showSelection: true }, function(file) {
					$("#githubFileSelected").val(file);
				});
			});
			$('#modal-saveToGithub').bind('show', function(){
				$('#saveToGithubTreeContainer').fileTree({ root: '', script: '../listGithubFolderStructure', multiFolder: false, type: 'folder', showSelection: true }, function(file) {
					var fullPathArray = file.split('/');
					var container = fullPathArray.shift();
					var githubFileName = fullPathArray.toString().replace(/,/g,'/') + '{{{docName}}}'  + '.markdown';
					saveInfo = { 'documentName': '{{{docName}}}', 'container': container, 'githubFileName': githubFileName  };
					$("#saveInfo").val(JSON.stringify(saveInfo));
				});
			});
			
			$('#openBlobForm')
				.ajaxForm({
				url : '../openBlob', 
				dataType : 'json',
				success : function (response) {
					if (response.errorMessage != null){
						alert(response.errorMessage);
					}
					
					window.location = response.url;
				},
			});
		});
    </script>
  </body>
</html>  


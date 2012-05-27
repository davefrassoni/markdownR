<!DOCTYPE html>
<html>
  <head>
  	<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
    <title>MarkdownR - {{docName}}</title>
    <script type="text/javascript" src="jquery/jquery-1.6.4.min.js"></script>
    
	<!-- bootstrap  -->
	<link rel="stylesheet" type="text/css" href="bootstrap/bootstrap.min.css">
	<script type="text/javascript" src="bootstrap/bootstrap-modal.js"></script>
    <script type="text/javascript" src="bootstrap/bootstrap-dropdown.js"></script>
	
	<!-- tinyChat -->
	<link rel="stylesheet" type="text/css" href="tinyChat/tinyChat.css">
	<script type="text/javascript" src="tinyChat/tinyChat-client.js"></script>
	<script type="text/javascript" src="jquery/jquery-ui-1.8.20.custom.min.js"></script>
	<script type="text/javascript" src="socket.io/socket.io.js"></script>
	
	<!-- validation -->
	<script type="text/javascript" src="jquery/jquery.validate-1.9.min.js"></script>

	<!-- tree file -->
	<link rel="stylesheet" type="text/css" href="jqueryFileTree/jqueryFileTree.css">
	<script type="text/javascript" src="jqueryFileTree/fileTreeHelper.js"></script>
	<script type="text/javascript" src="jqueryFileTree/jqueryFileTree.js"></script>
	
	<!-- editor -->
	<script type="text/javascript" src="markdown/showdown.js"></script>
    <script type="text/javascript" src="ace/ace.js"></script>
    <script type="text/javascript" src="channel/bcsocket.js"></script>
    <script type="text/javascript" src="share/share.js"></script>
    <script type="text/javascript" src="share/ace.js"></script>
    <script type="text/javascript" src="ace/theme-textmate.js"></script>
    <script type="text/javascript" src="ace/mode-markdown.js"></script>
	
	<script type="text/javascript" src="http://malsup.github.com/jquery.form.js"></script>
	
	<!-- markdown -->
	<link rel="stylesheet" type="text/css" href="Site.css">
  </head>
  <body>
   <div id="modal-newdoc" class="modal hide fade">
		<div class="modal-header">
			<a href="#" class="close">&times;</a>
			<h3>Create New</h3>
		</div>
		<form id="newDocForm" method="post">
			<div class="modal-body">
				<p>Name</p>
				<input id="docNameInput" name="docNameInput" type="text" value="doc1" />
			</div>
			<div class="modal-footer">
			  <input id="openDocButton" class="btn primary submit openModal" type="submit" value="Ok" />
			</div>
		</form>
    </div>
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
			  <input id="openFileButton" class="btn primary submit openModal" type="submit" value="Ok" />
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
			<input id="openBlobButton" class="btn primary submit openModal" type="submit" value="Ok" />
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
			<input id="openGithubButton" class="btn primary submit openModal" type="submit" value="Ok" />
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
			<input type="text" id="saveToBlobInfo" name="saveToBlobInfo" class="required" style="visibility:hidden;height:0px; padding: 0;" />
		</div>
		<div class="modal-footer">
			<input id="saveToBlobButton" class="btn primary submit openModal" type="submit" value="Ok" />
	    </div>
	  </form>
    </div>
	<div id="modal-saveToGithub" class="modal hide fade">
      <div class="modal-header">
        <a href="#" class="close">&times;</a>
        <h3>Save to github</h3>
      </div>
	  <form id="saveToGithubForm" action="../saveToGithub" method="post">
		<div id="saveToGithubContainer" class="modal-body">
			<p>Select a folder:</p>
			<div id="saveToGithubTreeContainer" class="treeContainer" >Loading..</div>
			<input type="text" id="saveToGithubInfo" name="saveToGithubInfo" class="required" style="visibility:hidden;height:0px; padding: 0;" />
		</div>
		<div class="modal-footer">
			<input id="saveToGithubButton" class="btn primary submit openModal" type="submit" value="Ok" />
	    </div>
	  </form>
    </div>
    <div class="topbar-wrapper">
      <div class="topbar">
        <div class="topbar-inner">
          <div class="container" style="width:100%">
            <ul class="nav" style="float:right;">
              <li><a><span id="status" class="label warning">Loading..</span></a></li>
              <li><a id='createNewButton' data-controls-modal="modal-newdoc" data-backdrop="true" data-keyboard="true" href='#'>New Doc</a></li>
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
              {{#isUserSet}}
              <li><a href="/logout">{{user}}</a></li>
              {{/isUserSet}}
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

    <script type="text/javascript">
		$(document).ready(function() {
			var converter = new Showdown.converter();
			var view = document.getElementById('view');

			var editor = ace.edit("editor");
			editor.setReadOnly(true);
			editor.session.setUseWrapMode(true);
			editor.setShowPrintMargin(false);

			var connection = new sharejs.Connection('/channel');
			
			var status = $('#status');
			connection.on('ok', function() {
				status.attr('class','label success');
				status.text('Online');
			});
			connection.on('disconnected', function() {
				status.attr('class','label important');
				status.text('Offline');
			});
			
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
					saveToBlobInfo: {
					  required: true
					}
				},
				messages: {
					saveToBlobInfo: {
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
					saveToGithubInfo: {
					  required: true
					}
				},
				messages: {
					saveToGithubInfo: {
						required: "You have to select a folder"
					}
				}
			});
			
			// open event
			$('.openModal').click(function() {
				var form = $(this).closest('form');
				if (form.valid()){
					$(this).closest('.modal').modal('hide');
				}				
			});
			
			// close event
			$('.closeModal').click(function() {
				$(this).closest('.modal').modal('hide');
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
					saveToBlobInfo = { 'documentName': '{{{docName}}}', 'container': container, 'blobName': blobName  };
					$("#saveToBlobInfo").val(JSON.stringify(saveToBlobInfo));
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
					saveToGithubInfo = { 'documentName': '{{{docName}}}', 'container': container, 'githubFileName': githubFileName  };
					$("#saveToGithubInfo").val(JSON.stringify(saveToGithubInfo));
				});
			});
			
			$('#openBlobForm')
				.ajaxForm({
				url : '../openBlob', 
				dataType : 'json',
				success : function (response) {
					window.location = response.url;
				},
			});	
			
			$('#newDocForm').submit(function() {
				window.location = slugify($('#docNameInput').val());
				return false;
			});

			function slugify(str) {
			  str = str.replace(/^\s+|\s+$/g, ''); // trim
			  str = str.toLowerCase();
			  
			  // remove accents, swap ñ for n, etc
			  var from = "àáäâèéëêìíïîòóöôùúüûñç·/_,:;";
			  var to   = "aaaaeeeeiiiioooouuuunc------";
			  for (var i=0, l=from.length ; i<l ; i++) {
			    str = str.replace(new RegExp(from.charAt(i), 'g'), to.charAt(i));
			  }

			  str = str.replace(/[^a-z0-9 -]/g, '') // remove invalid chars
			    .replace(/\s+/g, '-') // collapse whitespace and replace by -
			    .replace(/-+/g, '-'); // collapse dashes

			  return str;
			}
		});
    </script>

    <script type="text/javascript">
	  var _gaq = _gaq || [];
	  _gaq.push(['_setAccount', 'UA-30150787-1']);
	  _gaq.push(['_trackPageview']);

	  (function() {
	    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
	    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
	    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
	  })();
	</script>    
	
	<div id="chat">
		<div id="chatOpener">&uarr; click here to show the chat &uarr;</div>
		<div id="chatToggler">
			<div id="chatCloser">&darr; click here to hide the chat &darr;</div>
			<div id="chatPeople"></div>
			<div id="chatContent"></div>
			<input type="text" id="chatNick" disabled="disabled" value="guest" maxlength="32" />
			<input type="text" id="chatInput" disabled="disabled" maxlength="256" />
		</div>
	</div>
  </body>
</html>
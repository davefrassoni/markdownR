module.exports.generateContainersHtml = function(containers){
	var html = "<ul class='jqueryFileTree' style='display: none;'>";
	for(var key in containers){
		html += "<li class='directory collapsed'><a href='#' rel='" + containers[key] + "/'>" + containers[key] + "</a></li>";
	}
	html += "</ul>";
	return html;
};

function containsElement(collection, item){

	for (var key in collection){
		if (collection[key].path == item.path)
			return true;
	}
	return false;
}

/* Retrieves the files and folder of that level, in HTML.
 * The blobs array has, for instance, the following structure:
 * [ 'articles/text-file.txt',
 *   'articles/newsletter/article',
 *   'sample.rar',
 *   'test.ps1' ]
 * Which means that we have the following hierarchical structure:
 * -> articles
 * 		-> newsletter	
 *			 _ article (file with no extension)
 * 		_ textFile.txt
 * _ sample.rar
 * _ test.ps1
*/
module.exports.generateBlobsHtml = function(currentPath, blobs){
	
	var elements = [];
	
	// Get the level of the files/folders to retrieve
	var level = currentPath.split('/').length;
	
	// Retrieve only the files and folders in the next level (to obtain the folders we parse the path of deeper files)
	for(var key in blobs){
		var pathArray = blobs[key].split('/'), blobName, blobPath;
		if (pathArray.length == (level + 1) && blobs[key].indexOf(currentPath) != -1){
			blobName = pathArray[pathArray.length - 1];
			blobPath = blobs[key];
			elements.push({ 'name': blobName, 'path': blobPath, 'type': 'file'});
		}
		else{
			if (pathArray.length > level && blobs[key].indexOf(currentPath) != -1){
				blobName = pathArray[level];
				blobPath = '';
				for(var i = 0; i <= level;i++) {
					blobPath += pathArray[i] + '/';
				}
				var element = { 'name': blobName, 'path': blobPath, 'type': 'folder'};
				if(!containsElement(elements, element)){
					elements.push(element);
				}
			}
		}
	}
	
	// Generate the HTML
	var html = "<ul class='jqueryFileTree' style='display: none;'>";
	for(var key in elements){
		var item = elements[key];
		var itemClass = 'file ext_txt'; 
		if (item.type == 'folder')
			itemClass = 'directory collapsed';
		html += "<li class='" + itemClass + "'><a href='#' rel='" + item.path + "'>" + item.name + "</a></li>";
	}
	html += "</ul>";
	return html;
};

module.exports.addRootInPath = function (rootPath, collection){
	for(var key in collection){
		var path = rootPath + '/' +collection[key];
		collection[key] = path;
	}
};
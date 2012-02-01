function generateContainersHtml(containers){
	var list = $('<ul>').addClass('jqueryFileTree').attr('style', 'display: none;');
	$(containers).each(function(index, value){
		list.append(
			$('<li>').addClass('directory collapsed').append(
				$('<a>').attr('href','#').attr('rel', value + '/').text(value)));
	});
	return $('<div>').append(list).html();
};

function generateBlobsHtml(blobs){
	var list = $('<ul>').addClass('jqueryFileTree').attr('style', 'display: none;');
	
	$(blobs).each(function(index, value){
		var blobPath = value;
		var isAFolder = (value[value.length - 1] == '/');
		var blobName = value.replace(/\/$/,'').split('/')[value.replace(/\/$/,'').split('/').length - 1];
		var itemClass = '';
		
		if (isAFolder)
			itemClass = 'directory collapsed';
		else
			itemClass = 'file ext_txt';
		
		list.append(
			$('<li>').addClass(itemClass).append(
				$('<a>').attr('href','#').attr('rel', blobPath).text(blobName)));
	});
	return $('<div>').append(list).html();
};
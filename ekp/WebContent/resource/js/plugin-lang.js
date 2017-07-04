(function(seajs, global) {

	var lang = function(str, url) {
		var param = url.substring(5, url.length), _url = '';
		var params = param.split(':');
		if (params.length < 2)
			params.push('____all');
		_url += ("bundle=" + params[0] + "&prefix=" + params[1]);
		if (seajs.data.env.locale)
			_url += '&locale=' + seajs.data.env.locale;
		url = str.substring(0, str.indexOf("lang!")) + seajs.data.paths['lui']
				+ "/lang/lang.jsp?" + _url
		return url;
	}

	seajs.on("resolve", function(data) {
				var id = data.id;
				if (!id)
					return "";
				var uri = seajs.resolve(id, data.refUri);
				if (id.indexOf("lang!") >= 0) {
					data.uri = lang(uri, id);
				}
			});

})(seajs, this);

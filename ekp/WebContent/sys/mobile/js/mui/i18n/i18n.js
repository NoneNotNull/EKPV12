define([
	    "dojo/request",
		"mui/util"
	], function(request, util) {
	
	var url = "/sys/mobile/js/mui/i18n/i18n.jsp?bundle=!{bundle}";
	
	var getMessage = function(bundle, load) {
		var rqUrl = util.formatUrl(util.urlResolver(url, {'bundle': bundle}));
		request(rqUrl, {sync: false, handleAs: 'json' }).then(load);
	};
	
	return {
		load: function(id, require, load){
			getMessage(id, load);
		}
	};
});
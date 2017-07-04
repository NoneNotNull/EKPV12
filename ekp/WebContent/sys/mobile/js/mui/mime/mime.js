define( [ "dojo/request", "mui/util" ], function(request, util) {

	var url = "/sys/mobile/js/mui/mime/mime.jsp?fileName=!{fileName}";

	return {
		getMime : function(fileName) {
			var mime = "";
			var rqUrl = util.formatUrl(util.urlResolver(url, {
				'fileName' : fileName
			}));
			request(rqUrl, {
				sync : true,
				handleAs : 'json'
			}).then( function(data) {
				if (data["status"] == 1) {
					mime = data['message'];
				}
			});
			return mime;
		}
	};
});
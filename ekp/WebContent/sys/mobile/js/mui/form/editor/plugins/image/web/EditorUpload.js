define([ "dojo/_base/declare", "dojo/request",
		"mui/form/editor/plugins/image/_EditorUploadMixin" ], function(declare,
		request, _EditorUploadMixin) {
	return declare("mui.form.editor._EditorUploadMixin",
			[ _EditorUploadMixin ], {

				_uploadFile : function(file) {
					var canUpload = false;
					var d = null;
					if (window.FormData) {
						d = new FormData;
						d.append("NewFile", file);
						d.append("json", true);
						canUpload = true;
					}
					if (canUpload) {
						var self = this;
						var promise = request.post(this.uploadurl, {
							data : d,
							handleAs : 'json'
						});
						promise.then(function(data) {
							if (data.status == '1') {
								file.status = 2;
								file.filekey = data.filekey;
								self.uploadSuccess(file, data);
							} else {
								file.status = 0;
								self.uploadError(file, {
									rtn : data
								});
							}
						}, function(data) {
							file.status = 0;
							self.uploadError(file, {
								rtn : data
							});
						}, function(response) {
							file.status = 1;
							self.uploadProcess(response.loaded, file);
						});
					} else {
						file.status = 0;
						self.uploadError(file, {
							rtn : {
								'status' : '-1',
								'msg' : '附件上传错误,当前浏览器表单不支持.'
							}
						});
					}
				}
			});
});

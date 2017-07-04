/*
 * 附件上传类
 */
define([ "dojo/_base/declare", "dojo/topic", "dojo/request",
		"mui/form/editor/plugins/image/_EditorUploadMixin" ], function(declare,
		topic, request, _EditorUploadMixin) {
	return declare("mui.device.kk.attachment", [ _EditorUploadMixin ], {

		_kkApi : window.kkApi,

		_formatJson : function(jsonStr) {
			var rtnObj = null;
			if (window.JSON) {
				rtnObj = JSON.parse(jsonStr);
			} else if (rtnStr.parseJSON) {
				rtnObj = jsonStr.parseJSON();
			} else {
				rtnObj = eval("(" + jsonStr + ")");
			}
			return rtnObj;
		},

		_uploadFile : function(file, userKey) {
			var self = this;
			if (window.console) {
				window.console.log("UploadFile begin..");
			}
			this._kkApi.uploadFile({
				"filepath" : file.fullpath,

				"userkey" : userKey,

				"uploadurl" : this.uploadurl,

				"complete" : function(cacheId, fileInfo) {
					if (window.console) {
						window.console.log("UploadFile complete cacheId="
								+ cacheId + ",fileInfo=" + fileInfo);
					}
					var fileJson = self._formatJson(fileInfo);
					file.filekey = fileJson.filekey;
					file.status = 2;
					self.uploadSuccess(file, fileJson);
					self._kkApi._clearCache(cacheId);
				},
				"progress" : function(cacheId, loaded) {
					file.status = 1;
					self.uploadProcess(loaded, file);
				},
				"cancel" : function(cacheId) {
					self._kkApi._clearCache(cacheId);
				},
				"error" : function(cacheId, msg) {
					file.status = 0;
					self.uploadError(file, {
						rtn : {
							'status' : '-1',
							'msg' : '附件上传错误:' + msg
						}
					});
					if (window.console) {
						window.console.error("UploadFile Error:" + msg);
					}
					self._kkApi._clearCache(cacheId);
				}
			});
		}
	});
});

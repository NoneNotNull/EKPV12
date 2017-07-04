/*
 * 附件上传类
 */
define(["dojo/_base/declare", "dojo/request","mui/device/_attachment"],function(declare , request , attachment) {
	return declare("mui.device.web.attachment", [attachment], {

		_uploadFile : function(file , userKey){
			var canUpload=false;
			var d = null;
			if(this.uploadStream == true){
				d = {'userkey':userKey,'data':file.href,'extParam':this.extParam};
				canUpload = true;
			}else{
				if(window.FormData){
					d = new FormData;
					d.append("userkey", userKey);
					d.append("NewFile", file);
					if (this.extParam)
						d.append("extParam", this.extParam);
					canUpload=true;
				}
			}
			if(canUpload){
				var self = this;
				var promise = request.post(this.uploadurl, {
						data : d,
						handleAs : 'json'
					});
				promise.then(function(data) {
					if (data.status == '1') {
						file.status = 2;
						file.filekey = data.filekey;
						self.uploadSuccess(file,data);
					} else {
						file.status = 0;
						self.uploadError(file , {
								rtn : data
							});
					}
				}, function(data) {
					file.status = 0;
					self.uploadError(file , {
							rtn : data
						});
				},function(response){
					file.status = 1;
					self.uploadProcess(response.loaded , file);
				});
			}else{
				file.status = 0;
				self.uploadError(file , {rtn:{'status':'-1','msg':'附件上传错误,当前浏览器表单不支持.'}});
			}
		}
	});
});

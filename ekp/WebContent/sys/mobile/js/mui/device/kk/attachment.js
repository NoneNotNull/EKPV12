/*
 * 附件上传类
 */
define( [ "dojo/_base/declare","dojo/topic", "dojo/request", "mui/device/_attachment","mui/device/kkapi"],
		function(declare, topic , request, attachment) {
			return declare("mui.device.kk.attachment", [ attachment ], {
				
				_uploadFile : function(file, userKey) {
					var self = this;
					if(window.console){
						window.console.log("UploadFile begin..");
					}
					window.kkApi.uploadFile(file, this.uploadurl, userKey, function(fileInfo){
						file.filekey = fileInfo.filekey;
						file.status = 2;
						self.uploadSuccess(file,fileInfo);
					},function(loaded){
						file.status = 1;
						self.uploadProcess(loaded,file);
					},function(errorInfo){
						file.status = 0;
						self.uploadError(file,errorInfo);
					});
				}
			});
		});

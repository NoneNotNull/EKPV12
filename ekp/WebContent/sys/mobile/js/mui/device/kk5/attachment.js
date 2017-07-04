/*
 * 附件上传类
 */
define( [ "dojo/_base/declare","dojo/topic", "dojo/request", "mui/device/_attachment","mui/device/kk5api"],
		function(declare, topic , request, attachment) {
			return declare("mui.device.kk5.attachment", [ attachment ], {
				
				_uploadFile : function(file, userKey) {
					var self = this;
					if(this.uploadStream == true){
						d = {'userkey':userKey,'data':file.href,'extParam':this.extParam};
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
						window.kk5Api.uploadFile(file,this.uploadurl,userKey,function(fileInfo){
							file.status = 2;
							file.filekey = fileInfo.filekey;
							self.uploadSuccess(file,fileInfo);
						},null,function(errorInfo){
							file.status = 0;
							self.uploadError(file,errorInfo);
						});
					}
				
				}
			});
		});

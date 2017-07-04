/*
 * 附件上传类
 */
define(["dojo/_base/declare", "dojo/request", "dojo/topic", "dojo/_base/lang","mui/util"],
		function(declare, request, topic , lang, util) {
			return declare(
					"mui.device._attachment",
					null,{

						fdKey : '',

						fdModelName : '',

						fdModelId : '',

						fdMulti : false,

						//附件类型 office,pic,byte
						fdAttType : 'byte',

						//附件显示样式 office,pic,link
						fdViewType : 'byte',

						//附件处理状态
						editMode : 'edit',
						
						//上传类型
						uploadStream:false,

						//事件前缀
						eventPrefix : "attachmentObject_",

						//获取上传token
						tokenurl : util.formatUrl("/sys/attachment/sys_att_main/sysAttMain.do?method=handleAttUpload&gettype=getuserkey&format=json",true),

						//注册附件信息
						attachurl : util.formatUrl("/sys/attachment/sys_att_main/sysAttMain.do?method=handleAttUpload&gettype=submit&format=json",true),
						//上传附件信息		
						uploadurl : util.formatUrl("/sys/attachment/uploaderServlet?gettype=upload&format=json",true),
						//上传图片base64附件信息
						uploadStreamUrl : util.formatUrl("/sys/attachment/uploaderServlet?gettype=uploadStream&type=pic&format=json",true),

						deleteUrl: util.formatUrl("/sys/attachment/sys_att_main/sysAttMain.do?method=delete&format=json",true),
							
						constructor : function(options) {
							this.init(options);
						},
						
						init : function(options) {
							//设置属性
							this.fdKey = options.fdKey;
							this.fdModelName= options.fdModelName;
							this.fdModelId= options.fdModelId;
							this.fdMulti= options.fdMulti;
							this.fdAttType= options.fdAttType;
							this.editMode= options.editMode;
							this.uploadStream = options.uploadStream;
							if(this.uploadStream == true){
								this.uploadurl = this.uploadStreamUrl;
							}
							
							if (options.extParam) {
								this.extParam = new String(options.extParam);
							}
							//属性间逻辑处理
							if(this.fdKey==null || this.fdKey==''){
								if(window.console)
									window.console.error("附件机制错误:fdKey信息为空!");
								return;
							}
							if(this.fdModelName==null || this.fdModelName==''){
								if(window.console)
									window.console.error("附件机制错误:fdModelName信息为空!");
								return;
							}
							this.fdViewType = this.fdAttType;
							this.eventPrefix = this.eventPrefix + this.fdKey
									+ "_";
							this.UPLOAD_EVENT_START = this.eventPrefix + "start";
							this.UPLOAD_EVENT_SUCCESS =  this.eventPrefix + "success";
							this.UPLOAD_EVENT_FAIL =  this.eventPrefix + "fail";
							this.UPLOAD_EVENT_PROCESS =  this.eventPrefix + "process";
						},

						//生成唯一标示
						guid:(function() {
			                var counter = 0;
			                return function( prefix ) {
			                    var guid = (+ new Date().getTime()).toString( 32 ),
			                        i = 0;
			                    for ( ; i < 5; i++ ) {
			                        guid += Math.floor( Math.random() * 65535 ).toString( 32 );
			                    }
			                    return (prefix || 'mobile_') + guid + (counter++).toString( 32 );                  
			                };
			            })(),
			            
			            //开始上传附件
			            //file信息:fdId, size, name, type, fullpath,status,fileKey
						startUploadFile : function(file) {
							if(file._fdId==null || file._fdId==''){
								file._fdId = this.guid();
							}
							if(window.console){
								window.console.log("startUploadFile begin..");
							}
							file.edit = this.editMode=="edit";
							file.key = this.fdKey;
							file.status = -1;
							var extendData = "filesize=" + file.size + "&md5=";
							var self = this;
							self.uploadStart(file,{});
							request.post(self.tokenurl, {
								data : extendData,
								handleAs : 'json'
							}).then(function(data) {
								if(window.console){
									window.console.log("startUploadFile getToken end.. result:" + data.status );
								}
								if (data.status == '1') {
									file.status = 1;
									self._uploadFile(file, data.userkey);
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
							});
						},
						
						//附件上传后，注册附件信息,同步执行
						registFile:function(file , callback){
							var xdata = "filekey=" + file.filekey + "&filename="
								+ encodeURIComponent(file.name) + "&fdKey="
								+ this.fdKey + "&fdModelName=" + this.fdModelName
								+ "&fdModelId=" + this.fdModelId +"&fdAttType=" + this.fdAttType;
							var self = this;
							request.post(this.attachurl, {
								data : xdata,
								handleAs : 'json',
								sync: true
							}).then(function(data) {
								if (data.status == '1') {
									file.fdId = data.attid; 
									file.status = 2;
									if(callback)
										callback(file,{rtn:data});
								} else {
									file.status = 0;
									if(callback)
										callback(file,{rtn:data});
								}
							}, function(data) {
								file.status = 0;
								if(callback)
									callback(file,{rtn:data});
							});
							return file.fdId;
						},

						_uploadFile : function(file, userKey) {
							//子类各自实现
						},
						
						uploadStart:function(file,context){
							topic.publish(this.UPLOAD_EVENT_START, this, lang.mixin(context , {file:file}));
						},
						
						uploadSuccess : function(file , context) {
							topic.publish(this.UPLOAD_EVENT_SUCCESS, this ,lang.mixin(context , {file:file}));
						},

						uploadError : function(file , context) {
							topic.publish(this.UPLOAD_EVENT_FAIL , this , lang.mixin(context , {file:file}));
						},

						uploadProcess : function(loaded , file) {
							//var percent = Math.round(evt.loaded * 100 / file.size);
							topic.publish(this.UPLOAD_EVENT_PROCESS,this , {file:file, loaded:loaded});
						},
						
						destroy : function() {
							this.inherited(arguments);
						}
					});
		});

/*
 * 用于kk5客户端对应功能接口调用
 */
define(["mui/util",'mui/device/kk5/attachment','mui/mime/mime',"mui/device/kk5/easymilib"],function(util, Attachment, mime) {
	var kk5api = {
			closeWindow : function() {
				window.KK.app.exit();
				return {};
			},
			
			showTitleBar:function(isShow){
				if(isShow){
					window.KK.app.hideTitleBar();
				}else{
					window.KK.app.showTitleBar();
				}
				return {};
			},
			
			goBack : function() {
				window.KK.history.canGo(function(rtnObj){
					if(rtnObj.canGoBack){
						window.KK.history.back();
					}else{
						window.KK.app.exit();
					}
				});
				return {};
			},
			
			goForward : function(){
				window.KK.history.forward();
				return {};
			},
			
			getUserID : function(){
				var userinfo = window.KK.app.getUserInfo();
				if(userinfo!=null)
					return userinfo.loginName;
				return null;
			},
		
			_select : function(feature, context){
				var attSetting = context.options;
				if(!window.AttachmentList)
					window.AttachmentList = {};
				var attachmentObj = window.AttachmentList[attSetting.fdKey];
				if(!attachmentObj){
					attSetting.uploadStream = true;
					attachmentObj = new Attachment(attSetting);
					window.AttachmentList[attSetting.fdKey] = attachmentObj;
				}
				window.KK.media.getPicture({
					sourceType:feature,
					destinationType:'data',
					targetWidth:window.screen.width,  
					targetHeight:window.screen.height,  
					encodingType:'png'
				},function(data, savePath){
					attachmentObj.startUploadFile({
						href : "data:image/png;base64," + data,
						data : data,
						size : data.length,
						name: "image.png"
					});
				},function(){
					attachmentObj.uploadError(null,{
						rtn:{'status':'-1','msg':'附件上传错误'}
					});
				});
				return {};
			},
			
			openCamera:function(context){
				return this._select("camera",context);
			},

			selectFile:function(context){
				return this._select("album",context);
			},
			
			openSpeech:function(context){
				var attSetting = context.options;
				if(!window.AttachmentList)
					window.AttachmentList = {};
				var attachmentObj = window.AttachmentList[attSetting.fdKey];
				if(!attachmentObj){
					attachmentObj = new Attachment(attSetting);
					window.AttachmentList[attSetting.fdKey] = attachmentObj;
				}
				window.KK.media.captureAudioView(function(file){
					attachmentObj.startUploadFile(file);
				},function(code){
					if(code==-3){
						if(window.console){
							window.console.log('录音取消..');
						}
					}
					if(code==-9){
						if(window.console){
							window.console.error('录音出错..');
						}
					}
				});
				return {};
			},
			
			playSpeech:function(voiceUrl){
				window.KK.media.playAudioView(voiceUrl,function(code){
					if(code==-3){
						if(window.console){
							window.console.log('录音播放取消..');
						}
					}
					if(code==-9){
						if(window.console){
							window.console.error('录音播放出错..');
						}
					}
				});
				return {}; 
			},
			//fullPath为全路径，区别kk5以下的api（为小写fullpath）
			uploadFile:function(file, uploadurl, userKey, successFun, progressFun, errorFun){
				var self = this;
				window.KK.proxy.uploadView({
					"token":userKey,
					"userkey": userKey,
					"url": uploadurl,
					"fullPath": file.fullPath
				},function(fileInfo){
					successFun(fileInfo);
				},function(code){
					var msg = "";
					if(code==-1){
						msg = '附件上传网络不可用';
						if(window.console){
							window.console.error(msg);
						}
					}
					if(code==-2){
						msg = '附件上传调用参数错误';
						if(window.console){
							window.console.error(msg);
						}
					}
					if(code==-3){
						msg = '附件上传被取消';
						if(window.console){
							window.console.error(msg);
						}
					}
					if(code==-9){
						msg = '附件上传服务器端出错';
						if(window.console){
							window.console.error(msg);
						}
					}
					if(errorFun){
						errorFun({
							rtn:{'status':'-1','msg':'附件上传错误:' + msg }
						});
					}
				});
				return {};
			},
		
			captureScreen:function(callback){
				window.KK.app.captureScreen({
					targetWidth:window.screen.width,  
					targetHeight:window.screen.height
				},function(imageInfo){
					callback("data:image/png;base64," + imageInfo.imageData);
				},function(code){
					if(window.console)
						window.console.error("截屏出错:" + code);
				});
				return {};
			}
		};
	window.kk5Api = kk5api;
	return kk5api;
});

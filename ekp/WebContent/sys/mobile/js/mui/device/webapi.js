/*
 * 用于web客户端对应功能接口调用
 */
define(["mui/picslide/ImagePreview", "mui/device/web/attachment","mui/form/editor/plugins/image/web/EditorUpload", "mui/util"],function(ImagePreview,Attachment,EditorUpload,util) {
	var webApi = {
			closeWindow : function() {
				location = dojoConfig.baseUrl ? dojoConfig.baseUrl : '/';
				return {};
			},
			
			goBack : function() {
				if(history.length>1){
					history.back();
				}else{
					location = dojoConfig.baseUrl ? dojoConfig.baseUrl : '/';
				}
				return {};
			},
			
			goForward : function(){
				history.forward();
				return {};
			},
			
			getUserID : function(){
				window.building();
				return null;
			},
			
			openSpeech:function(options){
				window.building();
				return null;
			},
			
			openCamera:function(options){
				window.building();
				return null;
			},

			selectFile:function(options){
				this.uploadFile(options);
				return {};
			},
			
			uploadImage : function(options) {
				var evt = options.evt;
				if (evt) {
					var files = evt.target.files;
					if (!window.EditorUpload)
						window.EditorUpload = {};
					var editorUploadObj = window.EditorUpload[options.name];
					if (!editorUploadObj) {
						editorUploadObj = new EditorUpload(options);
						window.EditorUpload[options.name] = editorUploadObj;
					}
					for (var i = 0; i < files.length; i++) {
						editorUploadObj.startUploadFile(files[i]);
					}
					return editorUploadObj;
				}
			},
			
			uploadFile:function(context){
				var options = context.options;
				if(!window.AttachmentList)
					window.AttachmentList = {};
				var attachmentObj = window.AttachmentList[options.fdKey];
				if(!attachmentObj){
					attachmentObj = new Attachment(options);
					window.AttachmentList[options.fdKey] = attachmentObj;
				}
				if(context.evt.target){
					var files = context.evt.target.files;
					for(var i=0 ; i < files.length ; i++){
						var url =  this.readAsDataURL(files[i]);
						if(url){
							files[i].href = url;
						}
						attachmentObj.startUploadFile(files[i]);
					}
				}else{
					attachmentObj.startUploadFile({
						href : context.evt.dataURL,
						size : context.evt.dataURL.size,
						name: "image.png"
					});
				}
				return {};
			},
			
			playSpeech:function(options){
				window.building();
				return null;
			},
			
			imagePreview:function(options){
				if(!this.preivew)
					this.preivew = new ImagePreview();
				this.preivew.play(options);
				return {};
			},
			
			download : function(options) {
				location.href = util.formatUrl(options.href);
			},
			
			captureScreen:function(options){
				window.building();
				return null;
			},
			
			readAsDataURL:function(file){
				if(window.URL){
					return window.URL.createObjectURL(file);
				}else if(window.webkitURL){
					return window.webkitURL.createObjectURL(file);
				}
				return null;
			}
		};
	return webApi;
});

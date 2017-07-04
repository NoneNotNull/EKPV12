define(
		[ "dojo/_base/declare", "dojo/topic", "dojo/_base/lang", "mui/util" ],
		function(declare, topic, lang, util) {
			return declare(
					"mui.form.editor._EditorUploadMixin",
					null,
					{

						fdKey : '',

						fdMulti : false,

						// 事件前缀
						eventPrefix : "editorUpload_",

						// 上传附件信息
						uploadurl : util
								.formatUrl(
										"/resource/fckeditor/editor/filemanager/upload/simpleuploader?Type=Image",
										true),

						downloadUrl : util
								.formatUrl('/resource/fckeditor/editor/filemanager/download'),

						constructor : function(options) {
							this.init(options);
						},

						init : function(options) {
							// 设置属性
							this.fdMulti = options.fdMulti;
							this.UPLOAD_EVENT_START = this.eventPrefix
									+ "start";
							this.UPLOAD_EVENT_SUCCESS = this.eventPrefix
									+ "success";
							this.UPLOAD_EVENT_FAIL = this.eventPrefix + "fail";
							this.UPLOAD_EVENT_PROCESS = this.eventPrefix
									+ "process";

							if (options.fdModelName)
								this.uploadurl += "&fdModelName="
										+ options.fdModelName;
							if (options.fdModelId)
								this.uploadurl += "&fdModelId="
										+ options.fdModelId;
						},

						// 生成唯一标示
						guid : (function() {
							var counter = 0;
							return function(prefix) {
								var guid = (+new Date().getTime()).toString(32), i = 0;
								for (; i < 5; i++) {
									guid += Math.floor(Math.random() * 65535)
											.toString(32);
								}
								return (prefix || 'mobile_') + guid
										+ (counter++).toString(32);
							};
						})(),

						FILE_EXT_PIC : "Picture Files|*.gif;*.jpg;*.jpeg;*.bmp;*.png;*.tif|All Files (*.*)|*.*",

						// 开始上传附件
						startUploadFile : function(file) {
							var ext = file.name.substring(file.name
									.lastIndexOf("."));
							if (this.FILE_EXT_PIC.indexOf(ext) < 0
									&& file.type.indexOf('image') < 0)
								return;

							if (file._fdId == null || file._fdId == '') {
								file._fdId = this.guid();
							}
							file.status = 1;
							// 渲染开始展示
							this.uploadStart(file, {});
							// 上传文件
							this._uploadFile(file);
						},

						_uploadFile : function(file, userKey) {
							// 子类各自实现
						},

						uploadStart : function(file, context) {
							topic.publish(this.UPLOAD_EVENT_START, this, lang
									.mixin(context, {
										file : file
									}));
						},

						uploadSuccess : function(file, context) {
							topic.publish(this.UPLOAD_EVENT_SUCCESS, this, lang
									.mixin(context, {
										file : file
									}));
						},

						uploadError : function(file, context) {
							topic.publish(this.UPLOAD_EVENT_FAIL, this, lang
									.mixin(context, {
										file : file
									}));
						},

						uploadProcess : function(loaded, file) {
							topic.publish(this.UPLOAD_EVENT_PROCESS, this, {
								file : file,
								loaded : loaded
							});
						},

						destroy : function() {
							this.inherited(arguments);
						}
					});
		});

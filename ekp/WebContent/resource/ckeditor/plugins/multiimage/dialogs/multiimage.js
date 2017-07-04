CKEDITOR.dialog
		.add(
				'multiimage',
				function(editor) {
					var config = editor.config;
					var dialog;
					// 内容
					var html = [];
					html.push('<section class="lui-attachment-upload ">');
					html.push('<article>');
					html.push('<section class="img" style="width: 100%">');
					html.push('<ul id="attachment_thumb" class="clearfloat">');
					html
							.push('<li data-lui-type="upload" class="lui-attachment-upload-btn">');
					// 上传按钮
					html.push('<div class="uploadBtn">');
					html
							.push('<div><input type="file" name="NewFile" id="imgUpload" accept="image/*" multiple="multiple"></div>');

					html.push('</div>');
					html.push('</li>');
					html.push('</ul>');
					html.push('<div id="attachment_tip">');
					html.push('</div>');
					html.push('</section>');
					html.push('</article>');
					html.push('</section>');

					var multiimageSelector = {
						type : 'html',
						id : 'multiimageSelector',
						html : html.join(''),
						onLoad : function(event) {
							dialog = event.sender;
						},
						style : 'width: 100%; border-collapse: separate;'
					};

					return {
						title : '多图片上传',
						minWidth : 735,
						minHeight : 120,
						contents : [ {
							id : 'tab1',
							label : '',
							title : '',
							expand : true,
							padding : 0,
							elements : [ multiimageSelector ]
						} ],

						// 确定后插入到编辑器中
						onOk : function() {
							if (this.upload.lock)
								return false;
							var fileList = this.upload.fileList;
							for (var i = 0; i < fileList.length; i++) {
								var src = fileList[i]['url'];
								var img = editor.document.createElement('img',
										{
											attributes : {
												src : src,
												'data-cke-saved-src' : src
											}
										});
								editor.insertElement(img);
							}
						},

						// 重置附件内容
						onShow : function() {
							if (!this.loaded) {
								// 弹出框底部
								var footer = dialog.parts.footer.$;
								var msg = '图片尺寸：小于'
										+ (config.imageMaxSize ? config.imageMaxSize
												: 5) + 'MB，';
								$(footer)
										.append(
												$('<div class="lui-attachment-limit-msg">'
														+ msg
														+ '可用扩展名：'
														+ CKconfig.ImageUploadAllowedExtensions
														+ '</div>'));
								this.loaded = true;
							}
							this.upload.reset();
						},

						onLoad : function() {
							this.upload = new MultiUpload(config
									.getFilebrowserImageUploadUrl(editor),
									"imgUpload", config.downloadUrl,
									config.imageMaxSize);
							this.upload.show();
							var self = this;
							this.upload.reset = function() {
								self.upload.fileList = [];
								$('[data-lui-type="upload"]').prevAll()
										.remove();
								$('[data-lui-type="upload"]').addClass(
										config.initClass);
							};
						}
					};
				});

function MultiUpload(uploadurl, btnId, downloadurl, imageMaxSize) {
	var self = this;
	this.uploadurl = uploadurl;
	this.downloadurl = downloadurl;
	this.showed = false;
	this.tempUrl = Com_Parameter.ContextPath
			+ "resource/ckeditor/plugins/multiimage/dialogs/style/images/bj.png";
	this.imageMaxSize = imageMaxSize;
	// 初始化上传功能
	this.show = function() {
		if (self.showed)
			return;
		setTimeout(function() {
			self.draw();
			self.showed = true;
		}, 1);
	};

	// 绘画并初始化flash
	this.draw = function() {
		self.bindEvent();
		self.swfupload = new SWFUpload(self.setting);
		self.swfupload.loadFlash();
	};

	this.bindEvent = function() {
		$('#attachment_thumb').on('click', function(evt) {
			var target = evt.target;
			if (target && target.parentNode) {
				var $parent = $(target.parentNode);
				if ($parent.hasClass('lui-attachment-image')) {
					var selectedClass = "lui-attachment-image-selected";
					$('.lui-attachment-image').removeClass(selectedClass)
					$parent.addClass(selectedClass);
				}
			}
		});
	};

	this.getHost = function() {
		var host = location.protocol.toLowerCase() + "//" + location.hostname;
		if (location.port != '' && location.port != '80') {
			host = host + ":" + location.port;
		}
		return host;
	}

	this.initial = function() {
	};

	// 上传队列
	this.fileQueued = function(file) {
		self.addDoc(file);
	};

	this.fileQueueError = function(file, errorCode, message) {
		// windows系统下超过限制此错误会触发
		switch (errorCode) {
		case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT:
			self.__uploadFail(file, {
				status : '0'
			});
			break;
		}
	};

	this.fileDialogComplete = function() {
	};

	// 渲染默认图片
	this.__uploadStart = function(file) {
	};

	// 转圈圈
	this.__uploadProgress = function(file, loaded, total) {
		var id = file.id;
		var rate = loaded / total, className = '';
		if (rate >= 0.9)
			className = 'lui_attachment_rate9';
		else if (rate >= 0.8)
			className = 'lui_attachment_rate8';
		else if (rate >= 0.7)
			className = 'lui_attachment_rate7';
		else if (rate >= 0.6)
			className = 'lui_attachment_rate6';
		else if (rate >= 0.5)
			className = 'lui_attachment_rate5';
		else if (rate >= 0.4)
			className = 'lui_attachment_rate4';
		else if (rate >= 0.3)
			className = 'lui_attachment_rate3';
		else if (rate >= 0.2)
			className = 'lui_attachment_rate2';
		else
			return;
		$('#' + id).next().attr('class', className);
	};

	this.__uploadError = function() {
	};

	this.fileList = [];

	// 删除文档
	this.delDoc = function(id) {
		var fileList = self.fileList;
		for (var i = 0; i < fileList.length; i++) {
			if (fileList[i].id == id)
				fileList.splice(i, 1);
		}
	};

	// 根据id获取对应的附件信息
	this.getFileById = function(id) {
		var fileList = self.fileList;
		for (var i = 0; i < fileList.length; i++) {
			if (fileList[i].id == id)
				return fileList[i];
		}
	};

	this.buildImage = function(url, id) {
		var $rate = $('<div class="lui_attachment_rate1">');
		var $img = $('<img>').attr('src', url).attr('id', id), $li = $('<li class="lui-attachment-image"/>'), $i = $(
				'<i data-lui-id="' + id + '"/>').on('click', function(evt) {
			var $target = $(evt.target);
			var id = $target.attr('data-lui-id');
			self.delDoc(id);
			$target.parent().remove();
		});
		return $li.append($img).append($rate).append($i);
	};

	// 上传成功后构建图片缩略图
	this.__uploadSuccess = function(file, serverData) {

		var data = (new Function("return (" + serverData + ");"))();
		if (data.status != '1') {
			self.__uploadFail(file, data);
			return;
		}
		var url = self.downloadurl + '?fdId=' + data.filekey;
		var fileId = file.id;
		$('#' + fileId).attr('src', url);
		$('#' + fileId).next().remove();
		self.fileList.push({
			id : fileId,
			url : url
		});
	};

	// 显示提示信息
	this.showTip = function(text) {
		if (self.isShowTip)
			return;
		self.isShowTip = true;
		var html = '<div class="lui-attachment-tip">';
		html += '<div class="lui-attachment-tip-r">';
		html += '<div class="lui-attachment-tip-c">';
		html += '<span class="lui-attachment-tip-text">' + text + '</span>';
		html += '</div></div></div>';
		var $html = $(html);
		$('#attachment_tip').append($html);
		setTimeout(function() {
			$html.animate({
				opacity : 0
			}, 500, function() {
				$html.remove();
				self.isShowTip = false;
			});
		}, 3000);
	};

	this.__uploadFail = function(file, data) {
		var fileId = file.id;
		$('#' + fileId).parents('.lui-attachment-image').remove();
		if (data.status == '0')
			self.showTip('部分图片附件超过系统设定大小限制，已经移除');
		if (data.status == '3')
			self.showTip('部分图片附件上传报错，已经移除');
		if (data.status == '4')
			self.showTip('图片上传配置错误，请联系管理员');
	}

	this.uploadComplete = function() {
		self._start_();
	};

	this._start_ = function() {
		var stats = self.swfupload.getStats();
		if (stats.files_queued > 0)
			self.swfupload.startUpload();
		else
			self.lock = false;
	};

	// 上传图片
	this.addDoc = function(file) {
		if (!self.lock)
			self.lock = true;
		var img = self.buildImage(self.tempUrl, file.id);
		$('[data-lui-type="upload"]').before(img);
		self._start_();
	};
	// 相关设置信息
	this.setting = {
		file_types : CKconfig.ImageUploadAllowedExtensions,
		flash_url : self.getHost() + Com_Parameter.ContextPath
				+ "sys/attachment/swf/swfupload.swf",
		upload_url : self.uploadurl + '&json=true',
		file_size_limit : self.imageMaxSize + " MB",
		file_upload_limit : 0,
		file_queue_limit : 0,
		debug : false,
		button_image_url : Com_Parameter.ResPath
				+ "ckeditor/plugins/multiimage/dialogs/style/images/add.png",
		button_placeholder_id : btnId,
		button_text : "",
		button_text_style : "",
		button_text_left_padding : 0,
		button_text_top_padding : 0,
		button_cursor : SWFUpload.CURSOR.HAND,
		button_window_mode : SWFUpload.WINDOW_MODE.TRANSPARENT,

		button_width : '98px',
		button_height : '98px',

		swfupload_loaded_handler : self.initial,
		file_queued_handler : self.fileQueued,
		file_queue_error_handler : self.fileQueueError,
		file_dialog_complete_handler : self.fileDialogComplete,
		upload_start_handler : self.__uploadStart,
		upload_progress_handler : self.__uploadProgress,
		upload_error_handler : self.__uploadError,
		upload_success_handler : self.__uploadSuccess,
		upload_complete_handler : self.uploadComplete
	};

};

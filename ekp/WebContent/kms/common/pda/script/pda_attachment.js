~~function(win) {
	Pda.Base.Widget.register('attachment');
	Pda.Attachment = Pda.Base.EventClass.extend({

		role : 'attachment',

		init : function(options) {
			this._super(options);
			// 上传url
			this.uploadUrl = options.url || Com_Parameter.ContextPath
					+ 'sys/attachment/uploaderServlet?gettype=upload';
			// 获取tokenUrl
			this.tokenUrl = Com_Parameter.ContextPath
					+ 'sys/attachment/sys_att_main/sysAttMain.do?method=handleAttUpload&gettype=getuserkey';

			// 获取附件id
			this.attachUrl = Com_Parameter.ContextPath
					+ 'sys/attachment/sys_att_main/sysAttMain.do?method=handleAttUpload&gettype=submit';

			// 下载路径
			this.downloadUrl = Com_Parameter.ContextPath
					+ "sys/attachment/sys_att_main/sysAttMain.do?method=download";
			// 缩略图位置
			this.thumb = $(options.thumb);

			// 附件信息
			this.info = $('#attachment_info');

			this.fdKey = options.fdKey;
			this.fdModelName = options.fdModelName;
			this.fdModelId = options.fdModelId;
			this.fdAttType = options.fdAttType;
			this.target = options.target;

			this.extParam = options.extParam;

			this.FILE_EXT_PIC = "Picture Files|*.gif;*.jpg;*.jpeg;*.bmp;*.png;*.tif|All Files (*.*)|*.*";
			this.File_EXT_VIDEO = ".flv;.mp4;.f4v;.mp4;.m3u8;.webm;.ogg;.theora;.mp4;.avi;.mpg;.wmv;.3gp;.mov;.asf;.asx;.wmv9;.rm;.rmvb;.wrf";
			this.file = {}
			// 附件数组
			this.fileList = [];
			this.index = -1;
		},

		// 获取文件后缀名
		getFileExt : function(file) {
			return file.fileName.substring(file.fileName.lastIndexOf("."));
		},

		getFileById : function(id) {
			for (var i = 0; i < this.fileList.length; i++) {
				if (this.fileList[i].fdId == id)
					return this.fileList[i];
			}
		},

		startup : function() {
			this.on('uploadLoaded', this.uploadLoaded.bind(this));
			this.on('renderLoaded', this.renderLoaded.bind(this));
			this.on('queque', this.quequeUpload.bind(this));
			this.on('deleteFile', this.deleteRender.bind(this));
			Pda.Topic.on('submit', this.updateInput.bind(this));
			Com_Parameter.event["submit"].push(function() {
						Pda.Topic.emit('submit');
						return true;
					});
		},

		// 队列上传
		quequeUpload : function(evt) {
			this.ajaxUpload(this.files[this.__index__]);
		},

		// 异步提交附件流
		ajaxUpload : function(file) {
			this.buildInfo();
			var token = this.ajaxToken(file);
			if (token.status.trim() != "1")
				return;
			var d = new FormData;
			d.append("userkey", token.userkey);
			d.append("NewFile", file);
			if (this.extParam)
				d.append("extParam", this.extParam);
			this.ajax(this.uploadUrl, d, this.load.bind(this), this.error
							.bind(this), this.process.bind(this), true, true);
		},

		// 上传完毕后构建视图
		renderLoaded : function(evt) {
			this.buildThumb();
		},

		isImage : function(file) {
			return this.FILE_EXT_PIC.indexOf(file.ext) >= 0
					|| file.fileName.indexOf('image') >= 0;
		},

		// 构建缩略图
		buildThumb : function() {
			var file = this.fileList[this.index];
			var $li = $('<li>'), $i = $('<i data-lui-id="' + file.fdId + '">');
			$i.on('click', this.deleteFile.bind(this));
			var $img = $('<img width="100%" height="100%">')
			// 图片类型才请求缩略图
			if (this.isImage(file))
				$img.attr('src', this.downloadUrl + '&fdId=' + file.fdId);
			else
				$img
						.attr(
								'src',
								Com_Parameter.ContextPath
										+ 'resource/style/default/attachment/default.png');
			$li.append($img).append($i);
			this.thumb.append($li);
		},

		// 构建附件信息
		buildInfo : function() {
			var file = this.fileList[this.index];
			var $dd = $('<dd data-lui-index="' + this.index + '">'), $i = $('<i/>'), $span = $('<span>')
					.html(file.fileName);
			if (this.FILE_EXT_PIC.indexOf(file.ext) > 0)
				$i.addClass('icon-img');
			else
				$i.addClass('icon-other');
			$dd.append($i).append($span);
			this.processDiv = $('<div class="processDiv" />');
			this.processBar = $('<div class="process" />'), this.loadedBar = $('<span>'), this.loadedPercent = $('<span>');
			this.processDiv.append(this.processBar.append(this.loadedBar))
					.append(this.loadedPercent);
			$dd.append(this.processDiv);
			this.info.append($dd);
		},

		// 重置进度
		resetProcess : function(percent) {
			if (!this.loadedBar)
				return;
			var p = percent + '%';
			this.loadedBar.css('width', p);
			this.loadedPercent.html(p);
			if (percent === 100) {
				this.processDiv.remove();
				this.loadedBar = null;
				this.loadedPercent = null;
				this.processBar = null;
				this.processDiv = null;
			}
		},

		// 更新隐藏域中的值
		updateInput : function() {
			var attIds = document.getElementsByName("attachmentForms."
					+ this.fdKey + ".attachmentIds");
			if (attIds && attIds.length > 0) {
				var tempIds = "";
				var tempDelIds = "";
				for (var i = 0; i < this.fileList.length; i++) {
					var doc = this.fileList[i];
					if (doc.fileStatus == -1)
						tempDelIds += ";" + doc.fdId;
					else if (doc.fileStatus == 1)
						tempIds += ";" + doc.fdId;
				}
				if (tempIds.length > 0)
					tempIds = tempIds.substring(1, tempIds.length);
				if (tempDelIds.length > 0)
					tempDelIds = tempDelIds.substring(1, tempDelIds.length);
				attIds[0].value = tempIds;
				document.getElementsByName("attachmentForms." + this.fdKey
						+ ".deletedAttachmentIds")[0].value = tempDelIds;
				return true;
			}
			return false;
		},

		// 删除文件
		deleteFile : function(evt) {
			var $target = $(evt.target), fileId = $target.attr('data-lui-id');
			var file = this.getFileById(fileId);
			file.fileStatus = -1;
			this.emit({
						'type' : 'deleteFile',
						'file' : file
					});
		},

		// 删除相关展现
		deleteRender : function(evt) {
			var fdId = evt.file.fdId;
			// 删除缩略图
			var $i = this.thumb.find('[data-lui-id="' + fdId + '"]');
			$i.parent().remove();
			var index = evt.file.index;
			// 删除附件信息
			this.info.find('[data-lui-index="' + index + '"]').remove();
		},

		// 上传完毕之后重新渲染附件展示样式
		uploadLoaded : function(evt) {
			var rtn = evt.rtn;
			var xml = this.xmlparse(rtn);
			if (xml.status.trim() == '1') {
				var file = this.fileList[this.index]
				file.fileKey = xml.filekey;
				file.fileStatus = xml.status.trim();
				// 请求附件id
				this.getAttId();
				// 加载样子
				this.emit({
							'type' : 'renderLoaded',
							'file' : file
						});
				if (!this.hasNext())
					return;
				// 继续上传队列
				this.index++;
				this.__index__++;
				this.emit('queque');
			}
		},

		// 判断队列中是否还有内容
		hasNext : function() {
			if (this.index + 1 >= this.fileLength)
				return false;
			return true;
		},

		change : function(evt) {
			var self = this;
			var files = evt.target.files;
			self.files = files;
			self.__index__ = 0;
			self.index++;
			for (var i = 0; i < files.length; i++) {
				var file = {};
				var fileName = files[i].name;
				if (fileName.indexOf('.') < 0 && fileName.indexOf('image') >= 0)
					fileName += '.jpg';
				file.fileName = fileName;
				file.index = self.index + i;
				file.ext = this.getFileExt(file);
				file.size = files[i].size;
				self.fileList.push(file);
			}
			self.fileLength = self.fileList.length;
			if (files && files.length > 0)
				self.ajaxUpload(files[0]);

			// 对外通知，用于跳转翻页等
			Pda.Topic.emit('upload_change');
		},

		// 获取上传按钮
		getFileInput : function(id, accept, multiple, capture) {
			var $input = $('<input type="file" name="NewFile" id="' + id
					+ '" style="position:absolute;left:2000px" >');
			if (accept)
				$input.attr('accept', accept);
			if (multiple)
				$input.attr('multiple', 'multiple');
			if (capture)
				$input.attr('capture', capture);
			$input.on('change', this.change.bind(this));
			return $input;
		},

		// 获取附件id
		getAttId : function() {
			var file = this.fileList[this.index];
			var xdata = "filekey=" + file.fileKey + "&filename="
					+ encodeURIComponent(file.fileName) + "&fdKey="
					+ this.fdKey + "&fdModelName=" + this.fdModelName
					+ "&fdModelId=" + this.fdModelId;
			var result = this.ajax(this.attachUrl, xdata);
			var val = this.xmlparse(result.responseText);
			if (val.status.trim() == "1") {
				file.fdId = val.attid;
				return val.attid;
			}
		},

		// 获取token
		ajaxToken : function(file) {
			var xdata = "filesize=" + file.size + "&md5=";
			var xmlhttp = this.ajax(this.tokenUrl, xdata, new Function(),
					new Function(), false);
			return this.xmlparse(xmlhttp.responseText.trim());
		},

		// 解析获取xml中return节点中的内容
		xmlparse : function(xmlContent) {
			// 转换为jsxml对象
			var xml = document.implementation.createDocument("", "", null);
			var dp = new DOMParser();
			var newDOM = dp.parseFromString(xmlContent, "text/xml");
			var newElt = xml.importNode(newDOM.documentElement, true);
			xml.appendChild(newElt);
			var ret = this.getNodesByPath(xml, "/return")[0].childNodes, val = {};
			for (i = 0; i < ret.length; i++) {
				if (ret[i].nodeType == 1) {
					val[ret[i].nodeName] = ret[i].firstChild.nodeValue;
				}
			}
			return val;
		},

		getNodesByPath : function(xmlNode, path) {
			if (window.XPathEvaluator) {
				try {
					var xpe = new XPathEvaluator();
					var nsResolver = xpe
							.createNSResolver(xmlNode.ownerDocument == null
									? xmlNode.documentElement
									: xmlNode.ownerDocument.documentElement);
					var result = xpe.evaluate(path, xmlNode, nsResolver, 0,
							null);
					var found = [];
					var res;
					while (res = result.iterateNext())
						found.push(res);
					return found;
				} catch (e) {
					if (xmlNode.querySelectorAll) {
						path = path.replace(/\//gi, " ");
						return xmlNode.querySelectorAll(path);
					}
					throw e;
				}
			} else if ("selectNodes" in xmlNode) {
				return xmlNode.selectNodes(path);
			} else if (xmlNode.querySelectorAll) {
				path = path.replace(/\//gi, " ");
				return xmlNode.querySelectorAll(path);
			}
		},

		load : function(e) {
			this.emit({
						'type' : 'uploadLoaded',
						'rtn' : e.target.responseText
					});
		},

		error : function() {

		},

		// 上传进度
		process : function(e) {
			if (e.lengthComputable) {
				this.loaded = e.loaded;
				this.total = e.total;
				// 已上传比例
				var percent = Math.round(this.loaded * 100 / this.total);
				// 重置进度
				this.resetProcess(percent);
			}
		},

		ajax : function(url, data, success, error, process, async, multi) {
			var xmlhttp = new XMLHttpRequest();
			xmlhttp.addEventListener('load', success, false);
			xmlhttp.addEventListener('error', error, false);
			xmlhttp.open("POST", url, async);
			// 区分提交表单还是多媒体文件
			if (!multi)
				xmlhttp.setRequestHeader("Content-Type",
						"application/x-www-form-urlencoded;charset=UTF-8");
			else
				// 进度条
				xmlhttp.upload.addEventListener('progress', process, false);
			xmlhttp.send(data);
			return xmlhttp;
		},

		draw : function() {
			var $imgInput = this.getFileInput('imgUpload', 'image/*', true);
			var $cameraInput = this.getFileInput('cameraUpload', null, false,
					'camera');
			this.target.append($imgInput).append($cameraInput);
		}
	})
}(window);

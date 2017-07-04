Com_RegisterFile("swf_attachment.js");
Com_IncludeFile("jquery.js|xml.js");
Com_IncludeFile("swfupload.js|flashviewer.js|base64.js",Com_Parameter.ContextPath	+ "sys/attachment/js/","js",true);
Com_IncludeFile("fileIcon.js",Com_Parameter.ResPath + "style/common/fileIcon/","js",true);
Com_IncludeFile("upload.css",Com_Parameter.ContextPath	+ "sys/attachment/view/img/","css",true);
Com_IncludeFile("sysAttMain_MessageInfo.jsp?locale="+ Com_Parameter.__sysAttMainlocale__,Com_Parameter.ContextPath + "sys/attachment/sys_att_main/", 'js',true);
 
String.prototype.trim=function(){
     return this.replace(/(^\s*)(\s*$)/g, "");
};
if(typeof Attachment_SyncAjax_Cache  == "undefined")
	Attachment_SyncAjax_Cache = {};

if(typeof Attachment_ObjectInfo == "undefined")
	Attachment_ObjectInfo = new Array();

var FILE_EXT_OFFICE = "All Files (*.*)|*.*|Office Files|*.doc;*.xls;*.ppt;*.vsd;*.rtf;*.csv";
var FILE_EXT_PIC = "Picture Files|*.gif;*.jpg;*.jpeg;*.bmp;*.png;*.tif|All Files (*.*)|*.*";
var File_EXT_READ = ".doc;.xls;.mpp;.ppt;.xlc;.docx;.xlsx;.mppx;.pptx;.xlcx;.wps;.et;.vsd;.pdf";
var File_EXT_EDIT = ".doc;.xls;.mpp;.ppt;.xlc;.docx;.xlsx;.mppx;.pptx;.xlcx;.wps;.et;.vsd";
var File_EXT_VIDEO = ".flv;.mp4;.f4v;.mp4;.m3u8;.webm;.ogg;.theora;.mp4;.avi;.mpg;.wmv;.3gp;.mov;.asf;.asx;.wmv9;.rm;.rmvb;.wrf" ;
var File_EXT_MP3 = ".mp3" ;
/*************************************
 * 附件对象，用于附件机制上传和下载
*************************************/
function Swf_AttachmentObject(_fdKey, _fdModelName, _fdModelId, _fdMulti, _fdAttType, _editMode , _fdSupportLarge,enabledFileType) {
	var self = this;
    this.eventsCache = {};
	//还未弄明白的属性
	this.fdShowMsg = true;
	this.showDefault = null;
	this.buttonDiv = null;
	this.isTemplate = null;
	this.enabledFileType = enabledFileType;
	this.showRevisions = null;
	
	//附件额外功能支持
	this.uploadAfterSelect = false; //附件上传时,是否选择附件后就马上产生附件文档。
	this.uploadAfterCustom = window.onFinishPostCustom?window.onFinishPostCustom:null;  
									//和uploadAfterSelect配合使用，单个附件上传后，如果立即产生附件文档，执行此函数，参数: 当前文档
									//兼容旧接口window.onFinishPostCustom。
	this.onFinishPostCustom = null; //附件上传时,上传后，文档提交时，额外的信息处理,参数：当前的附件列表。
	this.onClickCustom = null;  	//附件展现时,附件点击后，自定义点击事件函数,参数: 当前附件; 返回值 继续true 中断false。
	this.showCustomMenu = null; 	//附件展现时,附件点击后，自定义右键菜单展现,参数：当前menu。
	this.drawFunction = null;		//附件上传或展现，用于绘制附件的列表展现界面,参数：当前附件对象
	
	this.showAfterCustom = null;// 附件绘画完毕后执行方法
	
	//图片类型附件属性
	this.fdImgHtmlProperty = null;
	this.width = null;
	this.height = null;
	//是否按比例压缩
	this.proportion = true;
	//是否必填
	this.required = false; 
	/**
	 * 强制不允许使用的操作，
	 * edit，open，read，print，download，copy，可多值用";"分隔，如不允许编辑和下载:"edit;download".
	 * 默认按文档权限显示对应操作
	 */
	this.forceDisabledOpt = null;
	
	//只是用于在线编辑的时候
	this.actionObj = null;
	
	//附件基本属性定义
	this.fdKey = _fdKey; 				// 附件的标识
	this.fdModelName = _fdModelName; 	// 对应域模型
	this.fdModelId = _fdModelId; 		// 主文档ID
	if(_fdMulti==null || _fdMulti=="" || _fdMulti=="true" || _fdMulti=="1") 
		this.fdMulti = true;
	else 
		this.fdMulti = false;			//是否允许多附件
	this.fdAttType = (_fdAttType==null||_fdAttType=="")?"byte":_fdAttType; 		
										//附件类型 office,pic,byte
	this.fdViewType = this.fdAttType; 	//附件显示样式 office,pic,link
	this.setFdViewType = function(_fdViewType){
		self.fdViewType = _fdViewType;		
		if (_fdViewType.substring(0, 1) == '/') {
			self.renderurl=Com_Parameter.ContextPath+_fdViewType.substring(1);
		} else {
			self.renderurl=Com_Parameter.ContextPath+"sys/attachment/view/render_"+_fdViewType+".js";
		}
	}
	this.fdLayoutType = 'new';
	this.setFdLayoutType = function(___fdLayoutType) {
		self.fdLayoutType = ___fdLayoutType;
		self.layouturl = Com_Parameter.ContextPath + "sys/attachment/view/layout_"+___fdLayoutType+".js";
	}
	//大附件使用属性
	this.fdSupportLarge = _fdSupportLarge;	//是否支持大附件
	this.fdBigAttUploaded = true;			//大附件是否上传完
	this.bigAttFrameObj = null;  			//大附件弹出框对象
	

	this.isSwfEnabled = false; 	//是否开启Filsh阅读附件
	
	// 编辑模式，修改或查看，若参数未提供则尝试去URL里面取。
	if (_editMode == null)
		this.editMode = Com_GetUrlParameter(location.href, "method");
	else
		this.editMode = _editMode;
	
	// 附件权限属性定义
	if (this.editMode == "edit" || this.editMode == "add") {
		this.canDelete = true;
		this.canRead = true;
		this.canDownload = true;
		this.canEdit = true;
		this.canPrint = true;
		this.canAdd = true;
	} else {
		this.canDelete = false;
		this.canRead = true;
		this.canDownload = false;
		this.canEdit = false;
		this.canPrint = false;
		this.canAdd = false;
	}	
	
	Attachment_ObjectInfo[this.fdKey] = this;       //记录全局附件对象列表
	this.jsname = "attachmentObject_" + this.fdKey; //当前附件对象js变量名
	
	//单文件最大限制
	this.singleMaxSizeTxt = null;
	this.singleMaxSize = 10;
	
	//所有文件最大限制
	this.totalMaxSizeTxt = null;
	this.totalMaxSize = 10;
	this.smallMaxSizeLimit = 100;           //附件定义最大大小

	//swfupload小附件使用变量
	this.btnIntial = false;
	this.renderId = "attachmentObject_" + this.fdKey + "_content_div";  //附件列表显示html区域ID
    this.tokenurl = Com_Parameter.ContextPath + "sys/attachment/sys_att_main/sysAttMain.do?method=handleAttUpload&gettype=getuserkey";
    this.attachurl = Com_Parameter.ContextPath + "sys/attachment/sys_att_main/sysAttMain.do?method=handleAttUpload&gettype=submit";
    this.uploadurl = Com_Parameter.ContextPath + "sys/attachment/uploaderServlet?gettype=upload";
    this.layouturl = Com_Parameter.ContextPath + "sys/attachment/view/layout_"+this.fdLayoutType+".js";
    this.renderurl = Com_Parameter.ContextPath + "sys/attachment/view/render_"+this.fdViewType+".js";
	//文件列表数组，数组对象
	this.fileList = [];
	
	/****************************************
	功能：格式化大小
	参数：maxSize 大小
	****************************************/
	this.parseSize = function(maxSize){
		var result = 0;
		if(maxSize!=null && maxSize!="") {
			maxSize = maxSize.toLowerCase();
			var lastC = maxSize.charAt(maxSize.length-1);
			if(lastC=="g") {
				maxSize = maxSize.substring(0,maxSize.length-1);
				result = parseInt(maxSize)*1024*1024*1024;			
			}else if(lastC=="m") {
				maxSize = maxSize.substring(0,maxSize.length-1);
				result = parseInt(maxSize)*1024*1024;
			}else if(lastC=="b") {
				if(maxSize.charAt(maxSize.length-2)=="k") {
					maxSize = maxSize.substring(0,maxSize.length-2);
					result = parseInt(maxSize)*1000;
				}else {
					maxSize = maxSize.substring(0,maxSize.length-1);
					result = parseInt(maxSize);
				}
			}else result = parseInt(maxSize);			
		}
		return result;
	};
	/***************************************
	功能：设置单个附件大小控制
	参数：maxSize 大小
	****************************************/
	this.setSingleMaxSize = function(maxSize){
		self.singleMaxSizeTxt = maxSize;
		self.singleMaxSize = self.parseSize(maxSize);
	};
	/*****************************************
	功能：设置总体附件大小控制
	参数：maxSize 大小
	******************************************/
	this.setTotalMaxSize = function(maxSize){
		self.totalMaxSizeTxt = maxSize;
		self.totalMaxSize = self.parseSize(maxSize);
	}; 	
	/*****************************************
	 * 功能：设置普通附件大小
	 * 参数：size 大小 单位兆
	 ****************************************/
	this.setSmallMaxSizeLimit = function(size) {
		self.smallMaxSizeLimit = size;
		var __size = parseFloat(size);
		// 修复参数为小数时限制无效的问题
		if (__size < 1) {
			__size = __size * 1024 * 1024;
			self.swf_settings.file_size_limit = __size + " B";
		} else
			self.swf_settings.file_size_limit = self.smallMaxSizeLimit + " MB";
	};
	/*****************************************
	功能：重新计算权限信息
	*****************************************/
	this.recalcRightInfo = function(){
		if(self.forceDisabledOpt!=null && self.forceDisabledOpt){
			var features = self.forceDisabledOpt.split(";");
			for ( var i = 0; i < features.length; i++) {
				var tmpFeature = features[i];
				tmpFeature = "can" + tmpFeature.substring(0,1).toUpperCase() + tmpFeature.substring(1);
				self[tmpFeature] = false;
			}
		}
	};
	/*****************************************
	功能：显示附件内容方法
	参数：显示位置Dom元素ID
	*****************************************/
	this.show = function() {
		if(self.showed)
			return;
		if(self.recalcRightInfo){
			self.recalcRightInfo();
		}
		if(!self.btnIntial)
			self.showButton();
		if(self.drawFunction != null){
			self.drawFunction(self);
		}else{
			if(self.renderFn == null){		 	
			 	 var result = self.ajax(self.renderurl , null , true); 
				 self.renderFn = new Function('$','done',result);
			 }
			 try{			 	
			 self.renderFn.apply(self, [$, function(dom) {
							var rlist;
								rlist = $("#" + self.renderId)
										.find("[data-lui-mark='attachmentlist']");
							rlist.empty();
							rlist.append(dom);
							self.showed = true;
						}]);
			 }catch(e){
			 	window.console && window.console.error(e.stack)
			 }
		}
		if(self.showAfterCustom){
			self.showAfterCustom();
		}
	};
	/*****************************************
	 * 功能：编辑模式的时候更新隐藏域里面的附件Id和删除的附件ID
	 ******************************************/
	this.updateInput = function() {
		var attIds = document.getElementsByName("attachmentForms." + self.fdKey + ".attachmentIds");
		if (attIds && attIds.length > 0) {
			var tempIds = "";
			var tempDelIds = "";
			for ( var i = 0; i < self.fileList.length; i++) {
				var doc = self.fileList[i];
				if (doc.fileStatus == -1) {
					if(doc.fdId.indexOf("SWFUpload") >=0){
					}else{
						tempDelIds += ";" + doc.fdId;
					}
				} else if(doc.fileStatus == 1) {
					if((self.fdAttType!="pic" || self.uploadAfterSelect==false )&& doc.fdId.indexOf("SWFUpload") >=0){
						doc.fdId = self.createAttMainInfo(doc);
					}
					tempIds += ";" + doc.fdId;
					if(doc.fdId=='' || doc.fdId==null){
						alert(doc.fileName + Attachment_MessageInfo["msg.uploadFail"]);
						return false;
					}
				}
			}
			if (tempIds.length > 0) {
				if(self.onFinishPostCustom){
					self.onFinishPostCustom(self.fileList);
				} 
				tempIds = tempIds.substring(1, tempIds.length);
			}
			if (tempDelIds.length > 0) {
				tempDelIds = tempDelIds.substring(1, tempDelIds.length);
			}
			attIds[0].value = tempIds;
			document.getElementsByName("attachmentForms." + self.fdKey + ".deletedAttachmentIds")[0].value = tempDelIds;
			return true;
		}
	};
	/*****************************************
	 * 功能：添加附件信息方法
	 * 参数：
	 *_fileName 文件名称
	 *_fileType 文件类型
     *_fileKey 附件中对应文件ID
	 *_fdId 附件fdId
	 *_fileSize 文件大小
	 *_isUpload 是否已上传   存到文件状态fileStatus中  1表示正常状态，-1表示删除,0表示未上传
	 *localFile 暂未使用，本地文件路径，可以在选择文件后IE时临时显示图片用
	 ******************************************/
	this.addDoc = function(_fileName, _fdId, _isUpload, _fileType, _fileSize, _fileKey) {
		if(_fileName.indexOf("base64:")==0){
			var unicode = _fileName.substring(7);
			unicode = BASE64.decoder(unicode);
			_fileName="";
			for(var i = 0 ; i<unicode.length ; i++){  
				_fileName += String.fromCharCode(unicode[i]);  
			}
		}
		var att = {};
		att.fdId = _fdId;
		if(_isUpload) {   //大附件使用及已上传的附件展示时使用。
			att.fileStatus = 1;
			att.fileName = _fileName;
		}else{
			var i= _fileName.lastIndexOf("\\");
			if(i>0) {
				att.fileName = _fileName.substring(i+1);
				att.localFile = _fileName;
			}else {
				att.fileName = _fileName;
				att.localFile = _fileName;			
			}
			att.fileStatus = 0;
		}
		att.fileKey = _fileKey;
		att.fileType = _fileType;
		att.fileSize = _fileSize;
		self.fileList[self.fileList.length] = att;
		//self.uploadCreate(att);
		self.emit("uploadCreate",{"file":att});
		if(att.fileStatus == 0){
			self._start_();
		}
	}; 
	/*******************************************
	 * 功能：在fileList中根据docId查找文档对象
	 * 参数：附件id
	 ******************************************/
	this.getDoc = function(docId) {
		for (i = 0; i < self.fileList.length; i++) {
			if (self.fileList[i].fdId == docId) {
				return self.fileList[i];
			}
		}
		return null;
	};
	/*******************************************
	 * 功能：增加支持阅读的文件后缀
	 ******************************************/
	this.appendReadFile =function(extensions) {
		if (File_EXT_READ.indexOf(extensions) == -1) {
	             File_EXT_READ+=";."+extensions;
		}
	};
	/****************************************
	 * 功能：重置支持阅读的文件后缀
	 ***************************************/
	this.resetReadFile =function(extensions) {
		File_EXT_READ = extensions;
	};
	
	/****************************************
	 * 右键菜单中的阅读菜单
	 ***************************************/
	this.readDoc = function(docId) {
		var doc = self.getDoc(docId);
		var url = self.getUrl("view", docId);
		if(self.isSwfEnabled){
			attachmentDocShow(doc.fileName,url,docId);
		}else{
			Com_OpenWindow(url, "_blank", "width=800,height=600,top=0,left=0,resizable=yes,scrollbars=yes");
		}
	};
	/****************************************
	 * 右键菜单中的播放菜单
	 ***************************************/
	this.startVideo = function(docId) {
		document.getElementById("mainFrame").src="kmsMultimediaMain_video.jsp?attId="+docId+"&fdModelId="+self.fdModelId;
	};
	/****************************************
	 * 右键菜单中的播放菜单
	 ***************************************/
	this.startMp3 = function(docId) {
		document.getElementById("mainFrame").src="kmsMultimediaMain_mp3.jsp?attId="+docId;
	};
	/****************************************
	 * 右键菜单中的编辑菜单
	 ***************************************/
	this.editDoc = function(docId) {
		var url = self.getUrl("edit", docId);
		Com_OpenWindow(url, "_blank", "width=800,height=600,top=0,left=0,resizable=yes,scrollbars=yes");
	};
	/****************************************
	 * 右键中的打印菜单
	 ***************************************/
	this.printDoc = function(docId) {
		var url = self.getUrl("print", docId);
		Com_OpenWindow(url, "_blank", "width=800,height=600,top=0,left=0,resizable=yes,scrollbars=yes");
	};
	/****************************************
	 * 右键中的下载菜单
	 ***************************************/
	this.downDoc = function(docId) {
		var url = self.getUrl("download", docId);
		window.open(url, "_blank");
	};
	/****************************************
	 * 右键中的删除菜单
	 ***************************************/
	this.delDoc = function(docId,_refresh) {
		for (i = 0; i < self.fileList.length; i++) {
			if (self.fileList[i].fdId == docId) {
				self.fileList[i].fileStatus = -1;
			}
		}
		if(_refresh == null){
			self.show();
		}else if(_refresh){
			self.show();
		}
	};
	/****************************************
	 * 右键中的打开菜单
	 ***************************************/
	this.openDoc = function(docId) {
		var url = self.getUrl("readDownload", docId);
		url = Com_SetUrlParameter(url,"open","1");
		Com_OpenWindow(url, "_blank", "width=800,height=600,top=0,left=0,resizable=yes,scrollbars=yes");
	};
	/****************************************
	 * 批量删除
	 ***************************************/
	this.deleteFiles = function() {
		var checkBox = document.getElementsByName("attach_" + self.fdKey
				+ "_checkbox");
		if (checkBox != null) {
			var alertFlag = true;
			for (var i = 0; i < checkBox.length; i++) {
				if(checkBox[i].checked){
					alertFlag=false;
					break;
				}
			}
			if(alertFlag){
				alert(Attachment_MessageInfo["msg.deleteNoChoice"]);
				return;
			}
			for (var i = 0; i < checkBox.length; i++) {
				if (checkBox[i].checked) {
					var fileId = checkBox[i].value;
					self.delDoc(fileId, false);
					setTimeout(function() {
								var process = document.getElementById(fileId
										+ "_progress");
								if (process != null)
									process.style.display = "none";
							}, 1000);
				}
			}
		}
		self.show();
	};
	/****************************************
	 * 批量下载
	 ***************************************/
	this.downloadFiiles = function(){
		var docIds = "";
		var checkBox =  document.getElementsByName("attach_"+self.fdKey+"_checkbox");
		if(checkBox!=null) { 
			for(var i=0;i<checkBox.length;i++) {
				if(checkBox[i].checked){
					docIds += ";" + checkBox[i].value;
				}
			} 
		}
		if(docIds.length <= 0){
			alert(Attachment_MessageInfo["msg.noChoice"]);
		}else{
			docIds = docIds.substring(1, docIds.length);
			var url = self.getUrl("download", docIds);
			window.open(url, "_blank");
		}
	};
	/****************************************
	 * 获取域名
	 ***************************************/
	this.getHost = function(){
		var host = location.protocol.toLowerCase()+"//" + location.hostname;
		if(location.port!='' && location.port!='80'){
			host = host+ ":" + location.port;
		}
		return host;
	}
	/****************************************
	 * 功能函数，获取URL地址，传入参数method和文档fdId
	 ***************************************/
	this.getUrl = function(method, docId) {
		return self.getHost() + Com_Parameter.ContextPath
				+ "sys/attachment/sys_att_main/sysAttMain.do?method=" + method
				+ "&fdId=" + docId;
	};
	/****************************************
	 * 功能函数，格式化文件大小的显示，以MB，B，G等单位结尾
	 ***************************************/
	this.formatSize = function(filesize) {
		var result = "";
		var index;
		filesize = new String(filesize);
		if (filesize != null && filesize != "") {
			if ((index = filesize.indexOf("E")) > 0) {
				var size = parseFloat(filesize.substring(0, index))
						* Math.pow(10, parseInt(filesize.substring(index + 1)));
			} else
				var size = parseInt(filesize);
			if (size < 1024)
				result = size + "B";
			else {
				var size = Math.round(size * 100 / 1024) / 100;
				if (size < 1024)
					result = size + "KB";
				else {
					var size = Math.round(size * 100 / 1024) / 100;
					if (size < 1024)
						result = size + "M";
					else {
						var size = Math.round(size * 100 / 1024) / 100;
						result = size + "G";
					}
				}
			}
		}
		return result;
	};
	/****************************************
	 * 全选
	 ***************************************/
	this.selectAll = function(obj) {
		var checkBox =  document.getElementsByName("attach_"+self.fdKey+"_checkbox");
		var tmpChecked = obj.getAttribute("selected");
		if(obj.checked==true || tmpChecked==null || tmpChecked=="1"){
			checked = true;
			obj.setAttribute("selected","0");
		}else{
			checked = false;
			obj.setAttribute("selected","1");
		}
		if(checkBox!=null) { 
			for(var i=0;i<checkBox.length;i++) {
				checkBox[i].checked = checked;
			} 
		}
	};
	/****************************************
	 * 阻止事件冒泡
	 ***************************************/
	this.sotpBub = function(){
		e = self.getEvent();
		if (window.event){
			e.cancelBubble = true;
		}else{
			e.stopPropagation();
		}
		return false;
	};
	/****************************************
	 * 获取事件对象
	 ***************************************/
	this.getEvent = function(){
		if(window.event) 
	 		return window.event;//如果是ie
	  	func=arguments.callee.caller;
	    while(func!=null){
			var arg0=func.arguments[0];
			if(arg0){
				if(	(arg0.constructor == Event || arg0.constructor == MouseEvent || arg0.constructor == KeyboardEvent) 
					|| (typeof(arg0)=="object" && arg0.preventDefault && arg0.stopPropagation)
					){
					return arg0;
				}            
			}
			func=func.caller;
		}
		return null;
	}; 
	/*****************************************
	 * 创建sysattmain对象
	 *****************************************/
	this.createAttMainInfo = function(doc){
		var xdata = "filekey=" + doc.fileKey + "&filename=" + encodeURIComponent(doc.fileName) + "&fdKey=" + self.fdKey
				+ "&fdModelName=" + self.fdModelName + "&fdModelId=" + self.fdModelId + "&fdAttType=" + self.fdAttType 
				+ "&width="+ self.width + "&height="+ self.height + "&proportion=" + self.proportion;
		// 修复 在开启相关监控软件下post数据后台无法获取的问题
		var result = self.ajax(self.attachurl + '&' + xdata); 
		var val = self.xmlparse(result);
		if(val.status.trim() == "1"){
			doc.fdId = val.attid;
			return val.attid;
		}
		return null;
	}
	
	/////////////////////////////////
	//以下全是与flash交互代码
	/////////////////////////////////
	this.initial = function(){
		self.generateID();
		//self.hasInitial = true;
	};
	this.fileQueued = function(file){
		// 如果附件已上传就不再次上传
		var _fileName = file.name;
		if(file.name.indexOf("base64:")==0){
			var unicode = file.name.substring(7);
			unicode = BASE64.decoder(unicode);
			_fileName = "";
			for(var i = 0 ; i<unicode.length ; i++){  
				_fileName += String.fromCharCode(unicode[i]);  
			}
		}
		for (var i = 0, size = self.fileList.length; i < size; i++) {
			if (self.fileList[i].fileStatus > -1 && self.fileList[i].fileName == _fileName) {
				return false;
			}
		}
    	if(!self.fdMulti){
    		 var len = 0;
    		 for (i = 0; i < self.fileList.length; i++) {
    			 if (self.fileList[i].fileStatus > -1) {
    				 len++;
    			 }
    		 }
    		 if(len>0)
    			 return false;
    	}
		self.addDoc(file.name,self.formatId(file.id),false,'',file.size);
    };
    this.fileQueueError = function(file, errorCode, message){
    	 try {
    	    	if(file.name.indexOf("base64:")==0){
    				var unicode = file.name.substring(7);
    				unicode = BASE64.decoder(unicode);
    				var _fileName="";
    				for(var i = 0 ; i<unicode.length ; i++){  
    					_fileName += String.fromCharCode(unicode[i]);  
    				}
    				file.name = _fileName;
    			}
    			if (errorCode === SWFUpload.QUEUE_ERROR.QUEUE_LIMIT_EXCEEDED) {
    				//alert("You have attempted to queue too many files.\n" + (message === 0 ? "You have reached the upload limit." : "You may select " + (message > 1 ? "up to " + message + " files." : "one file.")));
    				alert(Attachment_MessageInfo["sysAttMain.error.queueError"]);
    				return;
    			} 
    			switch (errorCode) {
    			case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT:
    				var msg = '';
    				if('pic' == self.fdAttType )
    					msg = Attachment_MessageInfo["error.exceedImageMaxSize"];
    				else
    					msg = Attachment_MessageInfo["error.exceedSingleMaxSize"];
					alert(msg.replace("{0}",file.name).replace("{1}",self.smallMaxSizeLimit+' MB'));
    				break;
    			case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE:
    				alert(Attachment_MessageInfo["error.zeroError"].replace("{0}",file.name).replace("{1}",0));
    				break;
    			case SWFUpload.QUEUE_ERROR.INVALID_FILETYPE:
    				alert(Attachment_MessageInfo["error.enabledFileType"].replace("{0}", self.swf_settings.file_types));
    				break;
    			default:
    				alert(Attachment_MessageInfo["error.other"].replace("{0}",file.name).replace("{1}",message));
    				break;
    			}
    			
    		} catch (ex) {
    			alert(Attachment_MessageInfo["error.other"].replace("{0}",file.name).replace("{1}",ex.toString()));
    	    }
     };
     this.fileDialogComplete = function(){
    	 //self._start_();
     };
     
	this.formatId = function(fdId) {
		return fdId + this.uuid;
	};
	
	this.uuid = 0;
	
	this.generateID = function() {
		this.uuid++;
	};
	
     this.__uploadStart = function(file) {
    	 var xdata = "filesize="+file.size+"&md5=";
		 var result = self.ajax(self.tokenurl,xdata);
		 var val = self.xmlparse(result);
		 if(val.status.trim() == "1"){
			 if(self.extParam!=null){
				 self.swfupload.setPostParams({"userkey":val.userkey,"extParam":self.extParam});
			 }else{
				 self.swfupload.setPostParams({"userkey":val.userkey});
			 }
			 //某一个文件开始上传 
			 try{
			 	self.emit("uploadStart",{"file":self.getDoc(self.formatId(file.id))});
			 }catch(e){}
			 return true;
		 }else{
			 return false;
		 }
     };
     this.__uploadProgress = function(file,bytesLoaded,bytesTotal){
    	 try{
		 	self.emit("uploadProgress",{"file":self.getDoc(self.formatId(file.id)),"bytesLoaded":bytesLoaded,"bytesTotal":bytesTotal}); 
		 }catch(e){}
     };
     this.__uploadError = function (file, errorCode, message){
	     //上传失败	      
 		 try{
 		 	self.emit("uploadError",{"file":self.getDoc(self.formatId(file.id)),"errorCode":errorCode,"message":message});
	 	 }catch(e){} 
     };
     this.__uploadSuccess = function (file, serverData){ 
	     //上传成功 
	     var ret = self.xmlparse(serverData);
	     var doc = self.getDoc(self.formatId(file.id));
	     if(ret.status.trim() == "1"){
	    	 if(!doc)
	    		 return;
			 doc.fileKey = ret.filekey;
	    	 if(self.fdAttType=='pic' || self.uploadAfterSelect == true){
	    		 doc.fdId = self.createAttMainInfo(doc);
	    		 if(doc.fdId=='' || doc.fdId==null){
	    			 doc.fileStatus = 0;
	    			 try{
	    			 	self.emit("uploadFaied",{"file":doc,"serverData":ret.msg});
					 }catch(e){}
	    		 }else{
	    			 doc.fileStatus = 1;
	    			 try{
	    			 	doc.id = self.formatId(file.id);
	    			 	self.emit("uploadSuccess",{"file":doc,"serverData":serverData});
					 }catch(e){}
	    		 }
	    	 }else{
	    		 doc.fileStatus = 1;
	    		 try{
	    			 self.emit("uploadSuccess",{"file":doc,"serverData":serverData});
				 }catch(e){}
	    	 } 
			 if(self.uploadAfterSelect == true && doc.fileStatus == 1){
				 if(self.uploadAfterCustom){
	 				self.uploadAfterCustom(doc.fdId);
	 			 } 
			 }
	     }else{
	     	 doc.fileStatus = 0; 
	    	 try{
	    		self.emit("uploadFaied",{"file":doc,"serverData":ret.msg});
			 }catch(e){}
	     }	     
     };
     this.uploadComplete = function (){
    	 //每当一个文件结束后的事件
    	 self._start_();
     };
     this.ajax = function(_url, _data, isScript){
    	 if(Attachment_SyncAjax_Cache[_url] != null)
    		 return Attachment_SyncAjax_Cache[_url];
    	 
    	 var xmlhttp = {};
		 if (window.XMLHttpRequest){
			 // 所有浏览器
			 xmlhttp=new XMLHttpRequest();
		 }else if (window.ActiveXObject){
			 // IE5 和 IE6
			 xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
		 }
		 if(isScript){//解决412报错
			 //_url = Com_SetUrlParameter(_url,"s_saq",Math.random());
		 	 xmlhttp.open("GET", _url, false);
			 xmlhttp.setRequestHeader("Accept", "text/plain");
			 xmlhttp.setRequestHeader("Content-Type","text/plain;charset=UTF-8");
			 xmlhttp.send(_data);
			 Attachment_SyncAjax_Cache[_url] = xmlhttp.responseText;
			 return Attachment_SyncAjax_Cache[_url];
		 }else{
			 xmlhttp.open("POST", _url, false);
			 xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=UTF-8");
			 xmlhttp.send(_data);
			 return xmlhttp.responseText;
		 }
     }; 
     this.xmlparse = function(text){ 
    	 var xmlDoc =  XML_CreateByContent(text.trim());
    	 var val = {}; 
    	 var ret = XML_GetNodesByPath(xmlDoc,"/return")[0].childNodes;
    	 for (i=0;i<ret.length;i++){
    		 if (ret[i].nodeType==1){
    			 val[ret[i].nodeName] = ret[i].firstChild.nodeValue;
    		  } 
    	 }
    	 return val;
     };
     this._start_ = function (){
    	 var stats = self.swfupload.getStats();
    	 if (stats.files_queued > 0) {
    		self.swfupload.startUpload();
    	 }
     };
     this.isUploaded = function() {
    	 try{
    		 var isUploaded = true;
    		 for(var i=0 ;i<self.fileList.length;i++){
    			 if(self.fileList[i].fileStatus==0){
    				 isUploaded = false;
    			 }
    		 } 
    		return  isUploaded && self.fdBigAttUploaded
    	 }catch(ex){
    		 return false;
    	 }
     };
     this.onBigAttFrameClose = function(){
    	 self.fdBigAttUploaded = true;
     };
     
     this.swf_settings = {
				flash_url : self.getHost() + Com_Parameter.ContextPath + "sys/attachment/swf/swfupload.swf",
				upload_url: self.getHost() + self.uploadurl, 
				file_size_limit : self.smallMaxSizeLimit + " MB",
				file_upload_limit : 0,
				file_queue_limit : 0, 
				debug: false,
	
				// Button settings
				button_image_url: Com_Parameter.ContextPath + "sys/attachment/view/img/bg.png",
				button_placeholder_id: "upload_"+self.fdKey+"_div_flash",
				button_text: "",
				button_text_style: "",
				button_text_left_padding: 0,
				button_text_top_padding: 0,
				button_cursor: SWFUpload.CURSOR.HAND,
				button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
				
				//The event handler functions are defined in handlers.js
				swfupload_loaded_handler:self.initial,
				file_queued_handler : self.fileQueued,
				file_queue_error_handler : self.fileQueueError,
				file_dialog_complete_handler : self.fileDialogComplete,
				upload_start_handler : self.__uploadStart,
				upload_progress_handler : self.__uploadProgress,
				upload_error_handler : self.__uploadError,
				upload_success_handler : self.__uploadSuccess,
				upload_complete_handler : self.uploadComplete
			};
			
	this.formatEnabledFileType = function(){
		if (!this.enabledFileType)
			return false;
		if (this.enabledFileType.indexOf("*") != 0)
			this.enabledFileType = "*" + this.enabledFileType;
		this.enabledFileType = this.enabledFileType.replace(/\|/g, ";*");
		return this.enabledFileType;
	};
	
	if (this.fdAttType == "pic") {
		this.swf_settings.file_types = "*.gif;*.jpg;*.jpeg;*.bmp;*.png";
		if(this.formatEnabledFileType())
			this.swf_settings.file_types = this.enabledFileType;
	else
		this.swf_settings.file_types_description = "Picture Files";
	} else if (this.enabledFileType) {
		this.swf_settings.file_types = this.formatEnabledFileType()
		this.swf_settings.file_types_description = "Custom Files";
	} else {
		this.swf_settings.file_types = "*.*";
		this.swf_settings.file_types_description = "All Files";
	}
     if(!this.fdMulti){
    	 this.swf_settings.button_action = SWFUpload.BUTTON_ACTION.SELECT_FILE;
     }else{
    	 this.swf_settings.button_action = SWFUpload.BUTTON_ACTION.SELECT_FILES;
     }
     this.drawFrame = function(){
		 if(self.layoutFn == null){		 	
		 	 var result = self.ajax(self.layouturl , null , true); 
			 self.layoutFn = new Function('$','done',result);
		 }
		 self.layoutFn.apply(self,[$,function(dom){
		 	var xdiv = $("#" + self.renderId);
		 	xdiv.empty();
		 	xdiv.append(dom);
		 	var uploadDiv = xdiv.find("[data-lui-mark='uploadbutton']").attr("id","upload_"+self.fdKey+"_div_flash");
		 	 //重新计算uploader高宽，主要原因是swfupload配置中，如果使用百分比的高宽，会导致鼠标手型配置失效
		 	 //按钮构建放置于layout构建后，防止高度宽度获取不到
		    self.swf_settings['button_width'] = uploadDiv.width() <=0 ? 75 : uploadDiv.width() ;
		    self.swf_settings['button_height'] = uploadDiv.height() <=0 ? 25 : uploadDiv.height();
		    if (self.editMode == "edit" || self.editMode == "add"){   
		    	self.swfupload = new SWFUpload(self.swf_settings);	
		    	self.swfupload.loadFlash();
		    	Com_Parameter.event["confirm"].unshift(function() {
		    		if(self.required){
		    			if(self.fileList && self.fileList.length==0){
		    				alert("请上传至少一个附件!");
		    				return false;
		    			}
		    		}
		 	    	var upOk = self.isUploaded();
		 	    	if(!upOk){
		 	    		alert(Attachment_MessageInfo["msg.uploading"]);
		 	    	}else{
		 	    		if (self.editMode == "edit" || self.editMode == "add") {
		 	    			return self.updateInput();
		 	    		} 
		 	    	}
		 	    	return upOk;
		 	    }); 
		   	}
		 }]);
     }
     this.showButton = function(){
    	 self.btnIntial = true;
	     self.drawFrame();
     }
}
 
Swf_AttachmentObject.prototype.on = function(event, callback) {
    if (!callback) return this;
    var list = this.eventsCache[event] || (this.eventsCache[event] = []);
    list.push(callback);
    return this
}
Swf_AttachmentObject.prototype.off = function(event, callback) {
    // Remove *all* events
    if (!(event || callback)) {
        this.eventsCache = {};
        return this;
    }
    var list = this.eventsCache[event];
    if (list) {
        if (callback) {
            for (var i = list.length - 1; i >= 0; i--) {
                if (list[i] === callback) {
                    list.splice(i, 1);
                }
            }
        } else {
            delete this.eventsCache[event];
        }
    }
    return this;
}
Swf_AttachmentObject.prototype.emit = function(event, data) {
    var list = this.eventsCache[event];
    var fn;
    if (list) {
        // Copy callback lists to prevent modification
        list = list.slice()
        // Execute event callbacks
        while ((fn = list.shift())) {
            fn(data);
        }
    }
    return this;
}
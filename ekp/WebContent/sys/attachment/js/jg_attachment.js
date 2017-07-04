/*******************************************************************************
 * JS文件说明： 该文件提供了金格在线编辑的操作函数
 * 
 * 作者：缪贵荣
 * 版本：1.0 2010-11-25
 ******************************************************************************/
Com_RegisterFile("jg_attachment.js");
Com_IncludeFile("common.js");
Com_IncludeFile("upload.css",Com_Parameter.ContextPath	+ "sys/attachment/view/img/","css",true);
Com_IncludeFile("sysAttMain_MessageInfo.jsp?locale="+ Com_Parameter.__sysAttMainlocale__,Com_Parameter.ContextPath + "sys/attachment/sys_att_main/", 'js',true);
if (typeof Attachment_ObjectInfo == "undefined") {
	Attachment_ObjectInfo = new Array();
}

/***********************************************
 功能  附件对象的构造函数
 参数：
	 fdId:
	 可选，附件的fdId
	 fdKey：
	 必选，附件标识名称
	 fdModelName：
	 必选，域模型名称
	 fdModelId:
	 可选，当前文档的fdId
	 fdAttType:
	 可选，文件类型，office ，默认为office
 ***********************************************/
function JG_AttachmentObject(fdId, fdKey, fdModelName, fdModelId, fdAttType,
		editMode, divName) {
	this.fdId = fdId;
	this.fdKey = fdKey; // 附件标识
	this.fdModelName = fdModelName;
	this.fdModelId = fdModelId;
	if (fdAttType == null)
		fdAttType = "office";
	this.attType = fdAttType;
	this.currentMode = Com_GetUrlParameter(location.href, "method");
	if (editMode == null)
		editMode = currentMode;
	this.editMode = editMode;
	if (editMode == "edit" || editMode == "add") {
		this.canDelete = true;
		this.canRead = true;
		this.canDownload = true;
		this.canEdit = true;
		this.canPrint = true;
		this.canAdd = true;
		this.canCopy = true;
	} else {
		this.canDelete = false;
		this.canRead = true;
		this.canDownload = false;
		this.canEdit = false;
		this.canPrint = false;
		this.canAdd = false;
		this.canCopy = false;
	} 
	this.canSaveDraft=true; 
	if (divName == null)
		divName = "JGWebOffice_" + fdKey;
	this.navName = divName;
	this.userName = "";
	this.ocxObj = null;
	this.disabled = false;
	this.hasLoad = false;
	this.hasAddSubmitFun = false;
	this.hasShowButton = false;
	this.showRevisions = false;
	this.trackRevisions = true;
	this.forceRevisions = true;  //是否强制不留痕
	this.hiddenRevisions=true;
	this.bindSubmit = true;   //是否绑定提交方法
	
	this.buttonDiv = null;
	this.isTemplate = false;
	this.fdTemplateModelId = null;
	this.fdTemplateModelName = null;
	this.fdTemplateKey = "";
	this.bookMarks = "";

	Attachment_ObjectInfo[fdKey] = this;

	this.getOcxObj = function(divName) {
		if (this.ocxObj == null) {
			if (divName == null)
				divName = this.navName;
			if (typeof (divName) == "string") {
				this.ocxObj = document.getElementById(divName);
			} else {
				this.ocxObj = divName;
			}
		}
		return (this.ocxObj == null ? false : true);
	};

	this.isActive = JG_Attachment_IsActive;
	this.load = JG_Attachment_Load;
	this.unLoad = JG_Attachment_UnLoad;
	this.show = JG_Attachment_Show;
	this.setBookmark = JG_Attachment_SetBookmark;
	this.setFileName = JG_Attachment_SetFileName;
	this.isProtect = JG_Attachment_IsProtect;
	this.setProtect = JG_Attachment_SetProtect;
	this.disabledObject = JG_Attachment_Disabled;
	this.setStatusMsg = JG_Attachment_SetStatusMsg;
	this.getUrl = JG_Attachment_GetUrl;
	this.saveAsImage = JG_Attachment_saveAsImage;

	this._showButton = _JG_Attachment_ShowButton;
	this._hideButton = _JG_Attachment_HideButton;
	this._setParamter = _JG_Attachment_SetParamter;
	this._setBookmark = _JG_Attachment_SetBookmark;
	this._submit = _JG_Attachment_Submit;
	this._writeAttachmentInfo = _JG_Attachment_WriteAttachmentInfo;
	this._isWord = _JG_Attachment_IsWord;
	this._isExcel = _JG_Attachment_IsExcel;
	this._isAfter2003 = _JG_Attachment_IsAfter2003;
	this._getWpsVersion = _JG_Attachment_getWpsVersion;

}

/***********************************************
 功能 判断插件是否安装成功
 ***********************************************/
function JG_Attachment_IsActive() {
	try { // 根据控件注册时的ProgID来判断
		var obj = new ActiveXObject("iWebOffice2009.HandWriteCtrl"); // 2009控件
		return true;
	} catch (e) {
		return false;
	}
}

/***********************************************
 功能 打开文档
 参数：
	 fileName：
	 可选，文件名，默认fdKey
	 fileType:
	 可选，文件类型，默认word文档
 ***********************************************/
function JG_Attachment_Load(fileName, fileType) {
	if (!this.hasLoad && this.getOcxObj()) {
		try {
			this.ocxObj.WebUrl = Com_GetCurDnsHost() + Com_Parameter.ContextPath
					+ "sys/attachment/sys_att_main/jg_service.jsp";
			this.ocxObj.RecordID = this.fdModelId; // RecordID为文档的fdModelId
			this.ocxObj.Compatible = false;			//控件兼容模式
			if(fileName){
				if(fileName.lastIndexOf(".")>-1){
					this.ocxObj.FileType = fileName.substring(fileName.lastIndexOf("."));
					this.ocxObj.FileName = fileName;
				}else{
					this.ocxObj.FileType = fileType ? fileType : ".doc";
					this.ocxObj.FileName = fileName + this.ocxObj.FileType;
				}
			}else{
				this.ocxObj.FileType = fileType ? fileType : ".doc";
				this.ocxObj.FileName = (this.fdKey + this.ocxObj.FileType);
			}
			this.ocxObj.UserName = this.userName;
			this.ocxObj.MaxFileSize = 100 * 1024;
			this.ocxObj.ProgressXY(100,100);
			this.ocxObj.Language = Attachment_MessageInfo["info.JG.lang"];
			// this.ocxObj.Language="CH";
			// this.ocxObj.Language="EN";
			this.ocxObj.ShowWindow = "1";
			// this.ocxObj.EditType="0,1";
			// this.ocxObj.EditType="1,1";
			// this.ocxObj.EditType = "-1,0,0,0,0,1,1,1";
			if(this.showRevisions)
				this.ocxObj.EditType = "-1,0,1,1,0,1,1,1";
			else
				this.ocxObj.EditType = "-1,0,0,1,0,1,1,1";
			if (this.editMode == "edit" || this.editMode == "add") {
				this.ocxObj.ShowToolBar = 0; // 控件工具栏
			} else {
				this.ocxObj.ShowToolBar = 2; // office工具栏
			}
			this.ocxObj.ShowMenu = "0"; // 设置是否显示整个菜单
			this.ocxObj.ToolsSpace = 0;
			if (this.canPrint) {
				this.ocxObj.EnablePrint = "1"; // 设置是否允许打印
			} else {
				this.ocxObj.EnablePrint = "0";
			}
			this._setParamter();
			this.ocxObj.WebOpen(true);
			//暂时屏蔽wps2012
			//if(this._getWpsVersion()=="2012"){
			//	self.close();
			//}
			this.setStatusMsg(this.ocxObj.Status);
			this.attType = "office";
			this._setBookmark();
			if (this.editMode != "edit" && this.editMode != "add") {
				this.setProtect();
			}
			this.hasLoad = true;
		} catch (e) {
			alert("jg_load error: " + e.description);
		}
	}
}

/***********************************************
 功能 关闭文件，释放资源
 ***********************************************/
function JG_Attachment_UnLoad() {
	if (this.hasLoad) {
		try {
			if (!this.ocxObj.WebClose()) {
				this.setStatusMsg(this.ocxObj.Status);
				alert(this.ocxObj.Status);
			}
		} catch (e) {
			alert("jg_unLoad error: " + e.description);
		}
	}
}

/***********************************************
 功能  显示附件列表
 ***********************************************/
function JG_Attachment_Show() {
	this.disabledObject(false);
}

 
/***********************************************
 功能  在线编辑时设置书签值
 参数：
	 name：必需 书签名称
	 value：必需，书签的值
 ***********************************************/
function JG_Attachment_SetBookmark(name, value) {
	if (name == null || value == null)
		return false;
	if (name == "")
		return false;
	if (this.attType == "office") {
		if (this.getOcxObj() && this.hasLoad) {
			if (!this.isProtect()) {
				if (value == this.ocxObj.WebGetBookMarks(name)) { // 如果内容一样不再设置书签
					return true;
				}
				if (this._isWord()) {
					return this.ocxObj.WebSetBookMarks(name, value);
				}
				var editType = this.ocxObj.EditType;
				try {
					//wps下设置书签不稳定临时处理方式
					this.ocxObj.EditType = "1,1";
					return this.ocxObj.WebSetBookMarks(name, value);
				} catch (err) {
					//alert("set bookmark error: " + err);
				} finally {
					this.ocxObj.EditType = editType;
				}
			}
		} else {
			setTimeout("Attachment_ObjectInfo[\"" + this.fdKey
					+ "\"].setBookmark(\"" + name.replace("\"", "\\\"")
					+ "\",\"" + value.replace("\"", "\\\"") + "\")", 1000);
			return true;
		}
	}
	return false;
}

/***********************************************
 功能  设置附件文件名
 参数：
 fileName：必需， 文件名
 fileType：可选，文件类型
 注：附件提交前设置，附件是第一个提交的。
 ***********************************************/
function JG_Attachment_SetFileName(fileName, fileType) {
	if (fileName) {
		this.ocxObj.FileName = encodeURIComponent(fileName);
	}
	if (fileType) {
		this.ocxObj.FileType = fileType;
	}
}

/***********************************************
 功能  判断文档是否保护模式
 ***********************************************/
function JG_Attachment_IsProtect() {
	try {
		if (this.ocxObj.FileType.toLowerCase().lastIndexOf(".doc") > -1) {
			var r = this.ocxObj.WebObject.ProtectionType;
			if (r > -1&&r != 3) {
				return true;
			}
		} else if (this.ocxObj.FileType.toLowerCase().lastIndexOf(".xls") > -1) {
			var mpc = this.ocxObj.WebObject.Application.ActiveSheet.ProtectContents;
			var mpdo = this.ocxObj.WebObject.Application.ActiveSheet.ProtectDrawingObjects;
			var mps = this.ocxObj.WebObject.Application.ActiveSheet.ProtectScenarios;
			if (mpc || mpdo || mps) {
				return true;
			}
		}
	} catch (e) {
		return false;
	}
	return false;
}

/***********************************************
 功能  设置附件是否保护
 参数：
 	isProtect：可选， 是否保护
 ***********************************************/
function JG_Attachment_SetProtect(isProtect) {
	 try {
    	if (isProtect == true || isProtect == null) {
			if (this.canCopy) {
				// 修改签章锁定后，下载公文报错的问题
				this.ocxObj.WebSetProtect(false, ""); // 可复制的保护
			} else {
				// 不可复制的保护,保护分窗体保护和非窗体保护，excel没有非窗体保护模式，所以这里做类型判断
				if(this._isWord()){
				  this.ocxObj.WebObject.Protect(2, false, ""); 
				}else{
				  this.ocxObj.WebSetProtect(true, "");
				}
			}
		} else {
			this.ocxObj.WebSetProtect(false, ""); // ""表示密码为空
		}
		this.ocxObj.DisableKey("CTRL+P,F12"); // 禁止快捷键
	}catch (e) {
		alert("jg_load error: " + e.description);
	}
}


/***********************************************
 功能  隐藏控件
 参数：
 	disabled：可选， 是否隐藏
 ***********************************************/
function JG_Attachment_Disabled(disabled) {
	if (disabled == null)
		disabled = !this.disabled;
	if (disabled) {
		//隐藏
		this._hideButton();
		if (this.getOcxObj())
			this.ocxObj.style.display = "none";
	} else {
		//显示
		this._showButton();
		if (this.getOcxObj())
			this.ocxObj.style.display = "";
	}
	this.disabled = disabled;
}

/***********************************************
 功能 显示操作状态
 ***********************************************/
function JG_Attachment_SetStatusMsg(mString) {
	window.status = mString;
}

/***********************************************
 功能  生成附件的链接
 参数：
	 method:链接中的method参数值，
	 fdId:附件的ID
	 needHost:是否需要显示绝对路径
 ***********************************************/
function JG_Attachment_GetUrl(method, fdId, needHost) {
	var host = "";
	if (needHost)
		host = location.protocol.toLowerCase() + "//" + location.hostname + ":" + location.port;
	return host + Com_Parameter.ContextPath
			+ "sys/attachment/sys_att_main/sysAttMain.do?method=" + method
			+ "&fdId=" + fdId;
}

/***********************************************
 功能 设置后台交互的参数
 ***********************************************/
function _JG_Attachment_SetParamter() {
	this.ocxObj.WebSetMsgByName("_attType", this.attType);
	this.ocxObj.WebSetMsgByName("_fdId", this.fdId);
	this.ocxObj.WebSetMsgByName("_fdModelName", this.fdModelName);
	this.ocxObj.WebSetMsgByName("_fdKey", this.fdKey);
	if (!this.isTemplate && this.fdTemplateModelId && this.fdTemplateModelName) {
		this.ocxObj.WebSetMsgByName("_fdTemplateModelId",
				this.fdTemplateModelId);
		this.ocxObj.WebSetMsgByName("_fdTemplateModelName",
				this.fdTemplateModelName);
		this.ocxObj.WebSetMsgByName("_fdTemplateKey", this.fdTemplateKey);
	}
}

/***********************************************
 功能  在线编辑时设置书签值（内部方法）
 ***********************************************/
function _JG_Attachment_SetBookmark() {
	if (this.bookMarks) {
		var bmsArr = this.bookMarks.split(",");
		var isWord = this._isWord();
		var editType = this.ocxObj.EditType;
		try {
			if(!isWord) {
				//wps下设置书签不稳定临时处理方式
				this.ocxObj.EditType = "1,1"
			}
			for ( var i = 0, l = bmsArr.length; i < l; i++) {
				if (bmsArr[i]) {
					var bmArr = bmsArr[i].split(":");
					if (bmArr && bmArr[0] && bmArr[1]) {
						if (bmArr[1] == this.ocxObj.WebGetBookMarks(bmArr[0])) { // 如果内容一样不再设置书签
							continue;
						}
						//冒号处理，防止时间等带有冒号的值给截断了
						if(bmArr.length>2){
							this.ocxObj.WebSetBookMarks(bmArr[0], bmsArr[i].substring(bmsArr[i].indexOf(":")+1));
						}else{
							this.ocxObj.WebSetBookMarks(bmArr[0], bmArr[1]);
						}
					}
				}
			}
		} catch (err) {
			//alert("set bookmark error: " + err);
		} finally {
			this.ocxObj.EditType = editType;
		}
	}
}

/***********************************************
 功能  显示操作按钮
 ***********************************************/
function _JG_Attachment_ShowButton() {
	if (this.hasShowButton)
		return true;
	if (this.attType == "office") {
		var obj = null;
		var showDiv = this.buttonDiv;
		if (showDiv == null) {
			obj = document.getElementById("_button_" + this.fdKey
					+ "_JG_Attachment_TD");
			obj.style.textAlign = "right";
			obj.parentElement.parentElement.parentElement.style.width = "100%";
		} else {
			obj = document.getElementById(showDiv);
		}
		var _createTempInput = function(name,value,flag){
			  var inputDom = document.createElement("a");
			  var a_name = document.createAttribute("name");
			    a_name.nodeValue = name;
			  var a_href = document.createAttribute("href");
			    a_href.nodeValue = "javascript:void(0);";
			  var a_class = document.createAttribute("class");
			     a_class.nodeValue = flag;
			    var a_Text = document.createTextNode(value);
			    inputDom.setAttributeNode(a_href);
			    inputDom.setAttributeNode(a_name);
			    inputDom.setAttributeNode(a_class);
			    inputDom.appendChild(a_Text);
			    return inputDom;
		};
		var _insertDomBefore = function(insertTo,insertObj){
			if(insertTo.firstChild!=null){
				insertTo.insertBefore(insertObj,insertTo.firstChild); 
			}else{
				insertTo.appendChild(insertObj);
			}
		};
		var _createInput = function(name,value){
			var inputDom = document.createElement("input");
			inputDom.setAttribute("type","button");
			inputDom.className="btnopt";
			inputDom.value = value;
			inputDom.setAttribute("name",name);
			return inputDom;
		};
		var _insertBefore = function(insertTo,insertObj){
			if(insertTo.firstChild!=null){
				insertTo.insertBefore(insertObj,insertTo.firstChild); 
			}else{
				insertTo.appendChild(insertObj);
			}
		};
		var attachmentObject = this;
		if (this.ocxObj.FileType.toLowerCase().lastIndexOf(".doc") > -1) {
			
			if (!this.isTemplate && this.currentMode != 'add'&&this.hiddenRevisions) {
				var _showRevisions;
				//隐藏显示留痕按钮
				if (showDiv == null){
					if(!attachmentObject.forceRevisions){
						//如果设置了强制不留痕，则不保存痕迹
						attachmentObject.ocxObj.WebShow(attachmentObject.forceRevisions);
					}else{
						_showRevisions = _createInput(this.fdKey + "_showRevisions",
								this.showRevisions ? Attachment_MessageInfo["button.hideRevisions"]: Attachment_MessageInfo["button.showRevisions"]);
						//在线编辑打开，默认显示留痕
						if(attachmentObject.showRevisions == true){
							attachmentObject.ocxObj.WebSetRevision(true,true,true,true);
						}
						_showRevisions.onclick = function() {
							if(attachmentObject.canCopy) {
								attachmentObject.ocxObj.WebSetRevision(!attachmentObject.showRevisions,true,true,true);
							} else {
								attachmentObject.ocxObj.WebSetRevision(!attachmentObject.showRevisions,true,true,true);
								attachmentObject.setProtect();
							}
							attachmentObject.showRevisions = !attachmentObject.showRevisions;
							_showRevisions.value = attachmentObject.showRevisions ? Attachment_MessageInfo["button.hideRevisions"]
									: Attachment_MessageInfo["button.showRevisions"];
							OptBar_Refresh();
						};
						_insertBefore(obj,_showRevisions); 
						var blank = document.createElement("SPAN");
						blank.innerHTML = "&nbsp;&nbsp;";
						_insertBefore(obj,blank);
					}
				}else{
					if(!attachmentObject.forceRevisions){
						//如果设置了强制不留痕，则不保存痕迹
						attachmentObject.ocxObj.WebShow(attachmentObject.forceRevisions);
					}else{
					_showRevisions= _createTempInput(this.fdKey + "_showRevisions",
							this.showRevisions ? Attachment_MessageInfo["button.hideRevisions"]: Attachment_MessageInfo["button.showRevisions"],"attshowRevisions");
					//在线编辑打开，默认显示留痕
					if(attachmentObject.showRevisions == true){
						attachmentObject.ocxObj.WebSetRevision(true,true,true,true);
					}
					_showRevisions.onclick = function() {
					if(attachmentObject.canCopy) {
						attachmentObject.ocxObj.WebSetRevision(!attachmentObject.showRevisions,true,true,true);
					} else {
						attachmentObject.ocxObj.WebSetRevision(!attachmentObject.showRevisions,true,true,true);
						attachmentObject.setProtect();
					}
					attachmentObject.showRevisions = !attachmentObject.showRevisions;
					_showRevisions.innerHTML = attachmentObject.showRevisions ? Attachment_MessageInfo["button.hideRevisions"]
							: Attachment_MessageInfo["button.showRevisions"];
					//OptBar_Refresh();
				  };
				  _insertDomBefore(obj,_showRevisions); 
					var blank = document.createElement("SPAN");
					blank.innerHTML = "&nbsp;&nbsp;";
					_insertDomBefore(obj,blank);
				}
			  }
			}
			if (this.editMode == "edit" || this.editMode == "add") {
				var _page;
				var _bookmark;
				if(showDiv == null){
					//编辑页眉页脚
					_page = _createInput(this.fdKey + "_page",Attachment_MessageInfo["button.page"]);
					_page.onclick = function() {
						attachmentObject.ocxObj.WebObject.ActiveWindow.ActivePane.View.SeekView = 9;
					};
					_insertDomBefore(obj,_page); 
					blank = document.createElement("SPAN");
					blank.innerHTML = "&nbsp;&nbsp;";
					_insertDomBefore(obj,blank); 
					// 书签管理
					_bookmark =  _createInput(this.fdKey + "_bookmark", Attachment_MessageInfo["button.bookmark"]);
					_bookmark.onclick = function() {
						try {
							attachmentObject.ocxObj.Active(true);//控件获取焦点
							attachmentObject.ocxObj.WebObject.Application
									.Dialogs(168).Show(); // office
						} catch (e) {
							attachmentObject.ocxObj.WebObject.Application
									.Dialogs(16394).Show(); // wps
						}
					};
					_insertBefore(obj,_bookmark); 
					blank = document.createElement("SPAN");
					blank.innerHTML = "&nbsp;&nbsp;";
					_insertBefore(obj,blank); 
				}else{
				//编辑页眉页脚
				 _page = _createTempInput(this.fdKey + "_page",Attachment_MessageInfo["button.page"],"attpage");
				_page.onclick = function() {
					attachmentObject.ocxObj.WebObject.ActiveWindow.ActivePane.View.SeekView = 9;
				};
				_insertDomBefore(obj,_page); 
				blank = document.createElement("SPAN");
				blank.innerHTML = "&nbsp;&nbsp;";
				_insertDomBefore(obj,blank); 
				// 书签管理
				 _bookmark =  _createTempInput(this.fdKey + "_bookmark", Attachment_MessageInfo["button.bookmark"],"attbook");
				_bookmark.onclick = function() {
					try {
						attachmentObject.ocxObj.Active(true);//控件获取焦点
						attachmentObject.ocxObj.WebObject.Application
								.Dialogs.item(168).Show(); // office 
					} catch (e) {
						attachmentObject.ocxObj.WebObject.Application
								.Dialogs(16394).Show(); // wps
					}
				};
				_insertDomBefore(obj,_bookmark); 
				blank = document.createElement("SPAN");
				blank.innerHTML = "&nbsp;&nbsp;";
				_insertDomBefore(obj,blank); 
			  }
			}			
			//暂存
			if (this.canSaveDraft&&this.editMode=='edit') {
				if(!this.isTemplate && (Com_GetUrlParameter(location.href, "method") == 'view'||Com_GetUrlParameter(location.href, "method") == 'edit')) {//暂存按钮是否显示的判断条件
					var _saveDraft;
					if(showDiv == null){
						_saveDraft= _createInput(this.fdKey + "_saveDraft",Attachment_MessageInfo["button.saveDraft"]);
						_saveDraft.onclick = function() { 
							attachmentObject._submit(); 
						};
						_insertBefore(obj,_saveDraft); 
						blank = document.createElement("SPAN");
						blank.innerHTML = "&nbsp;&nbsp;";
						_insertBefore(obj,blank); 
						
					}else{
					 _saveDraft= _createTempInput(this.fdKey + "_saveDraft",Attachment_MessageInfo["button.saveDraft"],"attsaveDraft");
					_saveDraft.onclick = function() { 
						attachmentObject._submit();
					};
					_insertDomBefore(obj,_saveDraft); 
					blank = document.createElement("SPAN");
					blank.innerHTML = "&nbsp;&nbsp;";
					_insertDomBefore(obj,blank); 
				  }
				}
			}	
			if (this.canPrint) {
				if (!this.isTemplate && this.currentMode != 'add') {
					var _print;
					if(showDiv == null){
						//打印
						_print =  _createInput(this.fdKey + "_print",Attachment_MessageInfo["button.print"]);
						_print.onclick = function() {
							attachmentObject.ocxObj.WebOpenPrint();
						};
						_insertBefore(obj,_print);  
						blank = document.createElement("SPAN");
						blank.innerHTML = "&nbsp;&nbsp;";
						_insertBefore(obj,blank); 
						
					}else{
					//打印
					 _print =  _createTempInput(this.fdKey + "_print",Attachment_MessageInfo["button.print"],"attprint");
					_print.onclick = function() {
						attachmentObject.ocxObj.WebOpenPrint();
					};
					_insertDomBefore(obj,_print);  
					blank = document.createElement("SPAN");
					blank.innerHTML = "&nbsp;&nbsp;";
					_insertDomBefore(obj,blank); 
					}
				}
			}
			if (this.canDownload) {
				if (!this.isTemplate && this.currentMode != 'add') {
					//下载（相当于另存为）
					if(this.fdKey==="editonline"||this.fdKey==="mainOnline"){
						var _download;
						if(showDiv == null){
							_download = _createInput(this.fdKey + "_download", Attachment_MessageInfo["button.download"]);
							_download.onclick = function() {
								if (attachmentObject.isProtect()) {
									attachmentObject.setProtect(false);
									attachmentObject.ocxObj.ClearRevisions(); // 去除痕迹
								    attachmentObject.setProtect();
							   }
								//解码，避免下载时文件名乱码
								attachmentObject.ocxObj.fileName = decodeURIComponent(attachmentObject.ocxObj.fileName);
								if (attachmentObject.ocxObj.WebSaveLocal()) { //保存为本地
									alert(Attachment_MessageInfo["msg.downloadSucess"]);
								}
								//编码，避免提交后文件名乱码
								attachmentObject.ocxObj.fileName = encodeURIComponent(attachmentObject.ocxObj.fileName);
							};
							_insertBefore(obj,_download);
							blank = document.createElement("SPAN");
							blank.innerHTML = "&nbsp;&nbsp;";
							_insertBefore(obj,blank);
						}else{
						_download = _createTempInput(this.fdKey + "_download", Attachment_MessageInfo["button.download"],"attdownload");
						_download.onclick = function() {
							if (attachmentObject.isProtect()) {
								attachmentObject.setProtect(false);
								attachmentObject.ocxObj.ClearRevisions(); // 去除痕迹
							    attachmentObject.setProtect();
						   }
							//解码，避免下载时文件名乱码
							attachmentObject.ocxObj.fileName = decodeURIComponent(attachmentObject.ocxObj.fileName);
							if (attachmentObject.ocxObj.WebSaveLocal()) { //保存为本地
								alert(Attachment_MessageInfo["msg.downloadSucess"]);
							}
							//编码，避免提交后文件名乱码
							attachmentObject.ocxObj.fileName = encodeURIComponent(attachmentObject.ocxObj.fileName);
						};
						_insertDomBefore(obj,_download);
						blank = document.createElement("SPAN");
						blank.innerHTML = "&nbsp;&nbsp;";
						_insertDomBefore(obj,blank);
					  }
					}
				}
			}
		} 
		if(this.ocxObj.FileType.toLowerCase().lastIndexOf(".xls") > -1){
			if (this.canPrint) {
				if (!this.isTemplate && this.currentMode != 'add') {
					var _print;
					if(showDiv == null){
						//打印
						_print  = _createInput( this.fdKey + "_print", Attachment_MessageInfo["button.print"]);
						_print.onclick = function() {
							attachmentObject.ocxObj.WebOpenPrint();
						};
						_insertBefore(obj,_print);
						blank = document.createElement("SPAN");
						blank.innerHTML = "&nbsp;&nbsp;";
						_insertBefore(obj,blank);
						// 打印预览
					}else{
					//打印
					_print  = _createTempInput( this.fdKey + "_print", Attachment_MessageInfo["button.print"],"_print");
					_print.onclick = function() {
						attachmentObject.ocxObj.WebOpenPrint();
					};
					_insertDomBefore(obj,_print);
					blank = document.createElement("SPAN");
					blank.innerHTML = "&nbsp;&nbsp;";
					_insertDomBefore(obj,blank);
					// 打印预览
				  }
				}
			}
			//暂存
			if (this.canSaveDraft&&this.editMode=='edit') {
				if(!this.isTemplate && (Com_GetUrlParameter(location.href, "method") == 'view'||Com_GetUrlParameter(location.href, "method") == 'edit')) {//暂存按钮是否显示的判断条件
					var _saveDraft;
					if(showDiv == null){
						_saveDraft= _createInput(this.fdKey + "_saveDraft",Attachment_MessageInfo["button.saveDraft"]);
						_saveDraft.onclick = function() { 
							attachmentObject._submit(); 
						};
						_insertBefore(obj,_saveDraft);
						blank = document.createElement("SPAN");
						blank.innerHTML = "&nbsp;&nbsp;";
						_insertBefore(obj,blank);
					}else{
					_saveDraft= _createTempInput(this.fdKey + "_saveDraft",Attachment_MessageInfo["button.saveDraft"],"attsaveDraft");
					_saveDraft.onclick = function() { 
						attachmentObject._submit(); 
					};
					_insertDomBefore(obj,_saveDraft);
					blank = document.createElement("SPAN");
					blank.innerHTML = "&nbsp;&nbsp;";
					_insertDomBefore(obj,blank);
				  }
				}
			}
		}
		 
		if (!this.isTemplate && this.currentMode == 'add') { 
			// 打开本地初稿
			if(showDiv == null){
				// 打开本地初稿
				var _openLocal = _createInput(this.fdKey + "_openLocal",Attachment_MessageInfo["button.openLocal"]);
				_openLocal.onclick = function() {
					attachmentObject.ocxObj.WebOpenLocal();
				};
				_insertBefore(obj,_openLocal);
				blank = document.createElement("SPAN");
				blank.innerHTML = "&nbsp;&nbsp;";
				_insertBefore(obj,blank); 
			}else{
			var _openLocal = _createTempInput(this.fdKey + "_openLocal",Attachment_MessageInfo["button.openLocal"],"attopenLocal");
			_openLocal.onclick = function() {
				attachmentObject.ocxObj.WebOpenLocal();
			};
			_insertDomBefore(obj,_openLocal);
			blank = document.createElement("SPAN");
			blank.innerHTML = "&nbsp;&nbsp;";
			_insertDomBefore(obj,blank); 
		  }
		}
		//全屏按钮开始
		var _fullSize = _createTempInput(this.fdKey + "_fullSize",Attachment_MessageInfo["button.fullsize"],"attfullSize");
		_fullSize.onclick = function() {
			attachmentObject.ocxObj.FullSize();
		};
		_insertDomBefore(obj,_fullSize); 
		var blank = document.createElement("SPAN");
		blank.innerHTML = "&nbsp;&nbsp;";
		_insertDomBefore(obj,blank); 
		//全屏按钮结束 
		//OptBar_Refresh(true);
		this.hasShowButton = true;
		if (!this.hasAddSubmitFun && !this.disabled && !this.isProtect()&&this.bindSubmit) {
			Com_Parameter.event["confirm"].unshift( function() {
				return attachmentObject._submit();
			});
			this.hasAddSubmitFun = true;
		}
	}
}

/***********************************************
 功能  隐藏操作按钮
 ***********************************************/
function _JG_Attachment_HideButton(showDiv) {
	if (!this.hasShowButton)
		return true;
	if (showDiv == null)
		showDiv = this.buttonDiv;
	if (this.attType == "office") {
		if (showDiv == null)
			showDiv = "_button_" + this.fdKey + "_JG_Attachment_TD";
		var obj = document.getElementById(showDiv);
		var nodes = obj.childNodes;
		for ( var i = 0; i < nodes.length; i++) {
			if (nodes[i].name != null
					&& nodes[i].name.indexOf(this.fdKey + "_") == 0) {
				obj.removeChild(nodes[i]);
			}
		}
		//OptBar_Refresh(true);
		this.hasShowButton = false;
	}
	return true;
}

/***********************************************
 功能  提交保存附件，该操作调用控件的上传方法上传附件
 ***********************************************/
function _JG_Attachment_Submit() {
	this._setParamter();
	if (this.currentMode == 'add' || !this.trackRevisions || this.isTemplate) {
		this.ocxObj.ClearRevisions();
	}	
	var originFileName = this.ocxObj.fileName;
	var newFileName = this.ocxObj.fileName;
	/*if(this._isAfter2003()){
		newFileName = newFileName.substring(0,newFileName.length - 1);
		this.ocxObj.fileName = newFileName;
	}*/
	try{
		//this.ocxObj.fileName = encodeURIComponent(this.ocxObj.fileName);
		if (!this.ocxObj.WebSave(true)) {
			this.setStatusMsg(this.ocxObj.Status);
			//alert(this.ocxObj.Status);
			return false;
		}
		//刷新opener的附件列表
		var fdKeyFields ;
		try{
			fdKeyFields = window.opener.document.getElementsByName("attachmentKeyParam");
		}catch(e){
			fdKeyFields = document.getElementsByName("attachmentKeyParam");
		}
		if(fdKeyFields && originFileName!=newFileName){
			for(var i=0;i<fdKeyFields.length;i++){
				var value = fdKeyFields[i].value;
				if(window.opener["attachmentObject_"+value].isOnlineEdit){
					window.opener["attachmentObject_"+value].isOnlineEdit = false;
					window.opener["attachmentObject_"+value].refreshList(decodeURIComponent(originFileName),decodeURIComponent(newFileName));
				}
			}
		}
		this._writeAttachmentInfo();
		this.setStatusMsg(this.ocxObj.Status);
		return true;
	} catch (e) {
		alert("jg_submit error: " + e.description);
	}
	
}

/***********************************************
 功能  附件保存后调用该方法写入文档信息
 ***********************************************/
function _JG_Attachment_WriteAttachmentInfo() {
	var addIds = this.ocxObj.WebGetMsgByName("_fdAttMainId");
	if (addIds) {
		var addAttIds = document.getElementsByName("attachmentForms."
				+ this.fdKey + ".attachmentIds")[0];
		if (addAttIds != null) {
			addAttIds.value = addIds;
		}
	}
}

/***********************************************
 功能 判断是否office word
 ***********************************************/
function _JG_Attachment_IsWord() {
	try {
		if (this.ocxObj.WebObject.Application.Name.indexOf("Microsoft Word") >= 0) {
			return true;
		}
	} catch (e) {
		return false;
	}
	return false;
}
 
 /***********************************************
 功能 判断是否office Excel
 ***********************************************/
function _JG_Attachment_IsExcel() {
	try {
		if (this.ocxObj.WebObject.Application.Name.indexOf("Microsoft Excel") >= 0) {
			return true;
		}
	} catch (e) {
		return false;
	}
	return false;
}

/***********************************************
功能 判断是否office  2003以上版本
***********************************************/
function _JG_Attachment_IsAfter2003() {
		if (this.ocxObj.FileType.toLowerCase().lastIndexOf(".xlsx") > -1) {
			return true;
		}
		if (this.ocxObj.FileType.toLowerCase().lastIndexOf(".docx") > -1) {
			return true;
		}
	
	return false;
}

/***********************************************
功能 判断是否wps版本
***********************************************/
function _JG_Attachment_getWpsVersion() {
	var version = this.ocxObj.WebObject.Application.Build ;
	    if(version.substring(0,1)=='8'){
	    	alert(Attachment_MessageInfo["error.jgsupport"].replace("{0}","WPS2012"));
	    	return "2012";
	    }else if(version.substring(0,1)=='6'){
	    	return "2009";
	    }
}

/*******************************************************************************
 * 功能 保存为图片文档
 ******************************************************************************/
function JG_Attachment_saveAsImage() {
	//this.ocxObj.ClearRevisions(); // 清除所有留痕
	try {
		if (!this.ocxObj.WebSaveImage()) {
			this.setStatusMsg(this.ocxObj.Status);
			alert(this.ocxObj.Status);
			return false;
		}
		this.setStatusMsg(this.ocxObj.Status);
		return true;
	} catch (e) {
		alert("JG_Attachment_saveAsImage error: " + e.description);
	}
}

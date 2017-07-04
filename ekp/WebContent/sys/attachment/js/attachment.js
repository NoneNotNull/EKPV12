/*压缩类型：标准*/
/***********************************************
JS文件说明：
该文件提供了附件机制的操作函数

作者：陈志勇
版本：1.0 2007-9-25
***********************************************/
Com_RegisterFile("attachment.js");
Com_IncludeFile("data.js");
Com_IncludeFile("sysAttMain_MessageInfo.jsp?locale="+ Com_Parameter.__sysAttMainlocale__,Com_Parameter.ContextPath + "sys/attachment/sys_att_main/", 'js',true);
document.writeln("<script src="+Com_Parameter.ContextPath+"sys/attachment/js/flashviewer.js></script>");
var Attachment_ObjectInfo = new Array();
var FILE_EXT_OFFICE = "All Files (*.*)|*.*|Office Files|*.doc;*.xls;*.ppt;*.vsd;*.rtf;*.csv";
var FILE_EXT_PIC = "Picture Files|*.gif;*.jpg;*.jpeg;*.bmp;*.png;*.tif|All Files (*.*)|*.*";
var File_EXT_READ = ".doc;.xls;.mpp;.ppt;.xlc;.docx;.xlsx;.mppx;.pptx;.xlcx;.wps;.et";
var File_EXT_EDIT = ".doc;.xls;.mpp;.ppt;.xlc;.docx;.xlsx;.mppx;.pptx;.xlcx;.wps;.et";
if (typeof Attachment_MessageInfo == "undefined")
	Attachment_MessageInfo = new Array();
/***********************************************
功能  单个附件对象的构造函数
参数：
	fileName：
		必选，文件名，已经上传则为文件名称，未上传则带完整路径
	fdId:
		可选，以上传文件必填，为附件文档的ID
	isUpload：
		可选，是否已经上载，默认为true,已上载
	fileType:
		可选，文件类型
	csize：
		可选，文件大小
***********************************************/
function AttachmentDoc(fileName,fdId,isUpload,fileType,csize) {
	if(isUpload==null) isUpload = true;
	if(isUpload) {
		this.fileName = fileName;
		this.fileStatus = 1;		
	}else {
		var i= fileName.lastIndexOf("\\");
		if(i>0) {
			this.fileName = fileName.substring(i+1);
			this.localFile = fileName;
		}else {
			this.fileName = fileName;
			this.localFile = fileName;			
		}
		this.fileStatus = 0;
	}
	this.fileType = fileType;
	this.fdId = fdId;
	this.fileSize = csize;
}
/***********************************************
功能  附件对象的构造函数
参数：
	fdKey：
		必选，附件标识名称	
	fdModelName：
		必选，域模型名称
	fdModelId:
		可选，当前文档的fdId		
	fdMulti：
		可选，是否允许上传多个文件，默认为true
	fdAttType:
		可选，文件类型，pic或者byte,office ，默认为byte		
***********************************************/
function AttachmentObject(fdKey,fdModelName,fdModelId,fdMulti,fdAttType,editMode,divName) {
	//属性
	this.idCount = 0;					//新增附件编号
	this.fdKey = fdKey;					//附件的标识
	this.fdModelName = fdModelName;				//对应域模型
	this.fdId = fdModelId;					//文档ID
	if(fdMulti==null || fdMulti=="" || fdMulti=="true" || fdMulti=="1") fdMulti = true;
	else fdMulti = false;
	this.MulFile = fdMulti;
	if(fdAttType==null) fdAttType = "byte";
	if(divName==null) divName = "attachmentObject_"+fdKey;
	this.navName = divName;
	var attachmentObject = this;
	this.attType = fdAttType;
	this.fileList = new Array();
	this.fdImgHtmlProperty = null;
	this.showTable = null;
	this.ocxObj = null;
	this.disabled = false;
	this.fdShowMsg = true;
	if(editMode==null) editMode = Com_GetUrlParameter(location.href, "method");
	if(editMode=="edit" || editMode=="add") {
		this.canDelete = true;
		this.canRead = true;
		this.canDownload = true;
		this.canEdit = true;
		this.canPrint = true;
		this.canAdd = true;
	}else{
		this.canDelete = false;
		this.canRead = true;
		this.canDownload = false;
		this.canEdit = false;
		this.canPrint = false;
		this.canAdd = false;
	}
	this.canSaveDraft=true;
	this.canClear = true;
	this.hasShowButton = false;
	this.hasAddSubmitFun = false;
	this.showRevisions = false;
	this.downLoadPre = "";	
	this.editMode = editMode;
	this.uploadList = null;
	this.deleteList = null;
	this.hasPost = false;
	this.actionObj = null;
	this.singleMaxSize = 0;
	this.singleMaxSizeTxt = null;
	this.totalMaxSize = 0;
	this.totalMaxSizeTxt = null;
	this.totalSize = 0;
	this.uploadAfterSelect = false;
	this.enabledFileType = null;
	this.hiddenRevisions=true;
	this.isOnlineEdit = false;//在线编辑标志 limh 2011年8月16日
	//外部调用函数
	this.addDoc = Attachment_AddDoc;
	this.show = Attachment_ShowList;
	this.clear = Attachment_Clear;
	this.disabledObject = Attachment_Disabled;
	this.downloadAttachment = Attachment_DownloadAttachment;
	this.deleteAttachment = Attachment_DeleteAttachment;
	this.setSingleMaxSize = Attachment_SetSingleMaxSize;
	this.setTotalMaxSize = Attachment_SetTotalMaxSize;
	this.setBookmark = Attachment_SetBookmark;
		
	this.editDoc = Attachment_EditDoc;
	this.readDoc = Attachment_ReadDoc;
	this.openDoc = Attachment_OpenDoc;
	this.printDoc = Attachment_PrintDoc;
	this.refreshList = Attachment_RefreshList;//刷新列表 limh 2011年8月16日
	
	//内部函数
	this.addAttachment = Attachment_AddAttachment;
	this.writeAttachmentInfo = Attachment_WriteAttachmentInfo;
	this.deleteOneAttachment = Attachment_DeleteOneAttachment;
	this.getUrl = Attachment_GetUrl;	
	this.getDocumentById = Attachment_GetDocumentById;
	this.submitAttachment = Attachment_SubmitAttachment;
	this.uploadAttachmentAfterSelect = Attachment_UploadAttachmentAfterSelect;
	this.processReturn = Attachment_ProcessReturn;
	this.showMenu = Attachment_ShowMenu;
	this.showClear = Attachment_ShowClear;
	this.showTR = Attachment_ShowTR;
	this.buttonDiv = null;
	this.isTemplate = false;
	this.isSwfEnabled = false;
	this.showButton = Attachment_ShowButton;
	this.hideButton = Attachment_HideButton;
	this.getPicTR = Attachment_GetPicTR;
	this.drawSeletcAll = Attachment_DrawSeletcAll;
	this.selectAll = Attachment_SelectAll;
	this.getFileList = Attachment_GetFileList;
	this.formatSize = Attachment_FormatSize;
	this.parseSize = Attachment_ParseSize;
	this.appendReadFile = Attachment_AppendReadFile;
	this.resetReadFile = Attachment_ResetReadFile;
	//附件对象列表
	Attachment_ObjectInfo[fdKey] = this;
	//获取主表格
	this.getTable = function(showDiv) {
		if(this.showTable==null) {
			if(showDiv==null) showDiv = "_List_"+this.fdKey+"_Attachment_Table";
			if(typeof(showDiv)=="string") showDiv = document.getElementById(showDiv);
			this.showTable = showDiv;
		}
	}
	//获取控件对象
	this.getOcxObj = function(divName) {
		if(this.ocxObj==null) {
			if(divName==null) divName = "AttachmentOCX_"+this.fdKey;
			if(typeof(divName)=="string") this.ocxObj = document.getElementById(divName);
			else this.ocxObj = divName;
		}
		return (this.ocxObj==null?false:true);
	}
	//事件函数
	this.onQueryPost = null;
	this.onFinishPost = Attachment_OnFinishPost;
	this.onDownloadFinish = Attachment_OnDownloadFinish;
	//自定义事件
	this.onFinishPostCustom = null;
	this.onSubmitFinishCustom = null;
	this.onClickCustom = null; // 参数 doc 当前附件; 返回值 继续true 中断false
	this.showCustomMenu = null; // 自定义菜单 参数为当前menu
}
/************************以下为私有函数,外部请勿调用**********************/
/***********************************************
功能  添加一个附件对象
参数：
	fileName：
		必选，文件名，已经上传则为文件名称，未上传则带完整路径
	fdId:
		可选，以上传文件必填，为附件文档的ID
	isUpload：
		可选，是否已经上载，默认为true,已上载
	fileType:
		可选，文件类型
	csize：
		可选，文件大小
***********************************************/
function Attachment_AddDoc(fileName,fdId,isUpload,fileType,csize) {
	if (!isUpload && this.enabledFileType != null) { // 在此添加类型校验
		var ftype = fileName.substring(fileName.lastIndexOf("."), fileName.length);
		ftype = ftype.toLowerCase();
		var access = false;
		var types = this.enabledFileType.split("|");
		for (var i = 0; i < types.length; i ++) {
			if (types[i] == ftype) {
				access = true;
				break;
			}
		}
		if (!access) {
			alert(Attachment_MessageInfo["error.enabledFileType"].replace("{0}",this.enabledFileType));
			return false;
		};
	}
	if(fdId==null || fdId=="") {
		fdId = "upload_" + this.idCount;
		this.idCount++;
	}
	if(!isUpload){
		if(fileType==null) fileType = "?";
		for(var i=0;i<this.fileList.length;i++){
			if(this.fileList[i].fileStatus==0) {
				if(fileName==this.fileList[i].localFile) return false;
			}
		}
		if(csize==null) csize = this.ocxObj.getFileSize(fileName);

		if(this.singleMaxSize>0 && parseInt(csize)>this.singleMaxSize) {
			alert(Attachment_MessageInfo["error.exceedSingleMaxSize"].replace("{0}",fileName).replace("{1}",this.singleMaxSizeTxt));
			return 0;
		}
		if(this.totalMaxSize>0 && (this.totalSize+parseInt(csize))>this.totalMaxSize) {
			alert(Attachment_MessageInfo["error.exceedMaxSize"].replace("{0}",this.singleMaxSizeTxt));
			return -1;		
		}
	}
	if(!this.MulFile) {
		for(var i=0;i<this.fileList.length;i++) {
			if(this.fileList[i].fileStatus==0) this.fileList[i].fileStatus = -2;
			if(this.fileList[i].fileStatus==1) this.fileList[i].fileStatus = -1;
		}
		this.totalSize = 0;
	}
	var addDoc = new AttachmentDoc(fileName,fdId,isUpload,fileType,csize);
	this.fileList[this.fileList.length] = addDoc;
	this.totalSize = this.totalSize + parseInt(csize);
}
/***********************************************
功能  根据附件ID查找附件
参数：
	fdId:
		必填，附件文档的fdId
***********************************************/
function Attachment_GetDocumentById(fdId) {
	if(fdId==null || fdId=="") return null;
	for(var i=0;i<this.fileList.length;i++) {
		if(this.fileList[i].fdId==fdId) return this.fileList[i];
	}
	return null;
}

/***********************************************
功能  显示附件列表
参数：
***********************************************/
function Attachment_ShowList() {
	if(this.fdShowMsg) {
		this.showButton();
	}
	if(this.attType!="office") {
		this.getTable();
		if(this.showTable==null) return false;
		var tbody = this.showTable.getElementsByTagName("TBODY")[0];
		if (this.enabledFileType != null && this.enabledFileType != '') {
			this.showTable.title = Attachment_MessageInfo["error.enabledFileType"].replace(/\{0\}/, this.enabledFileType);
		}
		if(this.fdShowMsg) {
			this.showClear();
		}
		if(this.attType=='pic') {
			for(var i=0;i<this.fileList.length;i++) {
				if(this.fileList[i].fileStatus>-1) {
					tbody.appendChild(this.getPicTR(this.fileList[i]));
				}
			}
		}else if(this.fdShowMsg) {
			for(var i=0;i<this.fileList.length;i++) {
				if(this.fileList[i].fileStatus>-1) {
					tbody.appendChild(this.showTR(this.fileList[i]));
				}
			}
		}
		if(this.attType=='pic' && this.fileList.length==0 && this.showDefault) {
			tbody.appendChild(this.getPicTR());
		}
		if(this.fdShowMsg) {
			this.drawSeletcAll();
		}
	}
}

/***********************************************
功能  在线编辑修改文件名后刷新附件列表
参数：originFileName 源文件名
	  newFileName 修改后文件名 limh 2011年8月16日
***********************************************/
function  Attachment_RefreshList(originFileName,newFileName){
	for(var i=0;i<this.fileList.length;i++) {
		if(this.fileList[i].fileName ==originFileName) {
			this.fileList[i].fileName=newFileName;
		}
	}
	this.show();
}
/***********************************************
功能  显示选择所有的复选框
参数：
***********************************************/
function Attachment_DrawSeletcAll() {
	if(this.showCheckBox && !this.hasShowCheckBox) {
		var attachmentObject = this;
		var input = document.createElement("INPUT");
		input.type = "checkbox";
		input.value = "selectAll";
		input.name = "attach_"+this.fdKey+"_checkboxAll";
		input.id = input.name;
		input.onclick = function() {
			attachmentObject.selectAll(this.checked);			
		}
		var tbody = this.showTable.getElementsByTagName("TBODY")[0];
		var tr = tbody.getElementsByTagName("TR")[0];
		var td = tr.getElementsByTagName("TD")[0];
		td.appendChild(input);
		this.hasShowCheckBox = true;	
	}
}
/***********************************************
功能  显示所有或者不显示所有功能
参数：
	selected:是否选择所有，true 选择所有，false 不选择所有
***********************************************/
function Attachment_SelectAll(selected) {
	var checkBox =  document.getElementsByName("attach_"+this.fdKey+"_checkbox");
	if(checkBox!=null) {
		if(checkBox[0]==null) {
				checkBox.checked = selected;
		}else {
			for(var i=0;i<checkBox.length;i++) {
				checkBox[i].checked = selected;
			}
		}
	}
}
/***********************************************
功能  生成图片附件的显示单元格
参数：
	doc:图片附件对象
***********************************************/
function Attachment_GetPicTR(doc) {
	var row = document.createElement("TR");
	var imgExtend = "";
	if(this.fdImgHtmlProperty!=null && this.fdImgHtmlProperty!="")	imgExtend = this.fdImgHtmlProperty;			
    	var td1 = document.createElement("TD");
    	if(doc!=null) {
    		if(doc.fileStatus!=0)
    			var img = "<img src=\""+this.getUrl("downloadPic",doc.fdId)+"\" "+imgExtend+" border=0>";
    		else {
    			if (Com_Parameter.IE && parseFloat(navigator.appVersion.split("MSIE")[1]) >= 7) {
    				var _r_w = new RegExp("width=(\\\"|\\\'?)(\\d*)(\\\"|\\\')?","ig");
    				var _is_w = _r_w.exec(imgExtend);
    				var _s_w = parseInt(RegExp.$2);
    				
    				var _r_h = new RegExp("height=(\\\"|\\\'?)(\\d*)(\\\"|\\\')?","ig");
    				var _is_h = _r_h.exec(imgExtend);
    				var _s_h = parseInt(RegExp.$2);
    				
	    			var img = '<div style=\"filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=scale,src=\''
	    				+ doc.localFile + '\');width:' + _s_w + 'px;height:' + _s_h + 'px\"></div>';
    			} else {
    				var img = "<img src=\""+doc.localFile+"\" "+imgExtend+" border=0>";
    			}
    		}
    	}else
    		var img = "<img src=\""+this.getUrl("download","")+"\" "+imgExtend+" border=0>";
    	var pic = document.createElement(img); 
    	td1.appendChild(pic);
		if(this.fdShowMsg){
			td1.appendChild(document.createElement("BR"));
			if(doc!=null && (this.canDelete || this.canDownload)) {
				var input = document.createElement("INPUT");
			input.type = "checkbox";
			input.value = doc.fdId;
			input.name = "attach_"+this.fdKey+"_checkbox";
			input.id = input.name;
			input.fileName = doc.fileName;
			td1.appendChild(input);
			td1.appendChild(document.createTextNode(doc.fileName));
		}
	}
	if(doc!=null && this.fdShowMsg) 
    	td1.appendChild(document.createTextNode("(" + doc.fileSize+"byte)"));    		
	row.appendChild(td1);	
	return row;	
}

/***********************************************
功能  在线编辑时设置书签值
参数：
	name：必需 书签名称
	value：必需，书签的值
	
***********************************************/
function Attachment_SetBookmark(name,value){
	if(name==null||value==null) return false;
	if(name=="") return false;
	if(this.attType=="office"){
		if(this.getOcxObj()){
			if(this.ocxObj.isLoadDoc()){
				var word = this.ocxObj.ActiveDocument;
				var bookmarks = word.Bookmarks;
				if(bookmarks.Exists(name)){
					var bookmark = bookmarks.Item(name);
					var range = bookmark.Range;
					range.Text = value;
					range.Select();
					bookmarks.Add(name,range);
				}
				//return this.ocxObj.SetBookmark(name,value);
			}else{
				setTimeout(this.navName+".setBookmark(\""+name.replace("\"","\\\"")+"\",\""+value.replace("\"","\\\"")+"\")",1000);
				return true;
			}
		}
	}
	return false;
}

/***********************************************
功能  生成附件显示的单元格
参数：
	doc：必选，显示的附件文档
***********************************************/
function Attachment_ShowTR(doc) {	
	var attachmentObject = this;
	var row = document.createElement("TR");
	row.oncontextmenu = function() {return attachmentObject.showMenu(doc)}
	row.onclick = row.oncontextmenu;
	row.onmouseover = function()
	{
		this.style.backgroundColor="#cccccc";
		this.style.cursor = "pointer";
	}
	row.onmouseout = function()
	{
		this.style.backgroundColor="#ffffff";
	}	
	var td1 = document.createElement("TD");
	if((this.canDelete || this.canDownload) && this.getFileList()>0) {
		var input = document.createElement("INPUT");
		input.type = "checkbox";
		input.value = doc.fdId;
		input.name = "attach_"+this.fdKey+"_checkbox";
		input.id = input.name;
		input.fileName = doc.fileName;
		td1.appendChild(input);
		this.showCheckBox = true;			
	}else
		td1.appendChild(document.createTextNode(" "));
	row.appendChild(td1);
	var td1 = document.createElement("TD");
	td1.appendChild(document.createTextNode(doc.fileName));
	var td2 = document.createElement("TD");
	td2.appendChild (document.createTextNode(this.formatSize(doc.fileSize)));
	//var td3 = document.createElement("TD");
	//var fileType = doc.fileType;
	//var index = fileType.indexOf("/");
	//if(index>-1) fileType = fileType.substring(index+1);    		
	//td3.appendChild (document.createTextNode(fileType));
	row.appendChild(td1);
	row.appendChild(td2);
	//row.appendChild(td3);
	return row;
}
/***********************************************
功能  清除显示的内容，包括按钮，附件列表
参数：
***********************************************/
function Attachment_ShowClear() {
	this.getTable();
	if(this.showTable==null) return false;
	var tbody = this.showTable.getElementsByTagName("TBODY")[0];
	trList = tbody.getElementsByTagName("TR");
	if(trList.length>1) {
		for(var i=trList.length-1;i>0;i--)
			tbody.removeChild(trList[i]);
	}
	if(this.attType=='pic' && trList.length>0) tbody.removeChild(trList[0]);
}
/***********************************************
功能  生成附件的链接
参数：
	method:链接中的method参数值，
	fdId:附件的ID
	needHost:是否需要显示绝对路径
***********************************************/
function Attachment_GetUrl(method,fdId,needHost) {
	var host = "";
	if(needHost) host = location.protocol.toLowerCase()+"//" + location.hostname + ":" + location.port;
	return host + Com_Parameter.ContextPath + "sys/attachment/sys_att_main/sysAttMain.do?method=" + method + "&fdId=" + fdId;

}
/***********************************************
功能  显示操作按钮
***********************************************/
function Attachment_ShowButton() {
	var showDiv = this.buttonDiv;
	if(this.attType!="office") {	
		if(showDiv==null)
			showDiv = "_button_"+ this.fdKey + "_Attachment_TD";
		var obj = document.getElementById(showDiv);
		if(this.hasShowButton){
			this.hideButton(showDiv);
		}		
		var attachmentObject = this;
		if(this.canAdd) {
			var addButton = document.createElement("<input type=\"button\" class=\"btnopt\">");
	    		addButton.value= Attachment_MessageInfo["button.create"];
	    		addButton.name = this.fdKey+"_create";
	    		if (this.enabledFileType != null && this.enabledFileType != '') {
	    			addButton.title = Attachment_MessageInfo["error.enabledFileType"].replace(/\{0\}/, this.enabledFileType);
	    		}
			addButton.onclick=function(){
				attachmentObject.addAttachment();
			}
			obj.appendChild(addButton);
			obj.appendChild(document.createTextNode(" "));
		}
		if(this.canDelete && this.getFileList()>0) {
			var deleteButton = document.createElement("<input type=\"button\" class=\"btnopt\">");
	    		deleteButton.value= Attachment_MessageInfo["button.delete"];
	    		deleteButton.name = this.fdKey+"_delete";	
			deleteButton.onclick=function(){
				attachmentObject.deleteAttachment();
			}
			obj.appendChild(deleteButton);
			obj.appendChild(document.createTextNode(" "));
		}
		if(this.canDownload && this.getFileList(false)>0) {
			var downLoadButton = document.createElement("<input type=\"button\" class=\"btnopt\">");
	    		downLoadButton.value= Attachment_MessageInfo["button.download"];	
	    		downLoadButton.name = this.fdKey+"_download";
			downLoadButton.onclick=function(){
				attachmentObject.downloadAttachment();
			}
			obj.appendChild(downLoadButton);
			obj.appendChild(document.createTextNode(" "));
		}
	}else{
		if(this.hasShowButton) return true;
		if(showDiv==null){
			var obj = document.getElementById("_button_"+ this.fdKey + "_Attachment_TD");
			obj.style.textAlign = "right";
			obj.parentElement.parentElement.parentElement.style.width = "100%";
		}else{
			var obj = document.getElementById(showDiv);
		}
		var attachmentObject = this;
		// 取消非Word文档相关按钮显示，控件未支持这些功能
		var ocxObject = document.getElementById("AttachmentOCX_"+this.fdKey);
		var params = ocxObject ? ocxObject.getElementsByTagName('param') : [];
		var isShowOffBtn = true;
		var isShowOffOtherBtn=true;
		for (var i = 0, l = params.length; i < l; i ++) {
			if (params[i].name == 'FileName') {
				var fileName = params[i].value;
				if (fileName != null && fileName.length > 0){
					isShowOffBtn = '.doc|.docx|.ppt|.pptx|.xls|.xlsx'.indexOf(fileName.substring(fileName.lastIndexOf(".")).toLowerCase()) > -1;
					isShowOffOtherBtn = '.ppt|.pptx|.xls|.xlsx'.indexOf(fileName.substring(fileName.lastIndexOf(".")).toLowerCase()) > -1;
					}

			}
		}
		if(params.length==0){isShowOffOtherBtn=false;}
		if (isShowOffBtn) {
			if(!isShowOffOtherBtn){
			//隐藏显示留痕按钮
			var showRevisions = document.createElement("<input class=\"btnopt\" type=\"button\">");
			showRevisions.value = this.showRevisions?Attachment_MessageInfo["button.hideRevisions"]:Attachment_MessageInfo["button.showRevisions"];
			showRevisions.name = this.fdKey+"_showRevisions";
			showRevisions.onclick=function(){
				attachmentObject.getOcxObj();	
				if(attachmentObject.ocxObj.ShowRevisions(!attachmentObject.showRevisions)) {
					attachmentObject.showRevisions = !attachmentObject.showRevisions;
					showRevisions.value= attachmentObject.showRevisions?Attachment_MessageInfo["button.hideRevisions"]:Attachment_MessageInfo["button.showRevisions"];
					OptBar_Refresh();
				}
			}
			if(!this.isTemplate && Com_GetUrlParameter(location.href, "method") != 'add' &&this.hiddenRevisions){
				obj.insertAdjacentElement("afterBegin",showRevisions);
				var blank = document.createElement("SPAN");
	 
				blank.innerHTML = "&nbsp;&nbsp;";
				obj.insertAdjacentElement("afterBegin",blank);			
			}}
			if(this.editMode=="edit" || this.editMode=="add") {
				if(!isShowOffOtherBtn){
				//编辑页眉页脚
				var button = document.createElement("<input class=\"btnopt\" type=\"button\">");
				button.value= Attachment_MessageInfo["button.page"];
				button.name = this.fdKey+"_page";
				button.onclick=function(){
					attachmentObject.getOcxObj();
					attachmentObject.ocxObj.EditHeader();
				}
				obj.insertAdjacentElement("afterBegin",button);	
				blank = document.createElement("SPAN");
				blank.innerHTML = "&nbsp;&nbsp;";
				obj.insertAdjacentElement("afterBegin",blank);
				}
				//书签
				var button = document.createElement("<input class=\"btnopt\" type=\"button\">");
				button.value= Attachment_MessageInfo["button.bookmark"];
				button.name = this.fdKey+"_bookmark";
				button.onclick=function(){
					attachmentObject.getOcxObj();
					attachmentObject.ocxObj.EditBookmark();
				}
				obj.insertAdjacentElement("afterBegin",button);
				blank = document.createElement("SPAN");
				blank.innerHTML = "&nbsp;&nbsp;";
				obj.insertAdjacentElement("afterBegin",blank);				
			}
			if(this.canPrint) {
				//打印
				var button = document.createElement("<input class=\"btnopt\" type=\"button\">");
				button.value= Attachment_MessageInfo["button.print"];
				button.name = this.fdKey+"_print";
				button.onclick=function(){
					attachmentObject.getOcxObj();
					attachmentObject.ocxObj.EditPrint();
				}
				if(!this.isTemplate && Com_GetUrlParameter(location.href, "method") != 'add'){
					obj.insertAdjacentElement("afterBegin",button);
					blank = document.createElement("SPAN");
					blank.innerHTML = "&nbsp;&nbsp;";
					obj.insertAdjacentElement("afterBegin",blank);	
				}
				//打印预览
				if(!isShowOffOtherBtn){
				var button = document.createElement("<input class=\"btnopt\" type=\"button\">");
				button.value= Attachment_MessageInfo["button.printPreview"];
				button.name = this.fdKey+"_printPreview";
				button.onclick=function(){
					attachmentObject.getOcxObj();
					if(attachmentObject.isPrintPreview){
						attachmentObject.ocxObj.PrintPreviewExit();
						this.value= Attachment_MessageInfo["button.printPreview"];
					}else{
						attachmentObject.ocxObj.PrintPreview();
						this.value= Attachment_MessageInfo["button.exitPrintPreview"];
					}
					attachmentObject.isPrintPreview = !attachmentObject.isPrintPreview; 	
					OptBar_Refresh();				
				}
				}
				if(!this.isTemplate && Com_GetUrlParameter(location.href, "method") != 'add'){
					obj.insertAdjacentElement("afterBegin",button);
					blank = document.createElement("SPAN");
					blank.innerHTML = "&nbsp;&nbsp;";
					obj.insertAdjacentElement("afterBegin",blank);	
				}
			}
			//暂存
			if(this.canSaveDraft&&this.editMode=='edit'){
				 if(!this.isTemplate && (Com_GetUrlParameter(location.href, "method") == 'view'||Com_GetUrlParameter(location.href, "method") == 'edit')){//暂存按钮是否显示的判断条件
					var button= document.createElement("<input class=\"btnopt\" type=\"button\">");
					button.value = Attachment_MessageInfo["button.saveDraft"];
					button.name = this.fdKey + "_saveDraft";
					button.onclick=function(){  
						attachmentObject.hasPost=false;
						attachmentObject.canClear=false;
						attachmentObject.submitAttachment(false);
					}
					obj.insertAdjacentElement("afterBegin", button);
					blank = document.createElement("SPAN");
					blank.innerHTML = "&nbsp;&nbsp;";
					obj.insertAdjacentElement("afterBegin", blank);	
				 } 
		   }			
			if(this.canDownload) {
				if(!isShowOffOtherBtn){
				//下载（相当于另存为）
				var button = document.createElement("<input class=\"btnopt\" type=\"button\">");
				button.value= Attachment_MessageInfo["button.download"];
				button.name = this.fdKey+"_download";
				button.onclick=function(){
					attachmentObject.getOcxObj();
					attachmentObject.ocxObj.EditUnProtect();
					attachmentObject.ocxObj.AcceptRevisions(true);
					if(attachmentObject.ocxObj.EditSaveAs("")) {
						alert(Attachment_MessageInfo["msg.downloadSucess"]);
					}
				}}
				if(!this.isTemplate && Com_GetUrlParameter(location.href, "method") != 'add'){
					obj.insertAdjacentElement("afterBegin",button);
					blank = document.createElement("SPAN");
					blank.innerHTML = "&nbsp;&nbsp;";
					obj.insertAdjacentElement("afterBegin",blank);
				}
			}
			OptBar_Refresh(true);
		}
	}
	if(!this.hasAddSubmitFun && this.editMode!="view") {
		/*if(Com_Parameter.event["submit"].length>0){
			for(i=Com_Parameter.event["submit"].length;i>0;i--) {
				Com_Parameter.event["submit"][i] = Com_Parameter.event["submit"][i-1];
			}
		}
		Com_Parameter.event["submit"][0] = function() {return attachmentObject.submitAttachment()};*/
		// 2008-08-13 为了能让附件上传前提示操作错误，不用等待上传后再提示错误信息。 fyx
		//Com_Parameter.event["confirm"][Com_Parameter.event["confirm"].length] = function() {return attachmentObject.submitAttachment()};
		Com_Parameter.event["confirm"].unshift(function() {return attachmentObject.submitAttachment()});
		this.hasAddSubmitFun=true;
	}
	this.hasShowButton = true;	
}
/***********************************************
功能  隐藏操作按钮
参数：
	showDiv:按钮显示的位置，为元素的ID名称
***********************************************/
function Attachment_HideButton(showDiv) {
	if(!this.hasShowButton) return true; 
	if(showDiv==null)
		showDiv = this.buttonDiv;
	if(this.attType!="office") {
		if(showDiv==null) showDiv = "_button_"+ this.fdKey + "_Attachment_TD";		
	}else{
		if(showDiv==null) showDiv = "optBarDiv";
	}
	var obj = document.getElementById(showDiv);
	var nodes = obj.childNodes;
	for(var i=0;i<nodes.length;i++){if(nodes[i].name!=null && nodes[i].name.indexOf(this.fdKey+"_")==0) {obj.removeChild(nodes[i]);i--}}
	if(this.attType=="office") OptBar_Refresh(true);
	this.hasShowButton = false;
	return true;
}
/**

**/
/***********************************************
功能  隐藏/显示控件
参数：
	disabled:true隐藏控件，false显示控件
***********************************************/
function Attachment_Disabled(disabled){
	if(disabled==null) disabled = !this.disabled;
	if(disabled) {
		//隐藏
		this.hideButton();
		if(this.attType=="office") {if(this.getOcxObj()) this.ocxObj.style.display="none"}		
	}else{
		//显示
		this.showButton();
		if(this.attType=="office") {if(this.getOcxObj()) this.ocxObj.style.display=""}	
	}
	this.disabled = disabled;
}
/***********************************************
功能  删除选中的附件
参数：
***********************************************/
function Attachment_DeleteAttachment(){
	var hasSelect = false;
	if(this.canDelete) {	
		var checkBox =  document.getElementsByName("attach_"+this.fdKey+"_checkbox");
		if(checkBox!=null) {
			if(checkBox[0]==null) {
				if(checkBox.checked) {this.deleteOneAttachment(checkBox.value);hasSelect=true;}
			}else {
				for(var i=0;i<checkBox.length;i++) {
					if(checkBox[i].checked) {
						this.deleteOneAttachment(checkBox[i].value);
						hasSelect = true;
					}
				}
				if (!hasSelect)
					alert(Attachment_MessageInfo["msg.deleteNoChoice"]);
			}
		}
		var checkBox =  document.getElementById("attach_"+this.fdKey+"_checkboxAll");
		if(checkBox!=null)
			checkBox.checked = false;
	}
	if(hasSelect) this.show();
}
/***********************************************
功能  删除指定的单个附件
参数：fdId：删除的附件ID
      needRefresh：是否需要更新显示
***********************************************/
function Attachment_DeleteOneAttachment(fdId,needRefresh){
	if(fdId!=null && fdId!="") {
		var doc = this.getDocumentById(fdId);		
		if(doc!=null) {			
			if(doc.fileStatus==0) doc.fileStatus = -2;
			if(doc.fileStatus==1) doc.fileStatus = -1;
			this.totalSize = this.totalSize - parseInt(doc.fileSize);
			if(needRefresh) this.show();
		}
	}
}
/***********************************************
功能  文档保存前调用该方法写入文档信息
参数：
***********************************************/
function Attachment_WriteAttachmentInfo() {
	var delIds = "";
	var addIds = "";
	this.deleteList = new Array();
	for(var i=0;i<this.fileList.length;i++) {
		if(this.fileList[i].fileStatus==-1) {
			delIds = (delIds==""?"":delIds+";") + this.fileList[i].fdId;
			this.deleteList[this.deleteList.length] = this.fileList[i];
		}else if(this.fileList[i].fileStatus==1){
			addIds = (addIds==""?"":addIds+";") + this.fileList[i].fdId;
		}		
	}
	if(delIds!="") {
		var deletedAttids = document.getElementsByName("attachmentForms." + this.fdKey + ".deletedAttachmentIds")[0];
		 deletedAttids.value = delIds;
	}
	var addAttIds = document.getElementsByName("attachmentForms." + this.fdKey + ".attachmentIds")[0];
	if(addAttIds!=null) addAttIds.value = addIds;
	if(this.onSubmitFinishCustom!=null) this.onSubmitFinishCustom();
}
/***********************************************
功能  返回当前有效的附件个数
参数：includeAll 是否包含未上传的附件
***********************************************/
function Attachment_GetFileList(includeAll){
	if(includeAll==null) includeAll = true;
	var count =0;
	for(var i=0;i<this.fileList.length;i++) {
		if(this.fileList[i].fileStatus==1 || (includeAll &&this.fileList[i].fileStatus==0)) count++;
	}
	return count;

}
/***********************************************
功能  添加附件，弹出附件选中对话框
参数：
***********************************************/
function Attachment_AddAttachment() {
	if(this.canAdd) {
		this.getOcxObj();
		var selectList = this.ocxObj.SelectFiles(this.MulFile,this.attType=="pic"?FILE_EXT_PIC:FILE_EXT_OFFICE); //调用控件对象的选择文件方法
		if(selectList!="") {
			var fileArray = selectList.split(";");
			for(var i=0;i<fileArray.length;i++) {
				if(this.addDoc(fileArray[i],null,false)==-1) break;
			}
			this.show();
		}
		if(this.uploadAfterSelect) this.uploadAttachmentAfterSelect();
	}
}
/************************************************
功能 在对话框中选择附件后直接上传
参数：
*************************************************/
function Attachment_UploadAttachmentAfterSelect(){
	if(this.editMode=="view" || this.disabled) return true;
	this.actionObj = null;
	var ret = true;
	if(this.canAdd) {
		var uploadList = new Array();
		if(this.attType!="office") {
			for(var i=0;i<this.fileList.length;i++) {
				if(this.fileList[i].fileStatus==0)
					uploadList[uploadList.length] = this.fileList[i];
			}
		}
		if(uploadList.length>0 || this.attType=="office") {
			if(this.onQueryPost!=null){
				if(!this.onQueryPost(uploadList)) return false;
			}
			this.getOcxObj();		
			if(this.attType=="office" && !this.ocxObj.isLoadDoc()) return true;	
			this.ocxObj.PostInit(true);
			this.ocxObj.PostAddField("fdId"," ");
			this.ocxObj.PostAddField("fdModelId",this.fdId);
			this.ocxObj.PostAddField("fdModelName",this.fdModelName);
			this.ocxObj.PostAddField("fdKey",this.fdKey);
			this.ocxObj.PostAddField("fdAttType",this.attType);
			this.ocxObj.PostAddField("method_GET","upload");
			if(this.isTemplate){
				this.ocxObj.AcceptRevisions(true);
			}
			for(i=0; i<uploadList.length; i++) {
				this.ocxObj.PostAddFile(uploadList[i].localFile,"");
			}

			if(this.attType!="office") {
				var result = this.ocxObj.PostSend();				
			}else
				var result = this.ocxObj.EditSave();
			
			this.uploadList = (this.attType=="office"?this.fileList:uploadList);
			return this.processReturn(result);
		}		
	}
	this.writeAttachmentInfo();
	return true;
}

/***********************************************
功能  提交保存附件，该操作调用控件的上传方法上传所选附件
参数：
***********************************************/
function Attachment_SubmitAttachment(isCallBack) {
	if(this.editMode=="view" || this.disabled || this.hasPost) return true;
	if(isCallBack==null) isCallBack = true;
	
	if(isCallBack) {
		var actionObj = Com_GetEventObject();
		if(actionObj) {
			this.actionObj = actionObj.srcElement;		
		}
	}else this.actionObj = null;
	var ret = true;
	if(this.canAdd) {
		var uploadList = new Array();
		if(this.attType!="office") {
			for(var i=0;i<this.fileList.length;i++) {
				if(this.fileList[i].fileStatus==0)
					uploadList[uploadList.length] = this.fileList[i];
			}
		}
		if(uploadList.length>0 || this.attType=="office") {
			if(this.onQueryPost!=null){
				if(!this.onQueryPost(uploadList)) return false;
			}
			this.getOcxObj();		
			if(this.attType=="office" && !this.ocxObj.isLoadDoc()) return true;	
			this.ocxObj.PostInit(true);
			this.ocxObj.PostAddField("fdId"," ");
			this.ocxObj.PostAddField("fdModelId",this.fdId);
			this.ocxObj.PostAddField("fdModelName",this.fdModelName);
			this.ocxObj.PostAddField("fdKey",this.fdKey);
			this.ocxObj.PostAddField("fdAttType",this.attType);
			this.ocxObj.PostAddField("method_GET","upload");
			if(this.isTemplate){
				this.ocxObj.AcceptRevisions(true);
			}
			for(i=0; i<uploadList.length; i++) {
				this.ocxObj.PostAddFile(uploadList[i].localFile,"");
			}

			if(this.attType!="office") {
				var result = this.ocxObj.PostSend();				
			}else
				var result = this.ocxObj.EditSave();
			
			this.uploadList = (this.attType=="office"?this.fileList:uploadList);
			return this.processReturn(result);
		}		
	}
	this.writeAttachmentInfo();
	return true;
}

/***********************************************
功能：下载指定的附件
参数：fdId 下载附件的ID
***********************************************/
function Attachment_DownloadAttachment(fdId) {	
	var downloadUrl="";
	var saveFile="";	
	if(fdId==null) {
		var checkBox =  document.getElementsByName("attach_"+this.fdKey+"_checkbox");
		if(checkBox!=null) {
			for(var i=0;i<checkBox.length;i++) {
				if(checkBox[i].checked) {
					var doc = this.getDocumentById(checkBox[i].value);
					if(doc.fileStatus==0) {checkBox[i].checked=false;continue;}
					if(downloadUrl=="") {
						downloadUrl = this.getUrl("download",checkBox[i].value,true);
						saveFile = checkBox[i].fileName;
					}else{
						downloadUrl += ";" + this.getUrl("download",checkBox[i].value,true);
						saveFile += ";" + checkBox[i].fileName;
					}
				}
			}
		}
	}else{
		var doc = this.getDocumentById(fdId);
		if(doc!=null) {
			downloadUrl = this.getUrl("download",fdId,true);
			saveFile = doc.fileName;
		}
	}
	if(downloadUrl!="") {
		this.getOcxObj();
		if(this.ocxObj.getDownLoadStatus()!=1){
			if(downloadUrl.indexOf(";")>0) {
				retV = this.ocxObj.downLoadFiles(downloadUrl,"",saveFile,true,true);
			}else {
				retV = this.ocxObj.SaveAS(downloadUrl,"",saveFile,"1",true);
			}
			this.onDownloadFinish();
		}
	}else alert(Attachment_MessageInfo["msg.noChoice"]);
}

/***********************************************
功能：上传返回数据处理，上传完成后调用该函数进行处理
参数：xmlContent：返回的xml对象
***********************************************/
function Attachment_ProcessReturn(xmlContent) {
	if(xmlContent==null||xmlContent==""){
		var xmlContent = this.ocxObj.getUploadResult();
		if(xmlContent==""){
			if(this.actionObj!=null) this.actionObj.disabled = true;		
			setTimeout("Attachment_ObjectInfo['"+this.fdKey+"'].processReturn()",500);
			return false;
		}
	}

	var uploadList = this.uploadList;
	var kmssData = new KMSSData();
	var i;
	if((i=xmlContent.indexOf("<dataList>"))>0){
		xmlContent = xmlContent.substring(i);
	}else if(i<0){
		var errwin = window.open("","_blank");
		errwin.document.body.innerHTML = xmlContent
		if(this.actionObj!=null) this.actionObj.disabled = false;
		return false;
	}
	if((i=xmlContent.indexOf("</dataList>"))!=(xmlContent.length-11)){
		xmlContent = xmlContent.substring(0,i+11);
	}
	kmssData.AddXMLContent(xmlContent);
	var dataList = kmssData.GetHashMapArray();
	if(dataList.length>0) {
		if(dataList[0]["message"]!="") {
			alert(dataList[0]["message"]);
			return false;
		}else{ 
			// begin 在线编辑文档后，docx不变成了doc必须更新父窗口的列表的文件名称。
			try{
				if(dataList.length == 2 && this.attType == "office" && window.opener && window.opener["attachmentObject_"+this.fdKey]){
					var oldFileName = window.opener["attachmentObject_"+this.fdKey].getDocumentById(dataList[1]["fdId"]).fileName; 
					if(oldFileName != dataList[1]["fdFileName"]){
						window.opener["attachmentObject_"+this.fdKey].getDocumentById(dataList[1]["fdId"]).fileName = dataList[1]["fdFileName"];
					}
				}
			}catch(e){}
			// end 在线编辑文档后，docx不变成了doc必须更新父窗口的列表的文件名称。
			for(var i=1;i<dataList.length;i++) {
				for(var j=0;j<uploadList.length;j++) {
					if(dataList[i]["fdFileName"]==uploadList[j].fileName) {
						uploadList[j].fileStatus = 1;
						uploadList[j].fileType = dataList[i]["fdContentType"];
						uploadList[j].fdId = dataList[i]["fdId"];
						uploadList[j].fileSize = dataList[i]["fdSize"];						
						break;
					}
				}
				if(j==uploadList.length) 
					this.addDoc(dataList[i]["fdFileName"],dataList[i]["fdId"],true,dataList[i]["fdContentType"],dataList[i]["fdSize"]);
			}	

		}
		this.hasPost = true;
		this.writeAttachmentInfo();
		if(this.attType!="office") this.show();
		else if (this.canClear) this.clear();
		if(this.onFinishPostCustom!=null){
			this.onFinishPostCustom(uploadList);
		}
		//为和原附件机制兼容,增加afterAttachmentUploadEvent事件的处理
		if(window.afterAttachmentUploadEvent!=null){
			for(var j=0;j<uploadList.length;j++) {
				if(uploadList[j].fileStatus == 1) {
					afterAttachmentUploadEvent(uploadList[j].fdId);
				}
			}
		}
		this.onFinishPost();	
	}	
	return true;
}
/***********************************************
功能：显示单个附件对象的右键菜单
参数：doc 附件对象
***********************************************/
function Attachment_ShowMenu(doc) {
	if(event.srcElement.tagName=="INPUT") return true;
	if (this.onClickCustom && !this.onClickCustom(doc)) return false;
	var rm = new RightMenuObject(120);
	var fileExt = doc.fileName.substring(doc.fileName.lastIndexOf("."));	
	if(doc.fileStatus==1 && this.canRead) {
		if(File_EXT_READ.indexOf(fileExt.toLowerCase())>-1)
			rm.AddItem(Attachment_MessageInfo["button.read"],this.navName+".readDoc","'"+doc.fdId+"'");
		else if (doc.fileStatus==1 && this.canRead) {
			rm.AddItem(Attachment_MessageInfo["button.open"],this.navName+".openDoc","'"+doc.fdId+"','"+doc.fileName+"'");
			// 修改为直接打开
			//rm.AddItem(Attachment_MessageInfo["button.open"],"window.open","'"+ this.getUrl("download",doc.fdId)+"'");
//			rm.AddItem(Attachment_MessageInfo["button.open"],"location.replace","'"+ this.getUrl("readDownload",doc.fdId)+"'");
		}
	}
	if(doc.fileStatus==1 && this.canPrint){
		rm.AddItem(Attachment_MessageInfo["button.print"],this.navName+".printDoc","'"+doc.fdId+"','"+doc.fileName+"'");
	}
	if(doc.fileStatus==1 && this.canEdit) {
		if(File_EXT_EDIT.indexOf(fileExt.toLowerCase())>-1)
			rm.AddItem(Attachment_MessageInfo["button.edit"],this.navName+".editDoc","'"+doc.fdId+"'");
	}
	if(doc.fileStatus==1 && this.canDownload) rm.AddItem(Attachment_MessageInfo["button.download"],this.navName+".downloadAttachment","'"+doc.fdId+"'");
	if(this.canDelete) rm.AddItem(Attachment_MessageInfo["button.delete"],this.navName+".deleteOneAttachment","'"+doc.fdId+"',true");
	if(this.showCustomMenu) this.showCustomMenu(rm);
	rm.Show();
	return false;
}
function Attachment_PrintDoc(fdId,fileName) {
	if(fdId) { 
		var doc = this.getDocumentById(fdId);
		var url = this.getUrl("print",fdId);
		url = Com_SetUrlParameter(url,"sourceObj",this.navName);
		url = Com_SetUrlParameter(url,"fdKey",this.fdKey);
		url = Com_SetUrlParameter(url,"fdFileName",doc.fileName);
		Com_OpenWindow(url,"_blank","top=0,left=0,resizable=yes");		 
	}
}
/***********************************************
功能：附件对象的右键菜单的编辑操作
参数：fdId 操作的附件对象ID
***********************************************/
function Attachment_EditDoc(fdId) {
	if(fdId) {
		var doc = this.getDocumentById(fdId);
		var url = this.getUrl("edit",fdId);
		url = Com_SetUrlParameter(url,"fdFileName",doc.fileName);
		url = Com_SetUrlParameter(url,"fdKey",this.fdKey);
		Com_OpenWindow(url,"_blank","top=0,left=0,resizable=yes");
		this.isOnlineEdit = true;
	}
}
/***********************************************
功能：附件对象的右键菜单的阅读操作
参数：fdId 操作的附件对象ID
***********************************************/
function Attachment_ReadDoc(fdId,opera) {
	if(fdId) {
		var doc = this.getDocumentById(fdId);
		var url = this.getUrl("view",fdId);
		url = Com_SetUrlParameter(url,"sourceObj",this.navName);
		url = Com_SetUrlParameter(url,"fdKey",this.fdKey);
		url = Com_SetUrlParameter(url,"fdFileName",doc.fileName);
		opera=(opera==null?"_blank":opera);
		if(this.isSwfEnabled){
			attachmentDocShow(doc.fileName,url,fdId);
		}else{
			Com_OpenWindow(url,opera,"top=0,left=0,resizable=yes");
		}
	}	
}
/***********************************************
功能：附件对象的右键菜单的打开操作
参数：fdId 操作的附件对象ID，filename 打开的文件名称
***********************************************/
function Attachment_OpenDoc(fdId,fileName) {
	if(fdId) {
		var doc = this.getDocumentById(fdId);
		var url = this.getUrl("readDownload",fdId,true)+"&fileName="+fileName;
		this.getOcxObj();
		//修改为直接打开 limh 2011年8月17日
		//if (this.ocxObj.SaveAs(url, "", fileName, "")) {
			this.ocxObj.ExecuteFile(url);
		//}
	}	
}

/***********************************************
功能：格式化文件大小的显示格式
参数：fdId 操作的附件对象ID，filename 打开的文件名称
***********************************************/
function Attachment_FormatSize(filesize){
	var result = "";
	var index;
	if(filesize!=null && filesize!="") {
		if((index=filesize.indexOf("E"))>0) {			
			var size = parseFloat(filesize.substring(0,index))*Math.pow(10,parseInt(filesize.substring(index+1)));
		}else
			var size = parseInt(filesize);
		if(size<1024) 
			result = size + "B";
		else{
			var size = Math.round(size*100/1024)/100;
			if(size<1024)
				result = size + "KB";
			else{
				var size = Math.round(size*100/1024)/100;
				if(size<1024)
					result = size + "M";
				else {
					var size = Math.round(size*100/1024)/100;
					result = size + "G";
				}
			}
		}
	}
	return result;
}
/****************************************
功能：格式化大小
参数：maxSize 大小
****************************************/
function Attachment_ParseSize(maxSize) {
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
}

/********************************************************************
功能：清除控件的显示
*********************************************************************/
function Attachment_Clear(){
	this.getOcxObj();
	if(this.ocxObj!=null){
		this.ocxObj.Close();
		Com_SetOuterHTML(this.ocxObj, "");
	}
}
/********************************************************************
功能：提交完成后执行函数
*********************************************************************/
function Attachment_OnFinishPost(){
	if(this.actionObj!=null) {
		this.actionObj.disabled = false;
		this.actionObj.click();
	}
}
/*****************************************
功能：下载完成后执行函数
*******************************************/
function Attachment_OnDownloadFinish() {
	if(this.ocxObj.getDownLoadStatus()==1){
		setTimeout("Attachment_ObjectInfo['"+this.fdKey+"'].onDownloadFinish()",500);
		return false;
	}
	if(this.ocxObj.getDownLoadStatus()==2){
		alert(Attachment_MessageInfo["msg.downloadSucess"]);
		return true;
	}
	return false;
}
/***************************************
功能：设置单个附件大小控制
参数：maxSize 大小
****************************************/
function Attachment_SetSingleMaxSize(maxSize) {
	this.singleMaxSizeTxt = maxSize;
	this.singleMaxSize = this.parseSize(maxSize);
}
/*****************************************
功能：设置总体附件大小控制
参数：maxSize 大小
******************************************/
function Attachment_SetTotalMaxSize(maxSize) {
	this.totalMaxSizeTxt = maxSize;
	this.totalMaxSize = this.parseSize(maxSize);
}

/*******************************************************************************
 * 功能：增加阅读后缀名文件 
 * 参数：extensions 后缀名
 ******************************************************************************/
function Attachment_AppendReadFile(extensions) {
	if (File_EXT_READ.indexOf(extensions) == -1) {
             File_EXT_READ+=";."+extensions;
	}
}

/*******************************************************************************
 * 功能: 重置阅读后缀名文件 
 * 参数：extensions 后缀名
 ******************************************************************************/
function Attachment_ResetReadFile(extensions) {
	if (extensions) {
		File_EXT_READ = extensions;
	}
}

function Attachment_OpenOnload(){
	var attachmentId = Com_GetUrlParameter(location.href, "s_ftAttId");
	if(attachmentId!="" && attachmentId!=null){
		for ( var tmpKey in Attachment_ObjectInfo) {
			var openAtt=Attachment_ObjectInfo[tmpKey].getDocumentById(attachmentId);
			if(openAtt!=null){
				var fileExt=openAtt.fileName.substring(openAtt.fileName.lastIndexOf("."));
				if(File_EXT_READ.indexOf(fileExt.toLowerCase())>-1)
					Attachment_ObjectInfo[tmpKey].readDoc(attachmentId,"_self");
				else
					location=Attachment_ObjectInfo[tmpKey].getUrl("readDownload",attachmentId)
				break;
			}
		}
	}
}

Com_AddEventListener(window, "load", Attachment_OpenOnload);
/*******************************************************************************
 * JS文件说明： 该文件提供了金格在线阅读PDF的操作函数
 ******************************************************************************/
Com_IncludeFile("common.js");
Com_IncludeFile("sysAttMain_MessageInfo.jsp?locale="+ Com_Parameter.__sysAttMainlocale__,Com_Parameter.ContextPath + "sys/attachment/sys_att_main/", 'js',true);
(function(window) {
	function JG_PDF() {
		// 公用函数
		this.create = JG_PDF_Create;
		this.setOtherParamter = JG_SetOtherParamter;
		this.pdfUnLoad = JG_UnLoad;
		this.pdfLoad = JG_Load;
		this.statusMsg = JG_StatusMsg;
		this.pdfObject = null;
		this.fullSize = JG_FullSize;
		this.canPrint = false;
		this.canCopy = false;
		this._toolsEnable = JG_ToolsEnable;
		this._showBtn = JG_ShowButton;
	}
	/********************************************
	 功能：获取当前DNS
	 ********************************************/
	function Com_GetCurDns(){
		var host = location.protocol.toLowerCase()+"//" + location.hostname;
		if(location.port!='' && location.port!='80'){
			host = host+ ":" + location.port;
		}
		return host;
	}
	/***************************************************************************
	 * 创建JG_PDF_Object
	 */
	function JG_PDF_Create(fdId, fdKey, fdModelName, fdModelId, fdAttType,
			divName, fileName) {
		if (divName == null) {
			divName = "JGWebPdf_" + fdKey;
		}
		this.pdfObject = document.getElementById(divName);
		this.pdfObject.WebUrl = Com_GetCurDns() + Com_Parameter.ContextPath
		+ "sys/attachment/sys_att_main/jg_service.jsp";
		this.pdfObject.RecordID = fdModelId;
		this.pdfObject.FileName = fileName;
		this.pdfObject.Language = Attachment_MessageInfo["info.JG.lang"];// 语言
		this.setOtherParamter(fdModelName, fdKey, fdId, fdAttType);
		this.pdfObject.ShowTools = 1; // 工具栏可见（1,可见；0,不可见）
		this.pdfObject.SaveRight = 0; // 是否允许保存当前文档（1,允许；0,不允许）
		this.pdfObject.PrintRight = 1; // 是否允许打印当前文档（1,允许；0,不允许）
		this.pdfObject.AlterUser = false; // 是否允许由控件弹出提示框 true表示允许
		this.pdfObject.ShowMarks = 0; // 是否显示书签树按钮（1,显示；0,不显示）
		this.pdfObject.ShowSigns = 0; // 设置签章工具栏当前是否可见（1,可见；0,不可见）
		this.pdfObject.ShowMarks = 0; // 是否显示书签树(1,可见；0,不可见)
		this.pdfObject.ShowState = 1; // 是否显示状态栏(1,可见；0,不可见)
		this.pdfObject.ShowMenus = 0; // 是否显示菜单(1,可见；0,不可见)
		this.pdfObject.PrnScreen = false; // 禁止用户截屏
		this.pdfObject.EnableTools(
				'打开文档;保存文档;打印文档;文本选择;软件配置;文档属性;快照工具;关闭文档;关于金格;签章参数', 2); // 是否显示工具栏中（0禁用；1启用；2隐藏）
		this.pdfObject.SideWidth = 100; // 设置侧边栏的宽度
	}
	/***************************************************************************
	 * 设置其他参数
	 */
	function JG_SetOtherParamter(fdModelName, fdKey, fdId, fdAttType) {
		this.pdfObject.WebSetMsgByName("_fdModelName", fdModelName);
		this.pdfObject.WebSetMsgByName("_fdKey", fdKey);
		this.pdfObject.WebSetMsgByName("_fdId", fdId);
		this.pdfObject.WebSetMsgByName("_attType", fdAttType);
	}
	/***************************************************************************
	 * 加载控件
	 */
	function JG_Load() {
		try {
			this.pdfObject.WebOpen(); // 打开该文档
			this.pdfObject.Zoom = -2; // 缩放比例
			this.pdfObject.CurPage = 1; // 当前显示的页码
			if (this.canCopy) {
				this._toolsEnable('文本选择', true);
			} else {
				this._toolsEnable('文本选择', false);
			}
			this._showBtn();
			JG_StatusMsg(this.pdfObject.Status);
		} catch (e) {
			JG_StatusMsg(e.description); // 显示出错误信息
		}
	}

	/***************************************************************************
	 * 作用：退出iWebPDF
	 */
	function JG_UnLoad() {
		try {
			if (!this.pdfObject.WebClose()) {
				JG_StatusMsg(this.pdfObject.Status);
			} else {
				JG_StatusMsg("关闭文档...");
			}
		} catch (e) {
			JG_StatusMsg(e.description);
		}
	}
	/***************************************************************************
	 * 作用：设置具体工具的有效性
	 */
	function JG_ToolsEnable(type, isEnable) {
		if (isEnable) {
			this.pdfObject.EnableTools(type, 1);
		} else {
			this.pdfObject.EnableTools(type, 2);
		}
	}
	/***************************************************************************
	 * 作用：满屏显示
	 */
	function JG_FullSize() {
		this.pdfObject.FullSize();
	}
	/***************************************************************************
	 * 作用：显示操作状态
	 */
	function JG_StatusMsg(mString) {
		window.status = mString;
	}
	/***************************************************************************
	 * 显示按钮
	 */
	function JG_ShowButton() {
		var obj = document.getElementById("optBarDiv");
		var attachmentObject = this;
		var _insertDomBefore = function(insertTo,insertObj){
			if(insertTo.firstChild!=null){
				insertTo.insertBefore(insertObj,insertTo.firstChild); 
			}else{
				insertTo.appendChild(insertObj);
			}
		};
		if (this.canPrint && this.pdfObject.PrintStatus) {
			// 打印按钮
			var _printButton = document
					.createElement("input");
			_printButton.setAttribute("type","button");
			_printButton.value = Attachment_MessageInfo["button.print"];
			_printButton.name = this.fdKey + "_print";
			_printButton.onclick = function() {
				attachmentObject.pdfObject.WebPrint(0, "", 0, 0, true);
			};
			_insertDomBefore(obj,_printButton);
		}
	}
	window.JG_PDFObject = new JG_PDF();
})(window);
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
</head>
<script type="text/javascript">
Com_IncludeFile("data.js");
Com_IncludeFile("treeview.js");
</script>
<script type="text/javascript">
var dialogRtnValue = null;
var dialogObject=null;
/*if(window.showModalDialog){
	dialogObject = window.dialogArguments;
}else{
	dialogObject = parent.Com_Parameter.Dialog;
}*/
dialogObject = window.opener.Com_Parameter.Dialog.data;

dialogObject.url = "${KMSS_Parameter_ContextPath}${param.url}";
dialogObject.showOption = true;
dialogObject.valueData = dialogObject._keyName;
dialogObject.winTitle = "选择";
dialogObject.mulSelect = false;
//alert("${param.springBean}&serviceBean="+ dialogObject._source+",url=${param.url}");
dialogObject.tree = new TreeView("LKSTree","函数");
var node = dialogObject.tree.treeRoot;
node.AppendBeanData(
	"${param.springBean}&serviceBean=${param.infoBean}&selectId=!{value}&type=cate",
	"${param.springBean}&serviceBean=${param.infoBean}&selectId=!{value}&type=func"
);
node.parameter="tibCommonMappingControlTreeBean&serviceBean=${param.infoBean}&selectId=!{value}&type=func";
</script>
<script type="text/javascript">
initComParameter();
function initComParameter(){
	var style = Com_GetUrlParameter(location.href, "s_css");
	if(style==null || style==""){
		var aCookie = document.cookie.split("; ");
		for (var i=0; i<aCookie.length; i++){
			var aCrumb = aCookie[i].split("=");
			if ("KMSS_Style" == aCrumb[0]){
				style = aCrumb[1];
				break;
			}
		}
	}
	if(style==null || style=="")
		style = "default";
	Com_Parameter.Style = style;
	Com_Parameter.StylePath = "../style/"+style+"/";
	Com_Parameter.DialogLang = new Object();
	var langArr = Data_GetResourceString("button.ok;button.cancel;dialog.selectNone;message.keyword;dialog.requiredKeyword;"+
		"button.search;button.clear;dialog.optList;dialog.selList;dialog.add;"+
		"dialog.delete;dialog.addAll;dialog.deleteAll;dialog.moveUp;dialog.moveDown;"+
		"dialog.description;dialog.currentValue;dialog.requiredSelect;tib-common-mapping:tibCommonMapping.control.updateFunc;"+
		"tib-common-mapping:tibCommonMapping.control.requiredFuncSelect;tib-common-mapping:tibCommonMapping.control.requiredCateSelect;"+
		"tib-common-mapping:tibCommonMapping.control.addFunc");
	Com_Parameter.DialogLang.btnOk = langArr[0]==null?"OK":langArr[0];
	Com_Parameter.DialogLang.btnCancel = langArr[1]==null?"Cancel":langArr[1];
	Com_Parameter.DialogLang.btnSelectNone = langArr[2]==null?"SelectNone":langArr[2];
	Com_Parameter.DialogLang.keyword = langArr[3]==null?"Keyword":langArr[3];
	Com_Parameter.DialogLang.requiredKeyword = langArr[4]==null?"Keyword could not be empty!":langArr[4];

	Com_Parameter.DialogLang.btnSearch = langArr[5]==null?"Search":langArr[5];
	Com_Parameter.DialogLang.btnClear = langArr[6]==null?"Clear":langArr[6];
	Com_Parameter.DialogLang.optList = langArr[7]==null?"Options":langArr[7];
	Com_Parameter.DialogLang.selList = langArr[8]==null?"Selected":langArr[8];
	Com_Parameter.DialogLang.btnAdd = langArr[9]==null?"Add":langArr[9];

	Com_Parameter.DialogLang.btnDelete = langArr[10]==null?"Remove":langArr[10];
	Com_Parameter.DialogLang.btnAddAll = langArr[11]==null?"Add All":langArr[11];
	Com_Parameter.DialogLang.btnDeleteAll = langArr[12]==null?"Remove All":langArr[12];
	Com_Parameter.DialogLang.btnMoveUp = langArr[13]==null?"Up":langArr[13];
	Com_Parameter.DialogLang.btnMoveDown = langArr[14]==null?"Down":langArr[14];
	
	Com_Parameter.DialogLang.description = langArr[15]==null?"Description: ":langArr[15];
	Com_Parameter.DialogLang.currentValue = langArr[16]==null?"":langArr[16];
	Com_Parameter.DialogLang.requiredSelect = langArr[17]==null?"Please select a value!":langArr[17];
	Com_Parameter.DialogLang.updateFunc = langArr[18]==null?"update":langArr[18];
	Com_Parameter.DialogLang.requiredFuncSelect = langArr[19]==null?"Please select a value!":langArr[19];
	Com_Parameter.DialogLang.requiredCateSelect = langArr[20]==null?"Please select a category!":langArr[20];
	Com_Parameter.DialogLang.addFunc = langArr[21]==null?"add":langArr[21];
}

Com_AddEventListener(window, "beforeunload", beforeClose);
function Com_DialogReturn(value){
	if (value != null && value.length != 0) {
		var returnJson = {"_key" : dialogObject._source +"_"+ value[0] ,"_keyName" : value[1]};
		dialogRtnValue = returnJson;
	}
	close();
}
function beforeClose(){
	//window.returnValue = dialogRtnValue;
	var callback = window.opener.Com_Parameter.Dialog.AfterShow;
	if (callback) {
		callback(dialogRtnValue);
	}
}
if(dialogObject.winTitle!=null)
	document.title = dialogObject.winTitle;
function getHtmlContent(){
	var dialogType = dialogObject.mulSelect?"mul":"sgl";
	/*if(dialogObject.tree==null){
		return '<FRAMESET cols="*" framespacing=1 bordercolor=#003048 frameborder=1>' +
			'<FRAME name=optFrame frameborder=0 src="dialog_'+dialogType+'.html">' +
			'</FRAMESET>';
	}*/
	if(dialogObject.showOption){
		return '<FRAMESET cols="180,*" framespacing=1 bordercolor=#003048 frameborder=1>' +
			'<FRAME name=treeFrame frameborder=0 src="dialog_tree.jsp">' +
			'<FRAME name=optFrame frameborder=0 src="dialog_'+dialogType+'.jsp">' +
			'</FRAMESET>';
	}
	/*if(dialogObject.mulSelect){
		return '<FRAMESET cols="*,*" framespacing=1 bordercolor=#003048 frameborder=1>' +
			'<FRAME name=treeFrame frameborder=0 src="dialog_tree_mul.html"> ' +
			'<FRAME noresize scrolling=no name=optFrame frameborder=0 src="dialog_confirm_mul.html">'+
			'</FRAMESET>';
	}
	return '<FRAMESET rows="*,75" framespacing=1 bordercolor=#003048 frameborder=1>' +
		'<FRAME name=treeFrame frameborder=0 src="dialog_tree_sgl.html"> ' +
		'<FRAME noresize scrolling=no name=optFrame frameborder=0 src="dialog_confirm_sgl.html">'+
		'</FRAMESET>';*/
}
document.write(getHtmlContent());
</script>
</html>
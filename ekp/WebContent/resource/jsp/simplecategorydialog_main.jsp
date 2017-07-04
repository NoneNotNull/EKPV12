<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/dialog_htmlhead.jsp" %>
<script>
var dialogRtnValue = null;
var dialogObject=null;
if(window.showModalDialog)
	dialogObject = window.dialogArguments;
else{
	dialogObject = opener.Com_Parameter.Dialog;
}

Com_Parameter.XMLDebug = dialogObject.XMLDebug;
Com_AddEventListener(window, "beforeunload", beforeClose);
function Com_DialogReturn(value){
	dialogRtnValue = value;
	close();
}
function beforeClose(){
	dialogObject.rtnData = dialogRtnValue;
	dialogObject.AfterShow();
}
if(dialogObject.winTitle!=null) {
	Com_SetWindowTitle(dialogObject.winTitle);
}else{
	Com_SetWindowTitle("<bean:message key="dialog.window.title" bundle="sys-simplecategory"/>");
}
Com_Parameter.DialogLang = {
	btnOk:"<bean:message key="button.ok"/>",
	btnCancel:"<bean:message key="button.cancel"/>",
	btnSelectNone:"<bean:message key="dialog.selectNone"/>",
	currentValue:"<bean:message key="dialog.currentValue"/>"
}

window.onload = function() {
    document.getElementsByName("treeFrame")[0].src="syssimplecategorydialog.jsp?s_css=${fn:escapeXml(param.s_css)}&modelName="+dialogObject.modelName;
}

</script>
</head>
<FRAMESET rows="*,75" framespacing=1 bordercolor=#003048 frameborder=1> 
	<FRAME name=treeFrame frameborder=0 src=""> 
	<FRAME noresize scrolling=no name=optFrame frameborder=0 src="../html/dialog_confirm_sgl.html?s_css=${fn:escapeXml(param.s_css)}">
</FRAMESET>
</html>
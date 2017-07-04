<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/dialog_htmlhead.jsp" %>
<script type="text/javascript">
<!--
Com_IncludeFile("data.js");
//-->
</script>
<script>
var dialogRtnValue = null;
var dialogObject = null;
if(window.showModalDialog)
	dialogObject = window.dialogArguments;
else{
	dialogObject = opener.Com_Parameter.Dialog;
}
Com_Parameter.XMLDebug = dialogObject.XMLDebug;
var Data_XMLCatche = dialogObject.XMLCatche;
Com_AddEventListener(window, "beforeunload", beforeClose);

function Com_DialogReturn(value){
	window.dialogRtnValue = value;
	window.close();
}

function beforeClose(){
	dialogObject.rtnData = dialogRtnValue;
	dialogObject.AfterShow();
}
if(dialogObject.winTitle==null)
	dialogObject.winTitle = "<bean:message bundle="sys-organization" key="sysOrg.addressBook" />";

dialogObject.searchBeanURL = "organizationDialogSearch&orgType="+dialogObject.addressBookParameter.selectType+(dialogObject.addressBookParameter.startWith==null?"":"&startWith="+dialogObject.addressBookParameter.startWith);
dialogObject.dialogType = ${param.mul};
Com_SetWindowTitle(dialogObject.winTitle);
</script>
</head>
<%
	String dialogType = request.getParameter("mul");
	dialogType = (dialogType==null || dialogType.equals("1"))?"mul":"sgl";
%>
<FRAMESET cols="180,460" framespacing=3 frameborder=1> 
	<FRAME name=treeFrame scrolling=no frameborder=0 src="address_left_main.jsp?s_css=${fn:escapeXml(param.s_css)}"> 
	<FRAME name=optFrame frameborder=0 src="address_right_<%= dialogType %>.jsp?s_css=${fn:escapeXml(param.s_css)}">
</FRAMESET> 
</html>
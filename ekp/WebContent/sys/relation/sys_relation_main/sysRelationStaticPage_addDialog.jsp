<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp" %>
<center>
	<table width="95%">
		<input type="hidden" name="contentId">
		<tr style="height: 25px">	
			<td>
				<bean:message bundle="sys-relation" key="sysRelationMain.docTitle" />：<input type="text" class="inputSgl" size="35" name="docName"/>&nbsp;&nbsp;&nbsp;&nbsp;
			</td>
			<td>
				<input type="button" class="btnopt" value="<bean:message key="button.ok"/>" onclick="sysRelationStaticDialog_save();" />
			</td>
		</tr>
		<tr style="height: 25px">	
			<td>
				<bean:message bundle="sys-relation" key="sysRelationMain.docUrl" />：<input type="text" class="inputSgl" size="35" name="docUrl"/>&nbsp;&nbsp;&nbsp;&nbsp;
			</td>
			<td>
				<input type="reset" class="btnopt" value="<bean:message key="button.cancel" />" onclick="Com_CloseWindow();" />
			</td>
		</tr>
	</table>
</center>
<script>
var dialogObject = null;
if(window.showModalDialog){
	dialogObject = window.dialogArguments;
}else{
	dialogObject = opener._static_dialog;
}
function sysRelationStaticDialog_save(){
	var docName = document.getElementsByName("docName")[0].value;
	var docUrl = document.getElementsByName("docUrl")[0].value;
	var contentId = document.getElementsByName("contentId")[0].value;
	var obj = {'docName':docName,'docUrl':docUrl,'isSave':true,"contentId":contentId};
	if(docName == ""){
		alert('<bean:message bundle="sys-relation" key="sysRelationMain.docTitle" /><bean:message bundle="sys-relation" key="sysRelationMain.notNull" />');
		return;
	}
	if(docUrl == ""){
		alert('<bean:message bundle="sys-relation" key="sysRelationMain.docUrl" /><bean:message bundle="sys-relation" key="sysRelationMain.notNull" />');
		return;
	}
	window.dialogObject.rtnStaticData = obj;
	window.dialogObject.AfterShow();
	window.close();
}
window.onload = function(){
	if(window.dialogObject && window.dialogObject.staticData){
		if(window.dialogObject.staticData.docName)
			document.getElementsByName("docName")[0].value = window.dialogObject.staticData.docName;
		if(window.dialogObject.staticData.docUrl)
		 	document.getElementsByName("docUrl")[0].value = window.dialogObject.staticData.docUrl;
	 	if(window.dialogObject.staticData.contentId)
	 		document.getElementsByName("contentId")[0].value = window.dialogObject.staticData.contentId;
	}
};
</script>
<%@ include file="/resource/jsp/edit_down.jsp" %>
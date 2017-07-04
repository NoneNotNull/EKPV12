<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
<!--
function validateForm() {
	if (document.sysTransportImportUploadForm.file.value == "") {
		alert('<bean:message bundle="sys-transport" key="sysTransport.error.upload.fileEmpty"/>');
		return false;
	}
	else return true;
}
//-->
</script>
<html:form action="/sys/transport/sys_transport_import/SysTransportImportUpload.do?method=upload&fdModelName=${param.fdModelName }" 
	enctype="multipart/form-data"	onsubmit="return validateForm(this);">
	<html:hidden property="fdId" value="${param.fdId }"/>
<div id="optBarDiv">
	<input type="submit" value="<bean:message bundle="sys-transport" key="sysTransport.button.upload"/>">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="sys-transport" key="sysTransport.button.dataImport"/></p>

<center>
<table class="tb_normal" width="500">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-transport" key="sysTransport.upload.file"/>
		</td><td width=85% colspan="3">
			<html:file property="file" styleClass="upload" style="width:90%"/>
		</td>
	</tr>
</table>
<br/>
</center>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
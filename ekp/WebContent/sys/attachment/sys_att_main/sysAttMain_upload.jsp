<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/attachment/sys_att_main/sysAttMain.do" 
method="post" enctype="multipart/form-data" >
<div id="optBarDiv">

	<c:if test="${sysAttMainForm.method_GET=='upload'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysAttMainForm, 'save');">

	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<script>
var formFileLenght = 0;
function addFormFile(){
	formFileLenght++;
	var formFilesSpan = document.getElementById("_formFilesSpan");
	var fileStr = "<input type=file class=upload name=\"formFiles["+formFileLenght+"]\">";
	
    var file = document.createElement(fileStr);
    formFilesSpan.appendChild(file);
formFilesSpan.appendChild(document.createElement("<br>"));
}
</script>
<p class="txttitle"><bean:message  bundle="sys-attachment" key="table.sysAttMain"/><bean:message key="button.edit"/></p>

<center>
<table class="tb_normal" width=95%>

		<html:hidden property="fdId"/>
		<input type=hidden name="fdModelId">
		<input type=hidden name="fdModelName" value="${param.fdModelName }">
		<input type=hidden name="fdKey" value="${param.fdKey }">
		<input type=hidden name="fdAttType" value="${param.fdAttType }">
		
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-attachment" key="sysAttMain.chooseatt"/>
		</td><td width=35%>
			<span id="_formFilesSpan">
				<input type=file class="upload" name="formFiles[0]">
				<br>
			</span>
			<c:if test="${param.fdMulti != 'false' }">
			<input type=button value="<bean:message key="button.create"/>" onclick="addFormFile();">
			</c:if>
		</td>
		
	</tr>
	
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>

<%@ include file="/resource/jsp/edit_down.jsp"%>
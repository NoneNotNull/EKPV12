<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ page import="java.util.*"%>
<script type="text/javascript">
	Com_IncludeFile("docutil.js|calendar.js|dialog.js|optbar.js");
	function checkFile(){
		var file = document.getElementsByName("file");
		if(file[0].value==null || file[0].value.length==0){
			alert('请选择文件');
			return false ;
		}
		return true ;
	}
</script>
<html:form action="/kms/multidoc/kms_multidoc_template/kmsMultidocTemplate.do" enctype="multipart/form-data">
<div id="optBarDiv">
	<input
		type=button
		value="<bean:message key="kmsMultidocTemplate.downloadTemplateExcel" bundle="kms-multidoc"/>"
		onclick="Com_OpenWindow('<c:url value="/kms/multidoc/kms_multidoc_template/类别导入模板.xls" />');">
	<input
		type=button
		value="<bean:message key="kmsMultidocTemplate.upload" bundle="kms-multidoc"/>"
		onclick="Com_Submit(document.kmsMultidocTemplateForm, 'importExcel');">
	<input
		type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
	<p class="txttitle"><bean:message bundle="kms-multidoc"
		key="kmsMultidocTemplate.import" /></p>

	<center>
	<html:file property="file" style="width:50%"/>
	</center>
	<html:hidden property="method_GET" />
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>

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
<html:form action="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do" enctype="multipart/form-data">
<div id="optBarDiv"> <!--  bean:message key="kmsMultidocKnowledge.downloadTemplateExcel" bundle="kms-multidoc" -->
	<input
		type=button
		value="下载模板" 
		onclick="Com_OpenWindow('<c:url value="/kms/multidoc/kms_multidoc_knowledge/DocImportTemplate.xls" />');">
	<input
		type=button
		value="上传"
		onclick="Com_Submit(document.kmsMultidocKnowledgeForm, 'saveExcel');">
	<input
		type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
	<p class="txttitle">导入</p>

	<center>
	<html:file property="file" style="width:50%"/>
	</center>
	<html:hidden property="method_GET" />
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>

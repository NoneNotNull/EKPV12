<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>

</script>
<kmss:windowTitle subjectKey="sys-lbpmservice-support:lbpmTemplate.import.title" />
<p class="txttitle"><kmss:message key="sys-lbpmservice-support:lbpmTemplate.import.title" /></p>

<form action="<c:url value="/sys/lbpmservice/support/lbpm_template_exportandimport/lbpmTemplateExportAndImport.do" />" 
	enctype="multipart/form-data" method="POST">
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<kmss:message key="sys-lbpmservice-support:lbpmTemplate.import.template" />
		</td><td width="85%" colspan="3">
			<c:out value="${requestScope.templateName }" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<kmss:message key="sys-lbpmservice-support:lbpmTemplate.import.file" />
		</td><td width="85%" colspan="3">
			<input type="file" class="upload" name="importFile" style="width:80%">
		</td>
	</tr>
</table>
<input type="hidden" name="method" value="importDefinition">
<input type="hidden" name="fdId" value="${requestScope.templateId }">
<input type="hidden" name="fdModelName" value="${param.fdModelName }">
<input type="submit" class="btnopt" value="<kmss:message key="button.ok" />">
<input type="reset" class="btnopt" value="<kmss:message key="button.cancel" />" onclick="window.close();">
</center>
</form>

<%@ include file="/resource/jsp/edit_down.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<div id="importDefinition" style="display:none;">
<input
	type="button"
	value="<kmss:message key="sys-lbpmservice-support:lbpmTemplate.import.button" />"
	onclick="importDefinition();">
</div>
<script>
function importDefinition() {
	var values=[];
	var selected = false;
	var select = document.getElementsByName("List_Selected");
	for(var i=0;i<select.length;i++) {
		if(select[i].checked){
			values.push("List_Selected=" + select[i].value);
			selected=true;
		}
	}
	if(!selected) {
		alert("<kmss:message key="dialog.requiredSelect" />");
		return false;
	}
	if(values.length > 1) {
		alert("<kmss:message key="sys-lbpmservice-support:lbpmTemplate.import.selectone" />");
		return false;
	}
	var q = values.join("&");
	window.open('<c:url value="/sys/lbpmservice/support/lbpm_template_exportandimport/lbpmTemplateExportAndImport.do">
			<c:param name="method" value="importView" />
			<c:param name="fdModelName" value="${param.fdModelName}" />
	</c:url>&'+q);
	return true;
}
OptBar_AddOptBar("importDefinition");
</script>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/kms/knowledge/kms_knowledge_doc_template/kmsKnowledgeDocTemplate.do">
<div id="optBarDiv">
	<c:if test="${kmsKnowledgeDocTemplateForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmsKnowledgeDocTemplateForm, 'update');">
	</c:if>
	<c:if test="${kmsKnowledgeDocTemplateForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmsKnowledgeDocTemplateForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmsKnowledgeDocTemplateForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-knowledge" key="table.kmsKnowledgeDocTemplate"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeDocTemplate.fdName"/>
		</td><td width="35%" colspan="3">
			<xform:text property="fdName" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeDocTemplate.fdOrder"/>
		</td><td width="85%" colspan="3">
			<xform:text property="fdOrder" style="width:35%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeDocTemplate.docContent"/>
		</td>
		<td width=85% colspan="3"><kmss:editor property="docContent" height="400" /></td>
	</tr>
	<c:if test="${not empty kmsKnowledgeDocTemplateForm.docCreatorId }">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeDocTemplate.docCreator"/>
		</td><td width="35%">
			<xform:address propertyId="docCreatorId" propertyName="docCreatorName" orgType="ORG_TYPE_PERSON" showStatus="view" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-knowledge" key="kmsKnowledgeDocTemplate.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime" showStatus="view" />
		</td>
	</tr>
	</c:if>
	<tr>
		<td
			class="td_normal_title"
			width="15%"><bean:message
			bundle="kms-knowledge"
			key="kmsKnowledge.rattachement" /></td>
		<td colspan="3"><c:import
			url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp"
			charEncoding="UTF-8">
			<c:param
				name="fdKey"
				value="rattachment" />
		</c:import></td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
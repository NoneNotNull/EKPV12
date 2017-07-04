<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/kms/kmtopic/kms_kmtopic_category/kmsKmtopicCategory.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmsKmtopicCategory.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/kms/kmtopic/kms_kmtopic_category/kmsKmtopicCategory.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmsKmtopicCategory.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-kmtopic" key="table.kmsKmtopicCategory"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-kmtopic" key="kmsKmtopicCategory.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-kmtopic" key="kmsKmtopicCategory.fdOrder"/>
		</td><td width="35%">
			<xform:text property="fdOrder" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-kmtopic" key="kmsKmtopicCategory.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-kmtopic" key="kmsKmtopicCategory.docAlterTime"/>
		</td><td width="35%">
			<xform:datetime property="docAlterTime" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-kmtopic" key="kmsKmtopicCategory.fdHierarchyId"/>
		</td><td width="35%">
			<xform:text property="fdHierarchyId" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-kmtopic" key="kmsKmtopicCategory.docCreator"/>
		</td><td width="35%">
			<c:out value="${kmsKmtopicCategoryForm.docCreatorName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-kmtopic" key="kmsKmtopicCategory.docAlteror"/>
		</td><td width="35%">
			<c:out value="${kmsKmtopicCategoryForm.docAlterorName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-kmtopic" key="kmsKmtopicCategory.hbmParent"/>
		</td><td width="35%">
			<c:out value="${kmsKmtopicCategoryForm.hbmParentName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-kmtopic" key="kmsKmtopicCategory.authReaders"/>
		</td><td width="35%">
			<c:out value="${kmsKmtopicCategoryForm.authReaderNames}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-kmtopic" key="kmsKmtopicCategory.authEditors"/>
		</td><td width="35%">
			<c:out value="${kmsKmtopicCategoryForm.authEditorNames}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-kmtopic" key="kmsKmtopicCategory.authOtherReaders"/>
		</td><td width="35%">
			<c:out value="${kmsKmtopicCategoryForm.authOtherReaderNames}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-kmtopic" key="kmsKmtopicCategory.authOtherEditors"/>
		</td><td width="35%">
			<c:out value="${kmsKmtopicCategoryForm.authOtherEditorNames}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-kmtopic" key="kmsKmtopicCategory.authAllReaders"/>
		</td><td width="35%">
			<c:out value="${kmsKmtopicCategoryForm.authAllReaderNames}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-kmtopic" key="kmsKmtopicCategory.authAllEditors"/>
		</td><td width="35%">
			<c:out value="${kmsKmtopicCategoryForm.authAllEditorNames}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-kmtopic" key="kmsKmtopicCategory.authTmpReaders"/>
		</td><td width="35%">
			<c:out value="${kmsKmtopicCategoryForm.authTmpReaderNames}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-kmtopic" key="kmsKmtopicCategory.authTmpEditors"/>
		</td><td width="35%">
			<c:out value="${kmsKmtopicCategoryForm.authTmpEditorNames}" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
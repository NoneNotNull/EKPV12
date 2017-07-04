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
	<kmss:auth requestURL="/kms/wiki/kms_wiki_category/kmsWikiCategory.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmsWikiCategory.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/kms/wiki/kms_wiki_category/kmsWikiCategory.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmsWikiCategory.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-wiki" key="table.kmsWikiCategory"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCategory.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCategory.fdOrder"/>
		</td><td width="35%">
			<xform:text property="fdOrder" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCategory.fdParentId"/>
		</td><td width="35%">
			<xform:text property="fdParentId" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCategory.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCategory.docAlterTime"/>
		</td><td width="35%">
			<xform:datetime property="docAlterTime" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCategory.fdTemplate"/>
		</td><td width="35%">
			<c:out value="${kmsWikiCategoryForm.fdTemplateName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCategory.docCreator"/>
		</td><td width="35%">
			<c:out value="${kmsWikiCategoryForm.docCreatorName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCategory.docAlteror"/>
		</td><td width="35%">
			<c:out value="${kmsWikiCategoryForm.docAlterorName}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCategory.authReaders"/>
		</td><td width="35%">
			<c:out value="${kmsWikiCategoryForm.authReaderNames}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCategory.authEditors"/>
		</td><td width="35%">
			<c:out value="${kmsWikiCategoryForm.authEditorNames}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCategory.authOtherReaders"/>
		</td><td width="35%">
			<c:out value="${kmsWikiCategoryForm.authOtherReaderNames}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCategory.authOtherEditors"/>
		</td><td width="35%">
			<c:out value="${kmsWikiCategoryForm.authOtherEditorNames}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCategory.authAllReaders"/>
		</td><td width="35%">
			<c:out value="${kmsWikiCategoryForm.authAllReaderNames}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCategory.authAllEditors"/>
		</td><td width="35%">
			<c:out value="${kmsWikiCategoryForm.authAllEditorNames}" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCategory.authTmpReaders"/>
		</td><td width="35%">
			<c:out value="${kmsWikiCategoryForm.authTmpReaderNames}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCategory.authTmpEditors"/>
		</td><td width="35%">
			<c:out value="${kmsWikiCategoryForm.authTmpEditorNames}" />
		</td>
	</tr>
	<%----发布机制--%>
		<c:import url="/sys/news/include/sysNewsPublishCategory_view.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmsWikiCategoryForm" />
			<c:param name="fdKey" value="mainDoc" />
		</c:import>
	<c:import url="/sys/workflow/include/sysWfTemplate_view.jsp" charEncoding="UTF-8">
		<c:param name="formName" value="kmsWikiCategoryForm" />
		<c:param name="fdKey" value="wikiFlow" />
	</c:import>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
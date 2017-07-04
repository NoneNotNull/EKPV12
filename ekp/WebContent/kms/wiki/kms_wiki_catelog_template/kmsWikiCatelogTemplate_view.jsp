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
	<kmss:auth requestURL="/kms/wiki/kms_wiki_catelog_template/kmsWikiCatelogTemplate.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmsWikiCatelogTemplate.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/kms/wiki/kms_wiki_catelog_template/kmsWikiCatelogTemplate.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmsWikiCatelogTemplate.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="kms-wiki" key="table.kmsWikiCatelogTemplate"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCatelogTemplate.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCatelogTemplate.fdOrder"/>
		</td><td width="35%">
			<xform:text property="fdOrder" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCatelogTemplate.docContent"/>
		</td><td width="35%">
			<xform:rtf property="docContent" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCatelogTemplate.fdKey"/>
		</td><td width="35%">
			<xform:text property="fdKey" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCatelogTemplate.fdTemplate"/>
		</td><td width="35%">
			<c:out value="${kmsWikiCatelogTemplateForm.fdTemplateName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-wiki" key="kmsWikiCatelogTemplate.authTmpEditors"/>
		</td><td width="35%">
			<c:out value="${kmsWikiCatelogTemplateForm.authTmpEditorNames}" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>